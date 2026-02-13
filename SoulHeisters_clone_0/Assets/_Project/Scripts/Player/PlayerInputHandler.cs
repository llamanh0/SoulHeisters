using UnityEngine;
using UnityEngine.InputSystem;

public class PlayerInputHandler : MonoBehaviour
{
    // (Encapsulation)
    public Vector2 MoveInput { get; private set; }
    public Vector2 LookInput { get; private set; }
    public bool IsJumping { get; private set; }
    public bool IsSprinting { get; private set; }

    private PlayerInputActions _inputActions;

    private void OnEnable()
    {
        if (_inputActions == null)
        {
            _inputActions = new PlayerInputActions();

            // WASD
            _inputActions.Player.Move.performed += i => MoveInput = i.ReadValue<Vector2>();
            _inputActions.Player.Move.canceled += i => MoveInput = Vector2.zero;

            // Look
            _inputActions.Player.Look.performed += i => LookInput = i.ReadValue<Vector2>();
            _inputActions.Player.Look.canceled += i => LookInput = Vector2.zero;

            // Space
            _inputActions.Player.Jump.performed += i => IsJumping = true;
            _inputActions.Player.Jump.canceled += i => IsJumping = false;

            // Shift
            _inputActions.Player.Sprint.performed += i => IsSprinting = true;
            _inputActions.Player.Sprint.canceled += i => IsSprinting = false;
        }

        _inputActions.Enable();
    }

    private void OnDisable()
    {
        _inputActions?.Disable();
    }
}
