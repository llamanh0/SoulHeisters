using UnityEngine;

public class PlayerInputHandler : MonoBehaviour
{
    public Vector2 MoveInput { get; private set; }
    public Vector2 LookInput { get; private set; }
    public bool JumpInput { get; private set; }
    public bool AimInput { get; private set; }
    public bool FireInput { get; private set; }
    public bool IsJumping { get; private set; }
    public bool IsSprinting { get; private set; }
    public bool ChangeCameraInput { get; private set; }

    private PlayerInputActions _inputActions;
    private bool _scrollJumpQueued = false;

    private void OnEnable()
    {
        if (_inputActions == null)
        {
            _inputActions = new PlayerInputActions();

            _inputActions.Player.Move.performed += i => MoveInput = i.ReadValue<Vector2>();
            _inputActions.Player.Move.canceled += i => MoveInput = Vector2.zero;

            _inputActions.Player.Look.performed += i => LookInput = i.ReadValue<Vector2>();
            _inputActions.Player.Look.canceled += i => LookInput = Vector2.zero;

            _inputActions.Player.Jump.performed += i =>
            {
                JumpInput = true;
                IsJumping = true;
            };
            _inputActions.Player.Jump.canceled += i =>
            {
                JumpInput = false;
            };

            _inputActions.Player.Aim.performed += i => AimInput = true;
            _inputActions.Player.Aim.canceled += i => AimInput = false;

            _inputActions.Player.Fire.performed += i => FireInput = true;
            _inputActions.Player.Fire.canceled += i => FireInput = false;

            _inputActions.Player.Sprint.performed += i => IsSprinting = true;
            _inputActions.Player.Sprint.canceled += i => IsSprinting = false;

            _inputActions.Player.ChangeCamera.performed += i => ChangeCameraInput = true;
            _inputActions.Player.ChangeCamera.canceled += i => ChangeCameraInput = false;
        }

        _inputActions.Enable();
    }

    private void OnDisable()
    {
        _inputActions?.Disable();
    }

    private void Update()
    {
        float scroll = Input.mouseScrollDelta.y;

        if (scroll < -0.1f)
        {
            _scrollJumpQueued = true;
        }

        if (_scrollJumpQueued)
        {
            IsJumping = true;
            _scrollJumpQueued = false;
        }
    }

    public void ConsumeJump()
    {
        IsJumping = false;
        JumpInput = false;
    }
}