using System.Collections;
using Unity.Netcode;
using UnityEngine;

public class PlayerCombat : NetworkBehaviour
{
    [Header("Bolt Config")]
    [SerializeField] private Transform firePoint;

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
    public void CastSpellServerRpc(
    SpellType spellType,
    Vector3 targetPoint,
    float manaCost,
    float damage,
    float projectileSpeed)
    {
        if (!_refs.Mana.TryConsume(manaCost))
            return;

        var def = _refs.SpellInventory.FindSpellDefinition(spellType);

        if (def == null) return;

        Vector3 direction =
            (targetPoint - firePoint.position).normalized;

        Quaternion rotation =
            Quaternion.LookRotation(direction);

        GameObject serverObj =
            Instantiate(def.serverPrefab,
                        firePoint.position,
                        rotation);

        var projectile =
            serverObj.GetComponent<ProjectileController>();

        projectile.Initialize(direction,
                              projectileSpeed,
                              damage,
                              OwnerClientId);

        serverObj.GetComponent<NetworkObject>().Spawn();

        CastSpellClientRpc(
            spellType,
            firePoint.position,
            rotation,
            direction,
            projectileSpeed);
    }

    [ClientRpc]
    private void CastSpellClientRpc(
    SpellType spellType,
    Vector3 pos,
    Quaternion rot,
    Vector3 dir,
    float projectileSpeed)
    {
        if (IsOwner) return;

        var def = _refs.SpellInventory.FindSpellDefinition(spellType);
        if (def == null) return;

        GameObject visualObj =
            Instantiate(def.visualPrefab, pos, rot);

        if (visualObj.TryGetComponent<Rigidbody>(out var rb))
            rb.velocity = dir * projectileSpeed;

        Destroy(visualObj, 5f);
    }

    [ServerRpc]
    public void CastBlinkServerRpc(Vector3 targetPosition, float manaCost)
    {
        if (!_refs.Mana.TryConsume(manaCost))
            return;

        transform.position = targetPosition;
    }

    [ServerRpc]
    public void CastArcBurstServerRpc(float radius, float damage, float manaCost)
    {
        if (!_refs.Mana.TryConsume(manaCost))
            return;

        Collider[] hits = Physics.OverlapSphere(transform.position, radius);

        foreach (var hit in hits)
        {
            if (hit.TryGetComponent<IDamageable>(out var dmg))
            {
                dmg.TakeDamage(damage, OwnerClientId);
            }
        }
    }

    [ServerRpc]
    public void CastSoulGuardServerRpc(float duration, float damageReduction, float manaCost)
    {
        if (!_refs.Mana.TryConsume(manaCost))
            return;

        StartCoroutine(ApplyDamageReduction(duration, damageReduction));
    }

    private IEnumerator ApplyDamageReduction(float duration, float reduction)
    {
        _refs.Health.SetDamageReduction(reduction);

        yield return new WaitForSeconds(duration);

        _refs.Health.SetDamageReduction(0f);
    }
}