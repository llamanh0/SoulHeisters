using Unity.Netcode;
using UnityEngine;

public class PlayerManualAim : NetworkBehaviour
{
    [Header("General Settings")]
    public float smoothSpeed = 10f;
    public float aimTransitionSpeed = 10f;

    [Header("Spine Settings")]
    public Vector3 spineAimOffset = new Vector3(90, 90, 90);
    [Range(0, 180)] public float horizontalLimit = 60f;
    [Range(0, 90)] public float verticalLimit = 60f;

    [Header("Arm Settings")]
    public Vector3 armAimOffset = new Vector3(180, 60, 120);
    [Range(0, 90)] public float armInnerLimit = 60f;
    [Range(0, 180)] public float armOuterLimit = 150f;

    [Header("References")]
    [SerializeField] private Transform spineBone;
    [SerializeField] private Transform shoulderBone;

    private Transform _cameraTransform;
    private float _currentSpineX, _currentSpineY;
    private float _currentArmX, _currentArmY;
    private float _currentAimWeight;

    private PlayerInputHandler _input;

    private void Awake()
    {
        _input = GetComponent<PlayerInputHandler>();
        Animator anim = GetComponent<Animator>();
        if (anim != null && anim.isHuman)
        {
            if (spineBone == null)
            {
                spineBone = anim.GetBoneTransform(HumanBodyBones.Chest);
                if (spineBone == null) spineBone = anim.GetBoneTransform(HumanBodyBones.Spine);
            }

            if (shoulderBone == null)
            {
                shoulderBone = anim.GetBoneTransform(HumanBodyBones.RightUpperArm);
            }
        }
    }

    private void Start()
    {
        if (IsOwner && Camera.main != null)
        {
            _cameraTransform = Camera.main.transform;
        }
    }

    private void LateUpdate()
    {
        if (!IsOwner || spineBone == null || _cameraTransform == null) return;

        float targetWeight = _input.AimInput ? 1f : 0f;
        _currentAimWeight = Mathf.Lerp(_currentAimWeight, targetWeight, Time.deltaTime * aimTransitionSpeed);

        if (_currentAimWeight < 0.01f) return;

        HandleSpineRotation();

        if (shoulderBone != null)
        {
            HandleArmRotation();
        }
    }

    private void HandleSpineRotation()
    {
        Vector3 camForward = _cameraTransform.forward;
        Vector3 localTargetDir = transform.InverseTransformDirection(camForward);
        Quaternion localRotation = Quaternion.LookRotation(localTargetDir);
        Vector3 euler = localRotation.eulerAngles;

        float targetY = NormalizeAngle(euler.y);
        float targetX = NormalizeAngle(euler.x);

        targetY = Mathf.Clamp(targetY, -horizontalLimit, horizontalLimit);
        targetX = Mathf.Clamp(targetX, -verticalLimit, verticalLimit);

        _currentSpineX = Mathf.Lerp(_currentSpineX, targetX, Time.deltaTime * smoothSpeed);
        _currentSpineY = Mathf.Lerp(_currentSpineY, targetY, Time.deltaTime * smoothSpeed);

        Quaternion aimRotation = transform.rotation * Quaternion.Euler(_currentSpineX, _currentSpineY, 0) * Quaternion.Euler(spineAimOffset);
        spineBone.rotation = Quaternion.Slerp(spineBone.rotation, aimRotation, _currentAimWeight);
    }

    private void HandleArmRotation()
    {
        Vector3 camForward = _cameraTransform.forward;
        Vector3 localTargetDir = transform.InverseTransformDirection(camForward);
        Quaternion localRotation = Quaternion.LookRotation(localTargetDir);
        Vector3 euler = localRotation.eulerAngles;

        float targetY = NormalizeAngle(euler.y);
        float targetX = NormalizeAngle(euler.x);

        targetY = Mathf.Clamp(targetY, -armInnerLimit, armOuterLimit);

        _currentArmX = Mathf.Lerp(_currentArmX, targetX, Time.deltaTime * smoothSpeed);
        _currentArmY = Mathf.Lerp(_currentArmY, targetY, Time.deltaTime * smoothSpeed);

        Quaternion aimRotation = transform.rotation * Quaternion.Euler(_currentArmX, _currentArmY, 0) * Quaternion.Euler(armAimOffset);
        shoulderBone.rotation = Quaternion.Slerp(shoulderBone.rotation, aimRotation, _currentAimWeight);
    }

    private float NormalizeAngle(float angle)
    {
        if (angle > 180f) angle -= 360f;
        return angle;
    }
}