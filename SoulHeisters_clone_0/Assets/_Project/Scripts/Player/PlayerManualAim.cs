using Unity.Netcode;
using UnityEngine;

public class ProProceduralAim : NetworkBehaviour
{
    [Header("--- HIZ & AKICILIK (SMOOTHING) ---")]
    [Tooltip("Dönüşlerin ne kadar sürede tamamlanacağı (Daha düşük = Daha hızlı)")]
    public float bodySmoothTime = 0.1f;
    public float armSmoothTime = 0.05f; // Kol vücuttan biraz daha atik olmalı
    public float aimToggleSpeed = 10f;  // Nişan alma/bırakma hızı

    [Header("--- OMURGA (SPINE) ---")]
    public Vector3 spineOffset = new Vector3(0, 0, 0);
    [Range(0, 90)] public float maxSpineAngleY = 60f; // Sağa/Sola ne kadar dönebilir?
    [Range(0, 90)] public float maxSpineAngleX = 50f; // Yukarı/Aşağı ne kadar bakabilir?

    [Header("--- KOL (ARM) ---")]
    // Senin bulduğun değerler: 180, 15, 90 (Burayı kendine göre yine ayarla)
    public Vector3 armBaseOffset = new Vector3(180, 15, 90);

    [Header("--- ANTI-CLIPPING (İÇ İÇE GEÇME ÖNLEYİCİ) ---")]
    [Tooltip("Karakter ne kadar sola dönünce koruma başlasın?")]
    [Range(-90, 0)] public float clipStartAngle = -10f;
    [Tooltip("Maksimum sola dönüşte kol ne kadar dışarı itilsin?")]
    public Vector3 clipAvoidanceOffset = new Vector3(0, 30, 15); // Kolu yukarı ve dışarı iter

    [Header("--- REFERANSLAR ---")]
    public Transform spineBone;
    public Transform shoulderBone;
    public Transform elbowBone;
    [Range(0, 90)] public float elbowStraightenFactor = 10f;

    // --- PRIVATE VARIABLES ---
    private Transform _cameraTransform;

    // Network Değişkenleri
    private NetworkVariable<Vector3> _netAimPos = new NetworkVariable<Vector3>(default, NetworkVariableReadPermission.Everyone, NetworkVariableWritePermission.Owner);
    private NetworkVariable<bool> _netIsAiming = new NetworkVariable<bool>(false, NetworkVariableReadPermission.Everyone, NetworkVariableWritePermission.Owner);

    // SmoothDamp için hız referansları (Ref ile çalışır)
    private float _spineVelX, _spineVelY;
    private float _currentSpineX, _currentSpineY;

    private Vector3 _currentArmOffset;
    private Vector3 _armOffsetVel;

    private float _aimWeight;

    private void Awake()
    {
        // Otomatik Kemik Bulucu
        Animator anim = GetComponent<Animator>();
        if (anim != null && anim.isHuman)
        {
            if (!spineBone) spineBone = anim.GetBoneTransform(HumanBodyBones.Chest) ?? anim.GetBoneTransform(HumanBodyBones.Spine);
            if (!shoulderBone) shoulderBone = anim.GetBoneTransform(HumanBodyBones.RightUpperArm);
            if (!elbowBone) elbowBone = anim.GetBoneTransform(HumanBodyBones.RightLowerArm);
        }

        // Başlangıç ofsetini set et
        _currentArmOffset = armBaseOffset;
    }

    public override void OnNetworkSpawn()
    {
        if (IsOwner && Camera.main) _cameraTransform = Camera.main.transform;
    }

    private void Update()
    {
        if (IsOwner) HandleInput();
    }

    private void LateUpdate()
    {
        if (!spineBone || !shoulderBone) return;

        // 1. Aim Ağırlığını Hesapla (Yumuşak Geçiş)
        float targetWeight = _netIsAiming.Value ? 1f : 0f;
        _aimWeight = Mathf.Lerp(_aimWeight, targetWeight, Time.deltaTime * aimToggleSpeed);

        if (_aimWeight < 0.01f) return; // Nişan almıyorsak işlemciyi yorma

        // 2. Hesaplamaları Başlat
        ProcessAiming();
    }

    private void HandleInput()
    {
        //bool aiming = Input.GetMouseButton(1);
        bool aiming = true;
        if (_netIsAiming.Value != aiming) _netIsAiming.Value = aiming;

        if (_cameraTransform && aiming)
        {
            // Hedef noktayı güncelle (50m ileri)
            Vector3 targetPoint = _cameraTransform.position + _cameraTransform.forward * 50f;
            if (Vector3.Distance(_netAimPosition.Value, targetPoint) > 0.1f)
            {
                _netAimPosition.Value = targetPoint;
            }
        }
    }

