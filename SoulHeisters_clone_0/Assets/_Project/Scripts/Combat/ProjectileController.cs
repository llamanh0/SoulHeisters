using Unity.Netcode;
using UnityEngine;

[RequireComponent(typeof(Rigidbody))]
public class ProjectileController : NetworkBehaviour
{
    [SerializeField] private float lifeTime = 5f;

    private Rigidbody _rb;
    private float _damage;
    private ulong _ownerId;

    private void Awake()
    {
        _rb = GetComponent<Rigidbody>();
    }

    public void Initialize(Vector3 direction, float speed, float damageAmount, ulong ownerId)
    {
        _damage = damageAmount;
        _ownerId = ownerId;

        _rb.velocity = direction * speed;

        Invoke(nameof(DestroyProjectile), lifeTime);
    }

    private void OnTriggerEnter(Collider other)
    {
        if (!IsServer) return;

        NetworkObject netObj = other.GetComponentInParent<NetworkObject>();
        if (netObj != null)
        {
            if (netObj.OwnerClientId == _ownerId) return;
        }

        IDamageable damageable = other.GetComponentInParent<IDamageable>();
        if (damageable != null)
        {
            damageable.TakeDamage(_damage, _ownerId);
        }

        DestroyProjectile();
    }

    private void DestroyProjectile()
    {
        if (NetworkObject.IsSpawned)
        {
            NetworkObject.Despawn(true);
        }
    }
}