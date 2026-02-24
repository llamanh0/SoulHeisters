using System;
using Unity.Netcode;
using UnityEngine;

public class PlayerCombat : NetworkBehaviour
{
    [Header("Configuration")]
    [SerializeField] private Transform firePoint;
    [SerializeField] private LayerMask aimColliderMask = new LayerMask();

    [Header("Magic Stats")]
    [SerializeField] private float projectileSpeed = 30f;
    [SerializeField] private float damage = 15f;
    [SerializeField] private float fireRate = 0.5f;

    [Header("Mana Settings")]
    [SerializeField] private float maxMana = 100f;
    [SerializeField] private float manaCostPerShot = 10f;
    [SerializeField] private float manaRegenRate = 15f;

    [Header("Visuals")]
    [SerializeField] private GameObject visualBoltPrefab;
    [SerializeField] private GameObject serverBoltPrefab;

    public event Action<float, float> OnManaChanged;

    private PlayerReferences _refs;

    private Camera _mainCamera;

    private float _nextFireTime;
    private float _currentMana;

    private void Awake()
    {
        _refs = GetComponentInParent<PlayerReferences>();
        if (_refs == null) Debug.LogError("PlayerReferences can not be find!");

        _currentMana = maxMana;
    }

    public override void OnNetworkSpawn()
    {
        if (IsOwner)
        {
            _mainCamera = Camera.main;
            OnManaChanged?.Invoke(_currentMana, maxMana);
        }
    }

    private void Update()
    {
        if (!IsOwner) return;

        HandleManaRegeneration();

        if (_refs.Input.FireInput && Time.time >= _nextFireTime)
        {
            if (_currentMana >= manaCostPerShot)
            {
                _nextFireTime = Time.time + fireRate;
                HandleShooting();
            }
        }
    }

    private void HandleManaRegeneration()
    {
        if (_currentMana < maxMana)
        {
            _currentMana += manaRegenRate * Time.deltaTime;

            if (_currentMana > maxMana) _currentMana = maxMana;

            OnManaChanged?.Invoke(_currentMana, maxMana);
        }
    }

    private void HandleShooting()
    {
        _currentMana -= manaCostPerShot;
        OnManaChanged?.Invoke(_currentMana, maxMana);

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
        if (rb != null) rb.velocity = direction * projectileSpeed;
        Destroy(visualObj, 5f);
    }

    [ServerRpc]
    private void ShootServerRpc(Vector3 spawnPosition, Quaternion spawnRotation, Vector3 direction)
    {
        GameObject serverObj = Instantiate(serverBoltPrefab, spawnPosition, spawnRotation);
        ProjectileController projectile = serverObj.GetComponent<ProjectileController>();

        if (projectile != null)
            projectile.Initialize(direction, projectileSpeed, damage, OwnerClientId);

        NetworkObject netObj = serverObj.GetComponent<NetworkObject>();
        if (netObj != null) netObj.Spawn(true);

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
        if (Physics.Raycast(ray, out hit, 1000f, aimColliderMask)) return hit.point;
        return ray.GetPoint(100f);
    }
}