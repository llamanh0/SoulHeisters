using Unity.Netcode;
using UnityEngine;

public class PlayerCombat : NetworkBehaviour
{
    [Header("Configuration")]
    [SerializeField] private Transform firePoint;
    [SerializeField] private LayerMask aimColliderMask = new LayerMask();

    [Header("Projectile Settings")]
    [SerializeField] private float projectileSpeed = 30f;
    [SerializeField] private float damage = 15f;
    [SerializeField] private float fireRate = 0.2f;

    [Header("Profesyonel Mimariler (Sıfır Lag)")]
    [Tooltip("Ağ objesi olmayan, sadece görsellik katan sahte mermi")]
    [SerializeField] private GameObject visualBoltPrefab;
    [Tooltip("Görünmez olan, hasarı hesaplayan gerçek ağ mermisi")]
    [SerializeField] private GameObject serverBoltPrefab;

    [Header("Debug")]
    [SerializeField] private bool showDebugRay = true;

    private PlayerInputHandler _input;
    private Camera _mainCamera;
    private float _nextFireTime;

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

        if (_input.FireInput && Time.time >= _nextFireTime)
        {
            _nextFireTime = Time.time + fireRate;
            HandleShooting();
        }
    }

    private void HandleShooting()
    {
        Vector3 targetPoint = GetCrosshairHitPoint();
        Vector3 aimDirection = (targetPoint - firePoint.position).normalized;
        Quaternion targetRotation = Quaternion.LookRotation(aimDirection);

        SpawnVisualBolt(firePoint.position, targetRotation, aimDirection);

        ShootServerRpc(firePoint.position, targetRotation, aimDirection);
    }

    private void SpawnVisualBolt(Vector3 spawnPosition, Quaternion spawnRotation, Vector3 direction)
    {
        GameObject visualObj = Instantiate(visualBoltPrefab, spawnPosition, spawnRotation);

        Rigidbody rb = visualObj.GetComponent<Rigidbody>();
        if (rb != null)
        {
            rb.velocity = direction * projectileSpeed;
        }

        Destroy(visualObj, 5f);
    }

    [ServerRpc]
    private void ShootServerRpc(Vector3 spawnPosition, Quaternion spawnRotation, Vector3 direction)
    {
        GameObject serverObj = Instantiate(serverBoltPrefab, spawnPosition, spawnRotation);

        ProjectileController projectile = serverObj.GetComponent<ProjectileController>();
        if (projectile != null)
        {
            projectile.Initialize(direction, projectileSpeed, damage, OwnerClientId);
        }

        NetworkObject netObj = serverObj.GetComponent<NetworkObject>();
        if (netObj != null)
        {
            netObj.Spawn(true);
        }

        ShootClientRpc(spawnPosition, spawnRotation, direction);
    }

    [ClientRpc]
    private void ShootClientRpc(Vector3 spawnPosition, Quaternion spawnRotation, Vector3 direction)
    {
        if (IsOwner) return;

        SpawnVisualBolt(spawnPosition, spawnRotation, direction);
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