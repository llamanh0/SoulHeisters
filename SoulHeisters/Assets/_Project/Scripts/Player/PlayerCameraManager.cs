using UnityEngine;
using Unity.Netcode;
using Cinemachine;

public class PlayerCameraManager : NetworkBehaviour
{
    [Header("Cameras")]
    [SerializeField] private CinemachineVirtualCamera tpsCamera;
    [SerializeField] private CinemachineVirtualCamera fpsCamera;

    [Header("Settings")]
    [SerializeField] private Transform cameraRoot;
    [SerializeField] private Renderer[] playerRenderers; // To hide body in FPS mode

    private PlayerInputHandler _input;
    private bool _isFpsMode = false;
    private bool _wasCameraInputPressed = false; // Logic for single press detection

    private void Awake()
    {
        _input = GetComponent<PlayerInputHandler>();
    }

    public override void OnNetworkSpawn()
    {
        // If this is NOT my character, disable cameras immediately
        if (!IsOwner)
        {
            if (tpsCamera) tpsCamera.gameObject.SetActive(false);
            if (fpsCamera) fpsCamera.gameObject.SetActive(false);
            return;
        }

        // Initialize Cameras
        SetupCamera(tpsCamera);
        SetupCamera(fpsCamera);

        // Start in TPS Mode
        tpsCamera.Priority = 11;
        fpsCamera.Priority = 10;
    }

    private void SetupCamera(CinemachineVirtualCamera cam)
    {
        if (cam != null)
        {
            cam.Follow = cameraRoot;
            cam.LookAt = cameraRoot; // Important for rotation sync
        }
    }

    private void LateUpdate()
    {
        if (!IsOwner) return;

        HandleCameraToggle();
    }

    private void HandleCameraToggle()
    {
        // Check if the button is currently pressed
        if (_input.ChangeCameraInput)
        {
            // Only execute if it wasn't pressed in the previous frame (Edge Detection)
            if (!_wasCameraInputPressed)
            {
                ToggleCameraMode();
                _wasCameraInputPressed = true; // Lock untill release
            }
        }
        else
        {
            // Button released, reset the lock
            _wasCameraInputPressed = false;
        }
    }

    private void ToggleCameraMode()
    {
        _isFpsMode = !_isFpsMode;

        if (_isFpsMode)
        {
            // Switch to FPS
            fpsCamera.Priority = 15;
            tpsCamera.Priority = 10;
            SetBodyVisibility(false); // Hide body (Shadows Only)
        }
        else
        {
            // Switch to TPS
            tpsCamera.Priority = 15;
            fpsCamera.Priority = 10;
            SetBodyVisibility(true); // Show body
        }
    }

    private void SetBodyVisibility(bool isVisible)
    {
        // We use "ShadowsOnly" instead of disabling renderer so the shadow remains on the ground
        foreach (var rend in playerRenderers)
        {
            rend.shadowCastingMode = isVisible ?
                UnityEngine.Rendering.ShadowCastingMode.On :
                UnityEngine.Rendering.ShadowCastingMode.ShadowsOnly;
        }
    }
}