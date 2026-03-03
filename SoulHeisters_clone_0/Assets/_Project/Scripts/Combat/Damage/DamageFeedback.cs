using Unity.Netcode;
using UnityEngine;

[RequireComponent(typeof(HealthComponent))]
public class DamageFeedback : NetworkBehaviour
{
    private HealthComponent health;

    private void Awake()
    {
        health = GetComponent<HealthComponent>();
    }

    public override void OnNetworkSpawn()
    {
        health.OnHealthChanged += (oldVal, newVal) =>
        {
            if (!IsOwner && oldVal > newVal)
                DamageNumberManager.Instance.SpawnDamageNumber(transform.position + Vector3.up * 2f, oldVal - newVal);
        };
    }
}