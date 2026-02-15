using Unity.Netcode;
using UnityEngine;

public class ProjectileController : NetworkBehaviour
{
    private float _speed;
    private float _damage;
    private ulong _ownerId;

    public void Initialize(float speed, float damage, ulong ownerId)
    {
        _speed = speed;
        _damage = damage;
        _ownerId = ownerId;
    }

    private void FixedUpdate()
    {
        if (!IsServer) return;

        transform.position += transform.forward * _speed * Time.fixedDeltaTime;
    }

    private void OnTriggerEnter(Collider other)
    {
        if (!IsServer) return;

        if (other.TryGetComponent(out NetworkObject netObj))
        {
            if (netObj.OwnerClientId == _ownerId) return;
        }

        Debug.Log($"Projectile hit: {other.name}");

        GetComponent<NetworkObject>().Despawn();
    }
}