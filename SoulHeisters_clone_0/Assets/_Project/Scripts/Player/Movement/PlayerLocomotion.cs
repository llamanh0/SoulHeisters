using Cinemachine;
using Unity.Netcode;
using UnityEngine;

/// <summary>
/// Oyuncunun hareket ve kamera kontrolunu yoneten sinif.
/// 
/// Sorumluluklar:
/// - CharacterController ile yuru, ziplama, dusme hesaplari
/// - Cinemachine TPS kamera kontrolu
/// - Owner icin input'a gore hareket; diger client'lar icin sadece goruntu sync
/// 
/// Network Notlari:
/// - Bu script NetworkBehaviour'dan turemis.
/// - Owner olan client input okur ve kendi transform'unu hareket ettirir.
/// - Diger client'lar icin sadece _netVisualRotationY uzerinden rotasyon sync edilir.
/// </summary>
[RequireComponent(typeof(CharacterController))]
public class PlayerLocomotion : NetworkBehaviour
{
    [Header("Movement")]
    [SerializeField] private float walkSpeed = 5f;
    [SerializeField] private float sprintSpeed = 8f;
    [SerializeField] private float rotationSpeed = 10f;
    [SerializeField] private float airControlMultiplier = 0.4f;

    [Header("Jump & Gravity")]
    [SerializeField] private float jumpHeight = 1.5f;
    [SerializeField] private float gravity = -9.81f;
    [SerializeField] private float fallMultiplier = 2.5f;

    [Header("Camera")]
    [SerializeField] private CinemachineVirtualCamera tpsCamera;
    [SerializeField] private GameObject cameraRoot;
    [SerializeField] private float mouseSensitivity = 0.03f;
    [SerializeField] private float topClamp = 70f;
    [SerializeField] private float bottomClamp = -40f;

    /// <summary> Su anki yuru/sprint hizini animator icin disariya acar. </summary>
    public float CurrentMoveSpeed { get; private set; }

    // Yalnizca owner yazabilir, herkes okuyabilir → goruntu rotasyon sync
    private NetworkVariable<float> _netVisualRotationY = new(
        0f,
        NetworkVariableReadPermission.Everyone,
        NetworkVariableWritePermission.Owner
    );

    private CharacterController _controller;
    private Transform _cameraTransform;
    private Vector3 _velocity;
    private float _cinemachineTargetPitch;
    private float _cinemachineTargetYaw;

    private PlayerReferences _refs;

    private void Awake()
    {
        _controller = GetComponent<CharacterController>();
        _refs = GetComponent<PlayerReferences>();
    }

    public override void OnNetworkSpawn()
    {
        if (IsOwner)
        {
            // Sadece local owner icin kamera referansi al
            _cameraTransform = Camera.main.transform;
            Cursor.lockState = CursorLockMode.Locked;
            Cursor.visible = false;

            if (tpsCamera != null)
            {
                tpsCamera.Follow = cameraRoot.transform;
                tpsCamera.LookAt = cameraRoot.transform;
            }
        }
        else
        {
            // Diger client'lar icin bu oyuncunun TPS kamerasini kapat
            if (tpsCamera) tpsCamera.gameObject.SetActive(false);
        }
    }

    private void Update()
    {
        // Owner olmayan client'lar icin sadece goruntu rotasyonunu yavasca yaklastir
        if (!IsOwner)
        {
            SyncVisualRotation();
        }
    }

    private void LateUpdate()
    {
        if (!IsOwner) return;

        UpdateCameraRotation();
    }

    // ═════════════════════ Public API (State'ler kullanacak) ═════════════════════

    /// <summary>
    /// Her frame cagrilmasi gereken gravity hesabi.
    /// State makinesi tarafindan Update'te cagrilir.
    /// </summary>
    public void ApplyGravity()
    {
        if (_controller.isGrounded && _velocity.y < 0f)
        {
            // Yere basarken hafif negatif deger, CharacterController icin standart
            _velocity.y = -2f;
        }
        else
        {
            float multiplier = _velocity.y < 0f ? fallMultiplier : 1f;
            _velocity.y += gravity * multiplier * Time.deltaTime;
        }

        _controller.Move(new Vector3(0f, _velocity.y, 0f) * Time.deltaTime);
    }

