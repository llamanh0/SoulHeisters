using Unity.Netcode;
using UnityEngine;

public class ProjectileController : NetworkBehaviour
{
    private float _speed;
    private float _damage;
    private ulong _ownerId; // To prevent hitting self

    public void Initialize(float speed, float damage, ulong ownerId)
    {
        _speed = speed;
        _damage = damage;
        _ownerId = ownerId;
    }

    private void FixedUpdate()
    {
        // Server-Authoritative movement
        if (!IsServer) return;

        transform.position += transform.forward * _speed * Time.fixedDeltaTime;
    }

    private void OnTriggerEnter(Collider other)
    {
        if (!IsServer) return;

        // Ignore self-collision
        if (other.TryGetComponent(out NetworkObject netObj))
        {
            if (netObj.OwnerClientId == _ownerId) return;
        }

        // TODO: Implement IDamageable check here later
        Debug.Log($"Projectile hit: {other.name}");

        // Destroy on impact
        GetComponent<NetworkObject>().Despawn();
    }
}