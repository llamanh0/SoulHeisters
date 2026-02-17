using Unity.Netcode;
using UnityEngine;

public class PlayerManualAim : NetworkBehaviour
{
    [Header("General Settings")]
    public float smoothSpeed = 15f;
    public float aimTransitionSpeed = 10f;

    [Header("Spine Settings (Natural Movement)")]
    public Vector3 spineAimOffset = new Vector3(90, 90, 90);
    [Range(0, 180)] public float horizontalLimit = 60f;
    [Range(0, 90)] public float verticalLimit = 60f;

    [Header("Arm Settings (Absolute Lock)")]
    public Vector3 armAimOffset = new Vector3(180, 15, 90);
    [Range(0, 90)] public float elbowStraightenAngle = 15f;

    [Header("References")]
    [SerializeField] private Transform spineBone;
    [SerializeField] private Transform shoulderBone;
    [SerializeField] private Transform elbowBone;

    private Transform _cameraTransform;

    private NetworkVariable<Vector3> _netAimPosition = new NetworkVariable<Vector3>(default, NetworkVariableReadPermission.Everyone, NetworkVariableWritePermission.Owner);
    private NetworkVariable<bool> _netIsAiming = new NetworkVariable<bool>(false, NetworkVariableReadPermission.Everyone, NetworkVariableWritePermission.Owner);

    private float _currentAimWeight;

    private void Awake()
    {
        Animator anim = GetComponent<Animator>();
        if (anim != null && anim.isHuman)
        {
            if (spineBone == null)
            {
                spineBone = anim.GetBoneTransform(HumanBodyBones.Chest);
                if (spineBone == null) spineBone = anim.GetBoneTransform(HumanBodyBones.Spine);
            }
            if (shoulderBone == null) shoulderBone = anim.GetBoneTransform(HumanBodyBones.RightUpperArm);
            if (elbowBone == null) elbowBone = anim.GetBoneTransform(HumanBodyBones.RightLowerArm);
        }
    }

    public override void OnNetworkSpawn()
    {
        if (IsOwner && Camera.main != null)
        {
            _cameraTransform = Camera.main.transform;
        }
    }

    private void Update()
    {
        if (IsOwner)
        {
            HandleInputAndSync();
        }
    }

    private void LateUpdate()
    {
        if (spineBone == null) return;
        UpdateAimVisuals();
    }

    private void HandleInputAndSync()
    {
        bool isAimingInput = Input.GetMouseButton(1);

        if (_netIsAiming.Value != isAimingInput)
        {
            _netIsAiming.Value = isAimingInput;
        }

        if (_cameraTransform == null) return;

        Vector3 targetPoint = _cameraTransform.position + _cameraTransform.forward * 50f;

        if (Vector3.Distance(_netAimPosition.Value, targetPoint) > 0.05f)
        {
            _netAimPosition.Value = targetPoint;
        }
    }

    private void UpdateAimVisuals()
    {
        float targetWeight = _netIsAiming.Value ? 1f : 0f;
        _currentAimWeight = Mathf.Lerp(_currentAimWeight, targetWeight, Time.deltaTime * aimTransitionSpeed);

        if (_currentAimWeight < 0.01f) return;

        Vector3 targetPoint = _netAimPosition.Value;

        Vector3 directionToTarget = (targetPoint - transform.position).normalized;
        Vector3 localDir = transform.InverseTransformDirection(directionToTarget);
        Quaternion lookRot = Quaternion.LookRotation(localDir);
        Vector3 euler = lookRot.eulerAngles;

        float y = NormalizeAngle(euler.y);
        float x = NormalizeAngle(euler.x);

        y = Mathf.Clamp(y, -horizontalLimit, horizontalLimit);
        x = Mathf.Clamp(x, -verticalLimit, verticalLimit);

        Quaternion spineRot = transform.rotation * Quaternion.Euler(x, y, 0) * Quaternion.Euler(spineAimOffset);
        spineBone.rotation = Quaternion.Slerp(spineBone.rotation, spineRot, _currentAimWeight);


        if (shoulderBone != null)
        {
            Vector3 armDirection = (targetPoint - shoulderBone.position).normalized;

            Quaternion worldLookRotation = Quaternion.LookRotation(armDirection);

            Quaternion finalArmRotation = worldLookRotation * Quaternion.Euler(armAimOffset);

            shoulderBone.rotation = Quaternion.Slerp(shoulderBone.rotation, finalArmRotation, _currentAimWeight);

            if (elbowBone != null)
            {
                Quaternion straightRotation = Quaternion.Euler(elbowStraightenAngle, 0, 0);
                elbowBone.localRotation = Quaternion.Slerp(elbowBone.localRotation, straightRotation, _currentAimWeight);
            }
        }
    }

    private float NormalizeAngle(float angle)
    {
        if (angle > 180f) angle -= 360f;
        return angle;
    }
}