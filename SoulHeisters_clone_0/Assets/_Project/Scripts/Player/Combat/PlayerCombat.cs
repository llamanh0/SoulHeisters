using Unity.Netcode;
using UnityEngine;

public class PlayerCombat : NetworkBehaviour
{
    [Header("Bolt Config")]
    [SerializeField] private Transform firePoint;
    [SerializeField] private GameObject serverBoltPrefab;
    [SerializeField] private GameObject visualBoltPrefab;

    public Transform FirePoint => firePoint;

    private PlayerReferences _refs;
    private SpellInventory _inventory;

    private void Awake()
    {
        _refs = GetComponent<PlayerReferences>();
        _inventory = GetComponent<SpellInventory>();
    }

    private void Update()
    {
        if (!IsOwner) return;

        if (_refs.Input.FireInput)
        {
            _refs.SpellInventory.CurrentSpell?.TryCast();
        }
    }

    // SERVER AUTHORITY
    [ServerRpc]
    public void CastBoltServerRpc(Vector3 targetPoint, float manaCost, float damage, float projectileSpeed)
    {
        if (!_refs.Mana.TryConsume(manaCost))
            return;

        Vector3 direction =
            (targetPoint - firePoint.position).normalized;

        Quaternion rotation =
            Quaternion.LookRotation(direction);

        GameObject serverObj =
            Instantiate(serverBoltPrefab,
                        firePoint.position,
                        rotation);

        var projectile =
            serverObj.GetComponent<ProjectileController>();

        projectile.Initialize(direction,
                              projectileSpeed,
                              damage,
                              OwnerClientId);

        serverObj.GetComponent<NetworkObject>().Spawn();

        CastBoltClientRpc(firePoint.position,
                          rotation,
                          direction,
                          projectileSpeed);
    }

    [ClientRpc]
    private void CastBoltClientRpc(Vector3 pos,
                               Quaternion rot,
                               Vector3 dir,
                               float projectileSpeed)
    {
        if (IsOwner) return;

        GameObject visualObj =
            Instantiate(visualBoltPrefab, pos, rot);

        if (visualObj.TryGetComponent<Rigidbody>(out var rb))
            rb.velocity = dir * projectileSpeed;

        Destroy(visualObj, 5f);
    }
}