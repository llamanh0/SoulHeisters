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
    public float CurrentHealth => currentHealth.Value;

    public bool IsDead => currentHealth.Value <= 0;

    public event Action<float, float> OnHealthChanged;
    public event Action OnDeath;

    private float _damageReductionPercent = 0.5f;

    public override void OnNetworkSpawn()
    {
        if (IsServer)
        {
            currentHealth.Value = maxHealth;
        }

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
        ShowDamageClientRpc(finalDamage);

        if (IsDead || currentHealth.Value <= 0)
        {
            currentHealth.Value = 0;
            DieClientRpc();
        }

        
    }
    private void HandleHealthChanged(float previousValue, float newValue)
    {
        OnHealthChanged?.Invoke(previousValue, newValue);
    }

    [ClientRpc]
    private void DieClientRpc()
    {
        OnDeath?.Invoke();
    }
    public void SetDamageReduction(float percent)
    {
        _damageReductionPercent = percent;
    }

    [ClientRpc]
    private void ShowDamageClientRpc(float damage)
    {
        Vector3 spawnPos = transform.position + Vector3.up * 2f;

        DamageNumberManager.Instance.SpawnDamageNumber(spawnPos, damage);
    }
}
