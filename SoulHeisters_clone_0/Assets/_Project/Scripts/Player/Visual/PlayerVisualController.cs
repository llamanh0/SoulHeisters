using Unity.Netcode;
using UnityEngine;
using UnityEngine.Animations.Rigging;

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

    private int _speedParamID;
    private int _isGroundedParamID;

    private void Awake()
    {
        _refs = GetComponentInParent<PlayerReferences>();

        _speedParamID = Animator.StringToHash("Speed");
        _isGroundedParamID = Animator.StringToHash("IsGrounded");
    }

    private void Update()
    {
        if (!IsOwner) return;

        UpdateAnimator();
    }

    private void LateUpdate()
    {
        if (!IsOwner) return;

        bool isAiming = _refs.Input.AimInput || _refs.Input.FireInput;
        UpdateRig(isAiming);
    }

    // =========================
    // Animator Logic
    // =========================
    private void UpdateAnimator()
    {
        if (_refs.Locomotion != null)
        {
            float speed = _refs.Locomotion.CurrentMoveSpeed;
            animator.SetFloat(_speedParamID, speed, 0.1f, Time.deltaTime);
        }

        if (characterController != null)
        {
            animator.SetBool(_isGroundedParamID, characterController.isGrounded);
        }
    }

    // =========================
    // Rig Logic
    // =========================
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

    private void UpdateAim()
    {
        Vector3 targetPos = globalAimTarget.position;

        handIkTarget.position =
            Vector3.Lerp(handIkTarget.position, targetPos, Time.deltaTime * aimSpeed);

        Vector3 lookDir = (targetPos - transform.position).normalized;
        handIkTarget.rotation = Quaternion.LookRotation(lookDir);
    }

    private void UpdateIdle()
    {
        handIkTarget.rotation = transform.rotation;
    }

    // =========================
    // Death Visual
    // =========================
    public void HandleDeathVisual()
    {
        if (mainCapsuleCollider != null)
            mainCapsuleCollider.enabled = false;

        if (ragdollController != null)
            ragdollController.EnableRagdoll();

        animator.SetTrigger("Die");
    }
}