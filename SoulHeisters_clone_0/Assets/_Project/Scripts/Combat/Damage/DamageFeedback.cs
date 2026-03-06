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
        if (health == null) return;

        // Saglik degistiginde local olarak damage popup cikar.
        health.OnHealthChanged += HandleHealthChanged;
    }

    public override void OnNetworkDespawn()
    {
        if (health != null)
        {
            health.OnHealthChanged -= HandleHealthChanged;
        }
    }

    private void HandleHealthChanged(float oldVal, float newVal)
    {
        // Heal veya degisiklik yoksa cik
        if (newVal >= oldVal) return;
        if (DamageNumberManager.Instance == null) return;

        float damage = oldVal - newVal;

        // Bu entity'nin biraz ustunde damage sayisi spawn et
        DamageNumberManager.Instance.SpawnDamageNumber(
            transform.position + Vector3.up * 2f,
            damage);
    }
}