    /// <summary>
    /// Yatay hareket (yurume/sprint). Kamera yonune gore hesaplanir.
    /// isAirborne true ise, hava kontrolu azalarak daha yavas hareket edilir.
    /// </summary>
    public void Move(Vector2 input, bool sprint, bool isAirborne = false)
    {
        if (_cameraTransform == null || input == Vector2.zero)
        {
            CurrentMoveSpeed = 0f;
            return;
        }

        // Kamera eksenine gore yon vektoru hesapla
        Vector3 camForward = _cameraTransform.forward;
        Vector3 camRight = _cameraTransform.right;
        camForward.y = 0f;
        camRight.y = 0f;
        camForward.Normalize();
        camRight.Normalize();

        Vector3 direction = (camForward * input.y + camRight * input.x).normalized;

        // Karakter modelini hareket yonune dondur
        if (direction != Vector3.zero)
        {
            Quaternion targetRot = Quaternion.LookRotation(direction);
            transform.rotation = Quaternion.Slerp(
                transform.rotation,
                targetRot,
                rotationSpeed * Time.deltaTime
            );

            // Bu rotasyon degerini network'e yaz (owner)
            _netVisualRotationY.Value = transform.eulerAngles.y;
        }

        float speed = sprint ? sprintSpeed : walkSpeed;
        if (isAirborne) speed *= airControlMultiplier;

        _controller.Move(direction * speed * Time.deltaTime);
        CurrentMoveSpeed = input.magnitude * speed;
    }

    /// <summary>
    /// Ziplama baslangic kuvvetini uygular.
    /// </summary>
    public void Jump()
    {
        _velocity.y = Mathf.Sqrt(jumpHeight * -2f * gravity);
    }

    /// <summary>
    /// Ornegin blink gibi teleport isleminden sonra dikey hizi sifirlamak icin.
    /// </summary>
    public void ResetVerticalVelocity()
    {
        _velocity.y = 0f;
    }

    // Query fonksiyonlari (state gecisleri icin)

    public bool IsGrounded() => _controller.isGrounded;
    public bool IsFalling() => _velocity.y < 0f && !_controller.isGrounded;
    public bool IsRising() => _velocity.y > 0.1f;
    public float VerticalVelocity => _velocity.y;

    // ═════════════════════ Private Helpers ═════════════════════

    /// <summary>
    /// Owner icin kamera rotasyonunu mouse input'a gore gunceller.
    /// </summary>
    private void UpdateCameraRotation()
    {
        if (_refs == null || _refs.Input == null) return;

        Vector2 look = _refs.Input.LookInput;

        if (look.sqrMagnitude >= 0.01f)
        {
            _cinemachineTargetYaw += look.x * mouseSensitivity;
            _cinemachineTargetPitch -= look.y * mouseSensitivity;
        }

        _cinemachineTargetYaw = ClampAngle(_cinemachineTargetYaw, float.MinValue, float.MaxValue);
        _cinemachineTargetPitch = ClampAngle(_cinemachineTargetPitch, bottomClamp, topClamp);

        cameraRoot.transform.rotation = Quaternion.Euler(
            _cinemachineTargetPitch, _cinemachineTargetYaw, 0f
        );
    }

    /// <summary>
    /// Owner olmayan client'lar icin, network'ten gelen rotasyon degerine
    /// yavasca dogru yaklasarak goruntu yumsatilir.
    /// </summary>
    private void SyncVisualRotation()
    {
        Quaternion target = Quaternion.Euler(0f, _netVisualRotationY.Value, 0f);
        transform.rotation = Quaternion.Slerp(
            transform.rotation,
            target,
            rotationSpeed * Time.deltaTime
        );
    }

    private static float ClampAngle(float angle, float min, float max)
    {
        if (angle < -360f) angle += 360f;
        if (angle > 360f) angle -= 360f;
        return Mathf.Clamp(angle, min, max);
    }
}