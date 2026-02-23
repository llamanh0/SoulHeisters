using UnityEngine;
using UnityEngine.Animations.Rigging;
using Unity.Netcode;

public class SpellCastRigController : NetworkBehaviour
{
    [Header("Rig Components")]
    [SerializeField] private Rig armRig;
    [SerializeField] private Transform realHandTarget;
    [SerializeField] private Transform realElbowHint;

    [Header("Bone References")]
    [SerializeField] private Transform shoulderTransform;

    [Header("Position References")]
    [SerializeField] private Transform idleHandRef;
    [SerializeField] private Transform aimHandRef;

    [Header("Settings")]
    [SerializeField] private float transitionSpeed = 20f;

    [Header("Safety Settings")]
    [SerializeField] private float bodyRadius = 0.45f;

    private PlayerInputHandler _input;
    private Camera _mainCamera;
    private float _targetWeight;

    private void Awake()
    {
        _input = GetComponent<PlayerInputHandler>();
    }

    public override void OnNetworkSpawn()
    {
        if (IsOwner) _mainCamera = Camera.main;
    }

    private void Start()
    {
        armRig.weight = 0f;
        if (IsOwner && _mainCamera == null) _mainCamera = Camera.main;
    }

    private void LateUpdate()
    {
        if (_mainCamera == null) return;

        bool isAiming = _input.AimInput || _input.FireInput;

        HandleRigWeight(isAiming);
        UpdatePositions(isAiming);
    }

    private void HandleRigWeight(bool isAiming)
    {
        _targetWeight = isAiming ? 1f : 0f;
        armRig.weight = Mathf.Lerp(armRig.weight, _targetWeight, Time.deltaTime * transitionSpeed);
    }

    private void UpdatePositions(bool isAiming)
    {
        if (isAiming)
        {
            Vector3 rawTargetPos = aimHandRef.position;
            Vector3 safeTargetPos = CalculateSafePosition(rawTargetPos);

            realHandTarget.position = Vector3.Lerp(realHandTarget.position, safeTargetPos, Time.deltaTime * transitionSpeed);
            realHandTarget.rotation = Quaternion.Slerp(realHandTarget.rotation, aimHandRef.rotation, Time.deltaTime * transitionSpeed);

            Vector3 camRight = _mainCamera.transform.right;
            Vector3 camFwd = _mainCamera.transform.forward;
            Vector3 camUp = _mainCamera.transform.up;

            Vector3 shoulderPos = shoulderTransform.position;
            Vector3 elbowMathPos = shoulderPos + (camRight * 0.6f) - (camUp * 0.3f) - (camFwd * 0.2f);

            realElbowHint.position = Vector3.Lerp(realElbowHint.position, elbowMathPos, Time.deltaTime * transitionSpeed);
        }
        else
        {
            realHandTarget.position = Vector3.Lerp(realHandTarget.position, idleHandRef.position, Time.deltaTime * transitionSpeed);
            realHandTarget.rotation = Quaternion.Slerp(realHandTarget.rotation, idleHandRef.rotation, Time.deltaTime * transitionSpeed);

            Vector3 idleElbow = transform.position + (transform.right * 0.5f) + (transform.up * 1.2f);
            realElbowHint.position = Vector3.Lerp(realElbowHint.position, idleElbow, Time.deltaTime * transitionSpeed);
        }
    }

    private Vector3 CalculateSafePosition(Vector3 targetPos)
    {
        Vector3 localPos = transform.InverseTransformPoint(targetPos);
        if (localPos.x < bodyRadius) localPos.x = bodyRadius;
        return transform.TransformPoint(localPos);
    }
}