using UnityEngine;

/// <summary>
/// Yeni Input System uzerinden oyuncu girdilerini okur ve
/// diger sistemlerin (StateMachine, Locomotion, Combat vs.)
/// kullanabilecegi basit property'lere donusturur.
/// 
/// Not:
/// - Network ile dogrudan baglantisi yoktur.
/// - Sadece local player tarafinda aktif olmalidir (Network kontrolu baska yerde).
/// </summary>
public class PlayerInputHandler : MonoBehaviour
{
    // Hareket (WASD)
    public Vector2 MoveInput { get; private set; }

    // Kamera bakisi (Mouse)
    public Vector2 LookInput { get; private set; }

    // Anlik butonlar
    public bool JumpInput { get; private set; }
    public bool AimInput { get; private set; }
    public bool FireInput { get; private set; }

    // Durumlar (basili tutma)
    public bool IsJumping { get; private set; }
    public bool IsSprinting { get; private set; }
    public bool ChangeCameraInput { get; private set; }

    private PlayerInputActions _inputActions;

    private void OnEnable()
    {
        if (_inputActions == null)
        {
            _inputActions = new PlayerInputActions();

            // Hareket (WASD)
            _inputActions.Player.Move.performed += i => MoveInput = i.ReadValue<Vector2>();
            _inputActions.Player.Move.canceled += i => MoveInput = Vector2.zero;

            // Kamera bakisi (mouse)
            _inputActions.Player.Look.performed += i => LookInput = i.ReadValue<Vector2>();
            _inputActions.Player.Look.canceled += i => LookInput = Vector2.zero;

            // Ziplama (anlik input + state)
            _inputActions.Player.Jump.performed += i =>
            {
                JumpInput = true;
                IsJumping = true;
            };
            _inputActions.Player.Jump.canceled += i =>
            {
                JumpInput = false;
                IsJumping = false;
            };

            // Aim (sag tik)
            _inputActions.Player.Aim.performed += i => AimInput = true;
            _inputActions.Player.Aim.canceled += i => AimInput = false;

            // Ates (sol tik)
            _inputActions.Player.Fire.performed += i => FireInput = true;
            _inputActions.Player.Fire.canceled += i => FireInput = false;

            // Sprint (Shift)
            _inputActions.Player.Sprint.performed += i => IsSprinting = true;
            _inputActions.Player.Sprint.canceled += i => IsSprinting = false;

            // Kamera degistirme
            _inputActions.Player.ChangeCamera.performed += i => ChangeCameraInput = true;
            _inputActions.Player.ChangeCamera.canceled += i => ChangeCameraInput = false;
        }

        _inputActions.Enable();
    }

    private void OnDisable()
    {
        _inputActions?.Disable();
    }
}