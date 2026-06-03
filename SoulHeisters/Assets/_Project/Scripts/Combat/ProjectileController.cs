using Unity.Netcode;
using UnityEngine;

[RequireComponent(typeof(Rigidbody))]
public class ProjectileController : NetworkBehaviour
{
    [SerializeField] private float lifeTime = 5f;
    [SerializeField] private GameObject hitEffectPrefab;
    [SerializeField] private LayerMask collisionLayers = -1;

    private Rigidbody _rb;
    private float _damage;
    private ulong _ownerId;
    private bool _hasHit = false;

    private void Awake()
    {
        _rb = GetComponent<Rigidbody>();

        var collider = GetComponent<Collider>();
        if (collider != null)
        {
            collider.isTrigger = true;
        }
    }

    public void Initialize(Vector3 direction, float speed, float damageAmount, ulong ownerId)
    {
        _damage = damageAmount;
        _ownerId = ownerId;
        _hasHit = false;

        _rb.linearVelocity = direction * speed;
        Invoke(nameof(DestroyProjectile), lifeTime);
    }

    private void OnTriggerEnter(Collider other)
    {
        if (!IsServer || _hasHit) return;

        NetworkObject netObj = other.GetComponentInParent<NetworkObject>();
        if (netObj != null)
        {
            var playerRefs = netObj.GetComponent<PlayerReferences>();
            if (playerRefs != null && netObj.OwnerClientId == _ownerId)
            {
                return;
            }
        }

        _hasHit = true;

        Vector3 hitPoint = transform.position;
        Vector3 hitNormal = -_rb.linearVelocity.normalized;

        IDamageable damageable = other.GetComponentInParent<IDamageable>();
        if (damageable != null)
        {
            damageable.TakeDamage(_damage, _ownerId);
        }
        else
        {
            var health = other.GetComponentInParent<HealthComponent>();
            if (health != null)
            {
                health.TakeDamage(_damage, _ownerId);
            }
        }

        SpawnHitEffectClientRpc(hitPoint, hitNormal);
        DestroyProjectile();
    }

    [ClientRpc]
    private void SpawnHitEffectClientRpc(Vector3 position, Vector3 normal)
    {
        if (hitEffectPrefab != null)
        {
            Quaternion rotation = Quaternion.LookRotation(normal);
            GameObject effect = Instantiate(hitEffectPrefab, position, rotation);
            Destroy(effect, 2f);
        }
    }

    private void DestroyProjectile()
    {
        CancelInvoke();

        if (NetworkObject != null && NetworkObject.IsSpawned)
        {
            NetworkObject.Despawn(true);
        }
    }
}