    // Ağ değişkenine erişim için property (Yukarıdaki _netAimPos ile karışmasın)
    private NetworkVariable<Vector3> _netAimPosition => _netAimPos;

    private void ProcessAiming()
    {
        Vector3 targetPoint = _netAimPosition.Value;

        // --- AŞAMA 1: OMURGA (SPINE) HESABI ---

        // Hedefe olan yön vektörü
        Vector3 dirToTarget = (targetPoint - transform.position).normalized;

        // Vücuda göre yerel açı (Local Space)
        Vector3 localDir = transform.InverseTransformDirection(dirToTarget);
        Vector3 targetEuler = Quaternion.LookRotation(localDir).eulerAngles;

        // Açıları -180/180 formatına çevir
        float yAngle = NormalizeAngle(targetEuler.y);
        float xAngle = NormalizeAngle(targetEuler.x);

        // Limitleri uygula (Clamp)
        yAngle = Mathf.Clamp(yAngle, -maxSpineAngleY, maxSpineAngleY);
        xAngle = Mathf.Clamp(xAngle, -maxSpineAngleX, maxSpineAngleX);

        // SmoothDamp: Lerp'ten daha üstündür. Fiziksel ivmelenme katar.
        // "Tak" diye durmayı engelleyen şey budur.
        _currentSpineX = Mathf.SmoothDamp(_currentSpineX, xAngle, ref _spineVelX, bodySmoothTime);
        _currentSpineY = Mathf.SmoothDamp(_currentSpineY, yAngle, ref _spineVelY, bodySmoothTime);

        // Omurgayı döndür
        Quaternion spineTargetRot = transform.rotation * Quaternion.Euler(_currentSpineX, _currentSpineY, 0) * Quaternion.Euler(spineOffset);
        spineBone.rotation = Quaternion.Slerp(spineBone.rotation, spineTargetRot, _aimWeight);


        // --- AŞAMA 2: KOL & ANTI-CLIPPING HESABI ---

        // Kolun hedef ofsetini belirle (Varsayılan değer)
        Vector3 targetArmOffset = armBaseOffset;

        // Omurga sola döndükçe (Negatif Y), kol tehlikeye girer.
        // Eğer açı 'clipStartAngle'dan (-10) daha küçükse (daha sola), koruma başlar.
        if (_currentSpineY < clipStartAngle)
        {
            // Ne kadar tehlikedeyiz? (0 ile 1 arası bir oran)
            // Örn: Açı -10 ise factor 0, Açı -60 ise factor 1.
            float factor = Mathf.InverseLerp(clipStartAngle, -maxSpineAngleY, _currentSpineY);

            // Ofseti bu orana göre kaydır (Kolu dışarı it)
            // Vector3.Lerp kullanarak yumuşakça değerler arasına geçiş yapıyoruz.
            targetArmOffset = Vector3.Lerp(armBaseOffset, armBaseOffset + clipAvoidanceOffset, factor);
        }

        // Ofset Değişimini de Yumuşat (SmoothDamp Vector3)
        // Bu sayede kol pozisyon değiştirirken titremez veya ışınlanmaz.
        _currentArmOffset = Vector3.SmoothDamp(_currentArmOffset, targetArmOffset, ref _armOffsetVel, armSmoothTime);

        // Kolu Dünyadaki hedefe kilitle
        Vector3 armDir = (targetPoint - shoulderBone.position).normalized;
        Quaternion armLookRot = Quaternion.LookRotation(armDir);

        // Hesaplanan dinamik ofseti uygula
        Quaternion finalArmRot = armLookRot * Quaternion.Euler(_currentArmOffset);
        shoulderBone.rotation = Quaternion.Slerp(shoulderBone.rotation, finalArmRot, _aimWeight);


        // --- AŞAMA 3: DİRSEK (ELBOW) ---
        if (elbowBone)
        {
            Quaternion straightParams = Quaternion.Euler(elbowStraightenFactor, 0, 0);
            elbowBone.localRotation = Quaternion.Slerp(elbowBone.localRotation, straightParams, _aimWeight);
        }
    }

    private float NormalizeAngle(float angle)
    {
        if (angle > 180f) angle -= 360f;
        return angle;
    }
}