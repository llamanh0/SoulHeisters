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

    [Header("Network Settings")]
    [SerializeField] private float animatorUpdateRate = 0.1f;

    private float _lastAnimatorUpdate;
    private PlayerReferences _refs;
    private int _speedParamID;
    private int _isGroundedParamID;
    private int _verticalVelocityParamID;

    private Vector3 _originalHandIkLocalPos;
    private Quaternion _originalHandIkLocalRot;

    private void Awake()
    {
        _refs = GetComponentInParent<PlayerReferences>();
        _speedParamID = Animator.StringToHash("Speed");
        _isGroundedParamID = Animator.StringToHash("IsGrounded");
        _verticalVelocityParamID = Animator.StringToHash("VerticalVelocity");

        if (handIkTarget != null)
        {
            _originalHandIkLocalPos = handIkTarget.localPosition;
            _originalHandIkLocalRot = handIkTarget.localRotation;
        }
    }

    private void LateUpdate()
    {
        if (IsOwner)
        {
            UpdateAnimator();
            UpdateRig(_refs.Input.AimInput || _refs.Input.FireInput);
        }
        else
        {
            if (Time.time - _lastAnimatorUpdate >= animatorUpdateRate)
            {
                _lastAnimatorUpdate = Time.time;
                UpdateAnimator();
            }
            UpdateRig(mainRig != null && mainRig.weight > 0.5f);
        }
    }

    private void UpdateAnimator()
    {
        if (animator == null) return;

        bool isPlaying = GameStateManager.Instance == null ||
            GameStateManager.Instance.CurrentState == GameState.Playing;

        if (_refs.Locomotion != null)
        {
            float speed = isPlaying ? _refs.Locomotion.CurrentMoveSpeed : 0f;
            animator.SetFloat(_speedParamID, speed);
        }

        if (characterController != null)
        {
            bool grounded = characterController.isGrounded;
            animator.SetBool(_isGroundedParamID, grounded);
        }

        if (_refs.Locomotion != null)
        {
            float verticalVelocity = isPlaying ? _refs.Locomotion.VerticalVelocity : 0f;
            animator.SetFloat(_verticalVelocityParamID, verticalVelocity);
        }
    }

    private void UpdateRig(bool isAiming)
    {
        if (mainRig == null) return;

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
        if (globalAimTarget == null || handIkTarget == null) return;

        Vector3 targetPos = globalAimTarget.position;
        handIkTarget.position = Vector3.Lerp(handIkTarget.position, targetPos, Time.deltaTime * aimSpeed);

        Vector3 lookDir = (targetPos - transform.position).normalized;
        handIkTarget.rotation = Quaternion.LookRotation(lookDir);
    }

    private void UpdateIdle()
    {
        if (handIkTarget == null) return;
        handIkTarget.rotation = transform.rotation;
    }

    public void HandleDeathVisual()
    {
        if (mainCapsuleCollider != null)
        {
            mainCapsuleCollider.enabled = false;
        }

        if (ragdollController != null)
        {
            ragdollController.EnableRagdoll();
        }

        if (animator != null)
        {
            animator.enabled = false;
        }
    }

    public void ResetVisual()
    {
        if (ragdollController != null)
        {
            ragdollController.DisableRagdoll();
        }

        if (mainRig != null)
        {
            mainRig.weight = 0f;
        }

        if (handIkTarget != null)
        {
            handIkTarget.localPosition = _originalHandIkLocalPos;
            handIkTarget.localRotation = _originalHandIkLocalRot;
        }

        if (animator != null)
        {
            animator.enabled = true;
            animator.Rebind();
            animator.Update(0f);
        }

        if (mainRig != null)
        {
            var rigBuilder = GetComponentInParent<RigBuilder>();
            if (rigBuilder != null)
            {
                rigBuilder.Build();
            }
        }

        if (mainCapsuleCollider != null)
        {
            mainCapsuleCollider.enabled = true;
        }
    }
}