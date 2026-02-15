using Unity.Netcode;
using UnityEngine;

public class PlayerCombat : NetworkBehaviour
{
    [Header("Configuration")]
    [SerializeField] private Transform firePoint;
    [SerializeField] private LayerMask aimColliderMask = new LayerMask();

    [Header("Debug")]
    [SerializeField] private bool showDebugRay = true;

    private PlayerInputHandler _input;
    private Camera _mainCamera;


    private void Awake()
    {
        _input = GetComponent<PlayerInputHandler>();
    }

    public override void OnNetworkSpawn()
    {
        if (IsOwner)
        {
            _mainCamera = Camera.main;
            if (_mainCamera == null) Debug.LogError("[PlayerCombat] Main Camera not found!");
        }
    }

    private void Update()
    {
        if (!IsOwner) return;

        if (_input.FireInput)
        {
            HandleShooting();
        }
    }

    private void HandleShooting()
    {
        Vector3 targetPoint = GetCrosshairHitPoint();

        Vector3 aimDirection = (targetPoint - firePoint.position).normalized;

        Quaternion targetRotation = Quaternion.LookRotation(aimDirection);
    }

    private Vector3 GetCrosshairHitPoint()
    {
        Ray ray = _mainCamera.ViewportPointToRay(new Vector3(0.5f, 0.5f, 0f));
        RaycastHit hit;

        if (Physics.Raycast(ray, out hit, 1000f, aimColliderMask))
        {
            if (showDebugRay) Debug.DrawLine(ray.origin, hit.point, Color.green, 1f);
            return hit.point;
        }
        else
        {
            if (showDebugRay) Debug.DrawRay(ray.origin, ray.direction * 1000f, Color.red, 1f);
            return ray.GetPoint(100f);
        }
    }
}