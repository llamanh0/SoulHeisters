using System.Collections;
using Unity.Netcode;
using Unity.Netcode.Components;
using UnityEngine;
using UnityEngine.UIElements;

public class PlayerCombat : NetworkBehaviour
{
    [Header("Bolt Config")]
    [SerializeField] private Transform firePoint;

    public Transform FirePoint => firePoint;

    [SerializeField] private GameObject blinkVFX;
    [SerializeField] private GameObject arcBurstVFX;
    [SerializeField] private GameObject soulGuardVFX;

    private PlayerReferences _refs;

    private void Awake()
    {
        _refs = GetComponent<PlayerReferences>();
    }

    private void Update()
    {
        if (!IsOwner) return;

        if (_refs.Input.FireInput)
        {
            var spell = _refs.SpellInventory.CurrentSpell;
            if (spell == null) return;

            var result = spell.TryCast();

            _refs.SpellInventory.HandleCastResult(result);
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

        ApproveBlinkClientRpc(targetPosition, OwnerClientId);
        BlinkVFXClientRpc(targetPosition);
    }

    [ClientRpc]
    private void ApproveBlinkClientRpc(Vector3 targetPosition, ulong ownerId)
    {
        if (NetworkManager.Singleton.LocalClientId != ownerId)
            return;

        var netTransform = GetComponent<NetworkTransform>();

        if (netTransform != null)
        {
            netTransform.Teleport(
                targetPosition,
                transform.rotation,
                transform.localScale);
        }

        var controller = GetComponent<CharacterController>();
        if (controller != null)
        {
            controller.enabled = false;
            controller.enabled = true;
        }

        _refs.Locomotion.ResetVelocity();
    }

    [ClientRpc] private void BlinkVFXClientRpc(Vector3 position) { Instantiate(blinkVFX, position, Quaternion.identity); }

    [ServerRpc]
    public void CastArcBurstServerRpc(float radius, float damage, float manaCost)
    {
        if (!_refs.Mana.TryConsume(manaCost))
            return;

        Collider[] hits = Physics.OverlapSphere(transform.position, radius);

        foreach (var hit in hits)
        {
            if (hit.TryGetComponent<NetworkObject>(out var netObj))
            {
                if (netObj.OwnerClientId == OwnerClientId)
                    continue;
            }

            if (hit.TryGetComponent<IDamageable>(out var dmg))
            {
                dmg.TakeDamage(damage, OwnerClientId);
            }
        }

        ArcBurstVFXClientRpc();
    }

    [ClientRpc] private void ArcBurstVFXClientRpc() { Instantiate(arcBurstVFX, transform.position - new Vector3(0f, 7f, 0f), Quaternion.identity); }

    [ServerRpc]
    public void CastSoulGuardServerRpc(float duration, float damageReduction, float manaCost)
    {
        if (!_refs.Mana.TryConsume(manaCost))
            return;

        StartCoroutine(ApplyDamageReduction(duration, damageReduction));
        SoulGuardVFXClientRpc(duration);
    }

    [ClientRpc]
    private void SoulGuardVFXClientRpc(float duration)  
    {
        //Instantiate(soulGuardVFX, transform.position, Quaternion.identity);
        //Invoke(nameof(Destroy),duration);
    }

    private IEnumerator ApplyDamageReduction(float duration, float reduction)
    {
        _refs.Health.SetDamageReduction(reduction);

        yield return new WaitForSeconds(duration);

        _refs.Health.SetDamageReduction(0f);
    }
}