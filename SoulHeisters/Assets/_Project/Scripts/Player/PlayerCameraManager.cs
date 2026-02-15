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
    [SerializeField] private Renderer[] playerRenderers;

    private PlayerInputHandler _input;
    private bool _isFpsMode = false;
    private bool _wasCameraInputPressed = false; // Logic for single press detection

    private void Awake()
    {
        _input = GetComponent<PlayerInputHandler>();
    }

    public override void OnNetworkSpawn()
    {
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
            cam.LookAt = cameraRoot;
        }
    }

    private void LateUpdate()
    {
        if (!IsOwner) return;

        HandleCameraToggle();
    }

    private void HandleCameraToggle()
    {
        if (_input.ChangeCameraInput)
        {
            // Only execute if it wasn't pressed in the previous frame (Edge Detection)
            if (!_wasCameraInputPressed)
            {
                ToggleCameraMode();
                _wasCameraInputPressed = true;
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
            SetBodyVisibility(false); // Hide body
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
        foreach (var rend in playerRenderers)
        {
            rend.shadowCastingMode = isVisible ?
                UnityEngine.Rendering.ShadowCastingMode.On :
                UnityEngine.Rendering.ShadowCastingMode.ShadowsOnly;
        }
    }
}