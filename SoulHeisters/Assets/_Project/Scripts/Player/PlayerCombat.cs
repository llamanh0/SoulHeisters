using System.Collections;
using Unity.Netcode;
using Unity.Netcode.Components;
using UnityEngine;

public class PlayerCombat : NetworkBehaviour
{
    [SerializeField] private Transform firePoint;
    public Transform FirePoint => firePoint;

    [Header("VFXs")]
    [SerializeField] private GameObject boltVFX;
    [SerializeField] private GameObject blinkVFX;
    [SerializeField] private GameObject arcBurstVFX;
    [SerializeField] private GameObject soulGuardVFX;

    [Header("Server Prefab")]
    [SerializeField] private GameObject boltServerPrefab;

    [Header("Aim Settings")]
    [SerializeField] private float maxAimDistance = 200f;

    [Header("Audio")]
    [SerializeField] private AudioClip arcBurstSound;
    [SerializeField] private float arcBurstSoundVolume = 0.6f;

    private PlayerReferences _refs;

    private void Awake()
    {
        _refs = GetComponent<PlayerReferences>();
    }

    private void Start()
    {
        if (firePoint == null)
        {
            firePoint = _refs.Visual.transform.Find("Rig_System/Hand_IK_Target");

            if (firePoint == null)
            {
                var tempGO = new GameObject("FirePoint");
                tempGO.transform.SetParent(_refs.Visual.transform);
                tempGO.transform.localPosition = new Vector3(0.3f, 1.5f, 0.5f);
                firePoint = tempGO.transform;
            }
        }
    }

    private void Update()
    {
        if (!IsOwner) return;

        if (GameStateManager.Instance != null &&
            GameStateManager.Instance.CurrentState != GameState.Playing)
        {
            return;
        }

        if (_refs.Input.FireInput)
        {
            var spell = _refs.SpellInventory.CurrentSpell;
            if (spell == null) return;

            var result = spell.TryCast();
            _refs.SpellInventory.HandleCastResult(result);
        }
    }

    public void ExecuteBolt()
    {
        var def = _refs.SpellInventory.FindSpellDefinition(SpellType.Bolt);
        if (def == null) return;

        Vector3 aimPoint = GetCrosshairAimPoint();
        Vector3 direction = (aimPoint - firePoint.position).normalized;

        CastBoltServerRpc(
            firePoint.position,
            direction,
            def.manaCost,
            def.damage,
            def.projectileSpeed);
    }

    private Vector3 GetCrosshairAimPoint()
    {
        Camera cam = Camera.main;
        if (cam == null)
        {
            return firePoint.position + firePoint.forward * 100f;
        }

        Ray ray = cam.ViewportPointToRay(new Vector3(0.5f, 0.5f, 0f));

        if (Physics.Raycast(ray, out RaycastHit hit, maxAimDistance))
        {
            return hit.point;
        }

        return ray.GetPoint(maxAimDistance);
    }

    [ServerRpc]
    public void CastBoltServerRpc(Vector3 spawnPosition, Vector3 direction, float manaCost, float damage, float projectileSpeed)
    {
        if (!_refs.Mana.TryConsume(manaCost))
            return;

        Quaternion rotation = Quaternion.LookRotation(direction);
        GameObject serverObj = Instantiate(boltServerPrefab, spawnPosition, rotation);

        var projectile = serverObj.GetComponent<ProjectileController>();
        projectile.Initialize(direction, projectileSpeed, damage, OwnerClientId);

        serverObj.GetComponent<NetworkObject>().Spawn();

        CastBoltClientRpc(spawnPosition, direction, projectileSpeed);
    }

    [ClientRpc]
    private void CastBoltClientRpc(Vector3 pos, Vector3 direction, float projectileSpeed)
    {
        Quaternion rotation = Quaternion.LookRotation(direction);
        GameObject visualObj = Instantiate(boltVFX, pos, rotation);

        if (visualObj.TryGetComponent<Rigidbody>(out var rb))
        {
            rb.linearVelocity = direction * projectileSpeed;
        }

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
            netTransform.Teleport(targetPosition, transform.rotation, transform.localScale);
        }

        var controller = GetComponent<CharacterController>();
        if (controller != null)
        {
            controller.enabled = false;
            controller.enabled = true;
        }

        _refs.Locomotion.ResetVerticalVelocity();
    }

    [ClientRpc]
    private void BlinkVFXClientRpc(Vector3 position)
    {
        Instantiate(blinkVFX, position, Quaternion.identity);
    }

    [ServerRpc]
    public void CastArcBurstServerRpc(float radius, float damage, float manaCost)
    {
        if (!_refs.Mana.TryConsume(manaCost))
            return;

        Collider[] hits = Physics.OverlapSphere(transform.position, radius);
        foreach (var hit in hits)
        {
            var damageable = hit.GetComponentInParent<IDamageable>();
            if (damageable == null)
                continue;

            if (ReferenceEquals(damageable, _refs.Health))
                continue;

            damageable.TakeDamage(damage, OwnerClientId);
        }

        ArcBurstVFXClientRpc(transform.position);
    }

    [ClientRpc]
    private void ArcBurstVFXClientRpc(Vector3 pos)
    {
        Instantiate(arcBurstVFX, pos - new Vector3(0f, 7f, 0f), Quaternion.identity);

        if (arcBurstSound != null)
            AudioSource.PlayClipAtPoint(arcBurstSound, pos, arcBurstSoundVolume);
    }

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
        StartCoroutine(nameof(WaitForSoulGuardDuration), duration);
    }

    private IEnumerator WaitForSoulGuardDuration(float duration)
    {
        soulGuardVFX.SetActive(true);
        yield return new WaitForSeconds(duration);
        soulGuardVFX.SetActive(false);
    }

    private IEnumerator ApplyDamageReduction(float duration, float reduction)
    {
        _refs.Health.SetDamageReduction(reduction);
        yield return new WaitForSeconds(duration);
        _refs.Health.SetDamageReduction(0f);
    }
}