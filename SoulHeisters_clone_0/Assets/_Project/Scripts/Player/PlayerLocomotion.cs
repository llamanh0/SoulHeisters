using Unity.Netcode;
using UnityEngine;

[RequireComponent(typeof(CharacterController))]
[RequireComponent(typeof(PlayerInputHandler))]
public class PlayerLocomotion : NetworkBehaviour
{
    [Header("References")]
    [SerializeField] private Transform playerVisuals;

    [Header("Settings")]
    [SerializeField] private float walkSpeed = 5f;
    [SerializeField] private float sprintSpeed = 8f;
    [SerializeField] private float rotationSpeed = 10f;
    [SerializeField] private float gravity = -9.81f;

    [Header("Camera Settings")]
    [SerializeField] private GameObject cameraRoot;
    [SerializeField] private float mouseSensitivity = 0.03f;
    [SerializeField] private float topClamp = 70.0f;
    [SerializeField] private float bottomClamp = -40.0f;

    private NetworkVariable<float> _netVisualRotationY = new NetworkVariable<float>(
        0,
        NetworkVariableReadPermission.Everyone,
        NetworkVariableWritePermission.Owner
    );

    private float _cinemachineTargetPitch;
    private float _cinemachineTargetYaw;

    // Component Refs
    private CharacterController _controller;
    private PlayerInputHandler _input;
    private Transform _cameraTransform;

    // Physic Vars
    private Vector3 _playerVelocity;
    private bool _isGrounded;

    private void Awake()
    {
        _controller = GetComponent<CharacterController>();
        _input = GetComponent<PlayerInputHandler>();
    }

    public override void OnNetworkSpawn()
    {
        if (IsOwner)
        {
            if (Camera.main != null)
            {
                _cameraTransform = Camera.main.transform;
            }
            else
            {
                _cameraTransform = FindObjectOfType<Camera>().transform;
            }

            Cursor.lockState = CursorLockMode.Locked;
            Cursor.visible = false;
        }
    }

    private void LateUpdate()
    {
        if (!IsOwner) return;

        CameraRotation();
    }

    private void Update()
    {
        if (IsOwner)
        {
            HandleMovement();
            HandleGravity();
        }
        else
        {
            SyncVisualRotation();
        }

    }

    private void SyncVisualRotation()
    {
        Quaternion targetRotation = Quaternion.Euler(0, _netVisualRotationY.Value, 0);
        playerVisuals.rotation = Quaternion.Slerp(playerVisuals.rotation, targetRotation, rotationSpeed * Time.deltaTime);
    }

    private void HandleMovement()
    {
        Vector2 inputVector = _input.MoveInput;
        bool isSprinting = _input.IsSprinting;

        if (inputVector == Vector2.zero) return;

        Vector3 camForward = _cameraTransform.forward;
        Vector3 camRight = _cameraTransform.right;

        camForward.y = 0;
        camRight.y = 0;
        camForward.Normalize();
        camRight.Normalize();

        Vector3 moveDirection = (camForward * inputVector.y + camRight * inputVector.x).normalized;

        if (moveDirection != Vector3.zero)
        {
            Quaternion targetRotation = Quaternion.LookRotation(moveDirection);
            playerVisuals.rotation = Quaternion.Slerp(playerVisuals.rotation, targetRotation, rotationSpeed * Time.deltaTime);
            _netVisualRotationY.Value = playerVisuals.eulerAngles.y;
        }

        float currentSpeed = isSprinting ? sprintSpeed : walkSpeed;
        _controller.Move(moveDirection * currentSpeed * Time.deltaTime);
    }

    private void HandleGravity()
    {
        _isGrounded = _controller.isGrounded;

        if (_isGrounded && _playerVelocity.y < 0)
        {
            _playerVelocity.y = -2f;
        }

        // Gravity
        _playerVelocity.y += gravity * Time.deltaTime;
        _controller.Move(_playerVelocity * Time.deltaTime);
    }

    private void CameraRotation()
    {
        Vector2 lookInput = _input.LookInput;

        if (lookInput.sqrMagnitude >= 0.01f)
        {
            _cinemachineTargetYaw += lookInput.x * mouseSensitivity;
            _cinemachineTargetPitch -= lookInput.y * mouseSensitivity;
        }

        _cinemachineTargetYaw = ClampAngle(_cinemachineTargetYaw, float.MinValue, float.MaxValue);
        _cinemachineTargetPitch = ClampAngle(_cinemachineTargetPitch, bottomClamp, topClamp);

        cameraRoot.transform.rotation = Quaternion.Euler(_cinemachineTargetPitch, _cinemachineTargetYaw, 0.0f);
    }

    private static float ClampAngle(float lfAngle, float lfMin, float lfMax)
    {
        if (lfAngle < -360f) lfAngle += 360f;
        if (lfAngle > 360f) lfAngle -= 360f;
        return Mathf.Clamp(lfAngle, lfMin, lfMax);
    }
}
