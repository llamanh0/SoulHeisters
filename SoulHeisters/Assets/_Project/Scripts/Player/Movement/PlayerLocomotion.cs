using System.Collections;
using Unity.Netcode;
using UnityEngine;
using Cinemachine;

public class PlayerLocomotion : NetworkBehaviour
{
    [SerializeField] private float walkSpeed = 4.5f;
    [SerializeField] private float sprintSpeed = 6.5f;
    [SerializeField] private float jumpHeight = 2.5f;
    [SerializeField] private float gravity = 25f;
    [SerializeField] private CinemachineVirtualCamera tpsCamera;
    [SerializeField] private GameObject cameraRoot;
    [SerializeField] private float mouseSensitivity = 0.03f;
    [SerializeField] private float topClamp = 70f;
    [SerializeField] private float bottomClamp = -40f;

    public Transform CameraRoot => cameraRoot != null ? cameraRoot.transform : transform;
    public float CurrentMoveSpeed { get; private set; }

    private NetworkVariable<float> _netRotY = new NetworkVariable<float>(
        0f,
        NetworkVariableReadPermission.Everyone,
        NetworkVariableWritePermission.Owner
    );

    private CharacterController _controller;
    private Transform _cameraTransform;
    private Vector3 _moveVelocity;
    private float _verticalVelocity;
    private float _cinemachineTargetPitch;
    private float _cinemachineTargetYaw;
    private PlayerReferences _refs;

    private void Awake()
    {
        _controller = GetComponent<CharacterController>();
        _refs = GetComponent<PlayerReferences>();

        if (_controller != null)
            _controller.enabled = false;
    }

    public override void OnNetworkSpawn()
    {
        if (IsOwner)
        {
            _cameraTransform = Camera.main?.transform;
            Cursor.lockState = CursorLockMode.Locked;
            Cursor.visible = false;

            if (tpsCamera != null)
            {
                tpsCamera.Follow = cameraRoot.transform;
                tpsCamera.LookAt = cameraRoot.transform;
            }

            StartCoroutine(EnableControllerWhenReady());
        }
        else
        {
            if (tpsCamera != null)
                tpsCamera.gameObject.SetActive(false);

            if (_controller != null)
                _controller.enabled = false;
        }
    }

    private IEnumerator EnableControllerWhenReady()
    {
        yield return new WaitForSeconds(0.5f);

        if (_refs?.ControllerManager != null)
            _refs.ControllerManager.EnableController();
        else if (_controller != null)
            _controller.enabled = true;
    }

    private void Update()
    {
        if (IsOwner)
            SyncVisualRotation();
        else
            SyncVisualRotation();
    }

    private void LateUpdate()
    {
        if (IsOwner)
            UpdateCameraRotation();
    }

    public void ApplyGravity()
    {
        if (_controller == null || !_controller.enabled) return;

        if (_controller.isGrounded)
        {
            if (_verticalVelocity < 0f)
                _verticalVelocity = -2f;
        }
        else
        {
            _verticalVelocity -= gravity * Time.deltaTime;
        }

        _controller.Move((_moveVelocity + Vector3.up * _verticalVelocity) * Time.deltaTime);
    }

    public void Move(Vector2 input, bool sprint, bool isAirborne = false)
    {
        if (_controller == null || !_controller.enabled) return;

        if (_cameraTransform == null)
        {
            if (Camera.main != null)
                _cameraTransform = Camera.main.transform;
            else
                return;
        }

        if (input.magnitude < 0.01f)
        {
            _moveVelocity = Vector3.zero;
            CurrentMoveSpeed = 0f;
            return;
        }

        Vector3 forward = _cameraTransform.forward;
        Vector3 right = _cameraTransform.right;
        forward.y = 0f;
        right.y = 0f;
        forward.Normalize();
        right.Normalize();

        Vector3 moveDirection = (forward * input.y + right * input.x).normalized;
        _moveVelocity = moveDirection * (sprint ? sprintSpeed : walkSpeed) * input.magnitude;
        CurrentMoveSpeed = _moveVelocity.magnitude;

        if (moveDirection != Vector3.zero)
        {
            transform.rotation = Quaternion.Slerp(
                transform.rotation,
                Quaternion.LookRotation(moveDirection),
                15f * Time.deltaTime
            );
            _netRotY.Value = transform.eulerAngles.y;
        }
    }

    public void Jump()
    {
        if (_controller != null && _controller.enabled && _controller.isGrounded)
        {
            _verticalVelocity = Mathf.Sqrt(jumpHeight * 2f * gravity);
            _refs.Input.ConsumeJump();
        }
    }

    public void ResetVerticalVelocity()
    {
        _verticalVelocity = 0f;
    }

    public void ForceStopMovement()
    {
        _moveVelocity = Vector3.zero;
        _verticalVelocity = 0f;
    }

    public bool IsGrounded()
    {
        return _controller != null && _controller.isGrounded;
    }

    public bool IsFalling()
    {
        return _verticalVelocity < -0.1f && !IsGrounded();
    }

    public bool IsRising()
    {
        return _verticalVelocity > 0.1f;
    }

    public float VerticalVelocity => _verticalVelocity;

    private void UpdateCameraRotation()
    {
        if (_refs?.Input == null) return;

        Vector2 look = _refs.Input.LookInput;

        if (look.sqrMagnitude >= 0.01f)
        {
            _cinemachineTargetYaw += look.x * mouseSensitivity;
            _cinemachineTargetPitch -= look.y * mouseSensitivity;
        }

        _cinemachineTargetYaw = ClampAngle(_cinemachineTargetYaw, float.MinValue, float.MaxValue);
        _cinemachineTargetPitch = ClampAngle(_cinemachineTargetPitch, bottomClamp, topClamp);

        cameraRoot.transform.rotation = Quaternion.Euler(_cinemachineTargetPitch, _cinemachineTargetYaw, 0f);
    }

    private void SyncVisualRotation()
    {
        transform.rotation = Quaternion.Slerp(
            transform.rotation,
            Quaternion.Euler(0f, _netRotY.Value, 0f),
            15f * Time.deltaTime
        );
    }

    private static float ClampAngle(float angle, float min, float max)
    {
        if (angle < -360f) angle += 360f;
        if (angle > 360f) angle -= 360f;
        return Mathf.Clamp(angle, min, max);
    }
}