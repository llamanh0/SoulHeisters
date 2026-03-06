using Unity.Netcode;
using UnityEngine;
using UnityEngine.Animations.Rigging;

/// <summary>
/// Oyuncunun gorsel tarafini (animator, IK, ragdoll gecisi) yonetir.
/// 
/// Sorumluluklar:
/// - Animator parametrelerini Locomotion ve CharacterController'a gore guncellemek
/// - Aim rig'ini (el IK, global aim) kontrol etmek
/// - Olum aninda ragdoll'u devreye sokmak
/// 
/// Network Notlari:
/// - Animasyon parametrelerini guncellemek icin owner olma zorunlulugu yok.
/// - Fakat aim rig icin input gerektigi icin sadece owner tarafinda rig guncellenir.
/// </summary>
public class PlayerVisualController : NetworkBehaviour
{
    [Header("Animator")]
    [SerializeField] private Animator animator;
    [SerializeField] private CharacterController characterController;

    [Header("Rig")]
    [SerializeField] private Rig mainRig;
    [SerializeField] private Transform handIkTarget;
    [SerializeField] private Transform elbowHint;
    [SerializeField] private Transform globalAimTarget;

    [Header("Ragdoll")]
    [SerializeField] private RagdollController ragdollController;
    [SerializeField] private Collider mainCapsuleCollider;

    [Header("Settings")]
    [SerializeField] private float aimSpeed = 15f;

    private PlayerReferences _refs;

    // Animator parametre ID cache
    private int _speedParamID;
    private int _isGroundedParamID;
    private int _verticalVelocityParamID;

    private void Awake()
    {
        _refs = GetComponentInParent<PlayerReferences>();

        _speedParamID = Animator.StringToHash("Speed");
        _isGroundedParamID = Animator.StringToHash("IsGrounded");
        _verticalVelocityParamID = Animator.StringToHash("VerticalVelocity");
    }

    private void Update()
    {
        UpdateAnimator();
    }

    private void LateUpdate()
    {
        // Aim rig guncellemesi sadece owner icin yapilir
        if (!IsOwner) return;

        bool isAiming = _refs.Input.AimInput || _refs.Input.FireInput;
        UpdateRig(isAiming);
    }

    /// <summary>
    /// Animator parametrelerini gunceller (speed, grounded, vertical velocity).
    /// Oyun biterse Idle animasyonuna zorlar (speed ve Vertical Velocity degerini 0'a zorlar).
    /// </summary>
    private void UpdateAnimator()
    {
        if (animator == null) return;

        bool isPlaying = GameStateManager.Instance == null ||
                         GameStateManager.Instance.CurrentState == GameState.Playing;

        if (_refs.Locomotion != null)
        {
            float speed = isPlaying ? _refs.Locomotion.CurrentMoveSpeed : 0f;
            animator.SetFloat(_speedParamID, speed, 0.1f, Time.deltaTime);
        }

        if (characterController != null)
        {
            // Match bitmis olsa bile grounded bilgisini guncellemek sorun degil
            bool grounded = characterController.isGrounded;
            animator.SetBool(_isGroundedParamID, grounded);
        }

        if (_refs.Locomotion != null)
        {
            float verticalVelocity = isPlaying ? _refs.Locomotion.VerticalVelocity : 0f;
            animator.SetFloat(_verticalVelocityParamID, verticalVelocity);
        }
    }

    /// <summary>
    /// Ana aim rig'inin agirligini ve hedef pozisyonlarini gunceller.
    /// </summary>
    private void UpdateRig(bool isAiming)
    {
        float targetWeight = isAiming ? 1f : 0f;
        mainRig.weight = Mathf.Lerp(mainRig.weight, targetWeight, Time.deltaTime * 10f);

        if (mainRig.weight < 0.01f) return;

        if (isAiming)
            UpdateAim();
        else
            UpdateIdle();
    }

    /// <summary>
    /// Aim durumunda IK hedefini global aim noktasina dogru hareket ettirir.
    /// </summary>
    private void UpdateAim()
    {
        Vector3 targetPos = globalAimTarget.position;

        handIkTarget.position =
            Vector3.Lerp(handIkTarget.position, targetPos, Time.deltaTime * aimSpeed);

        Vector3 lookDir = (targetPos - transform.position).normalized;
        handIkTarget.rotation = Quaternion.LookRotation(lookDir);
    }

    /// <summary>
    /// Aim yokken IK hedefinin rotasyonunu karakterle hizalar.
    /// </summary>
    private void UpdateIdle()
    {
        handIkTarget.rotation = transform.rotation;
    }

    /// <summary>
    /// Olum aninda ragdoll'u devreye sokar ve ana kapsul collider'i kapatir.
    /// Animator uzerinden "Die" trigger'ini da tetikler.
    /// </summary>
    public void HandleDeathVisual()
    {
        if (mainCapsuleCollider != null)
            mainCapsuleCollider.enabled = false;

        if (ragdollController != null)
            ragdollController.EnableRagdoll();

        if (animator != null)
            animator.SetTrigger("Die");
    }
}