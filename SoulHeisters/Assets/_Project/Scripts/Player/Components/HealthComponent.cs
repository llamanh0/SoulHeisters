using System;
using Unity.Netcode;
using UnityEngine;

public class HealthComponent : NetworkBehaviour, IDamageable
{
    [SerializeField] private float maxHealth = 100f;

    public NetworkVariable<float> currentHealth = new NetworkVariable<float>(
        100f,
        NetworkVariableReadPermission.Everyone,
        NetworkVariableWritePermission.Server
    );
    public float CurrentHealth => currentHealth.Value; // Main Value (reflesh both Server and Clients)

    public bool IsDead => currentHealth.Value <= 0;

    public event Action<float, float> OnHealthChanged;
    public event Action OnDeath;

    private float _damageReductionPercent = 0;

    public override void OnNetworkSpawn()
    {
        if (IsServer) { currentHealth.Value = maxHealth; }

        currentHealth.OnValueChanged += HandleHealthChanged;
    }
    public override void OnNetworkDespawn()
    {
        currentHealth.OnValueChanged -= HandleHealthChanged;
    }

    public void TakeDamage(float amount, ulong dealerClientId)
    {
        if (!IsServer || IsDead) return;

        float finalDamage = amount * (1f - _damageReductionPercent);

        currentHealth.Value -= finalDamage;
    }
    private void HandleHealthChanged(float previousValue, float newValue)
    {
        OnHealthChanged?.Invoke(previousValue, newValue);

        // DIE
        if (IsDead) { OnDeath?.Invoke(); currentHealth.Value = 0; }
    }

    public void SetDamageReduction(float percent)
    {
        _damageReductionPercent = percent;
    }
}
