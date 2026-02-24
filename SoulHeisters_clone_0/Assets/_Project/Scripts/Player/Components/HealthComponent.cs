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

        currentHealth.Value = Mathf.Clamp(currentHealth.Value - amount, 0, maxHealth);

        Debug.Log($"{OwnerClientId} hitted by {dealerClientId} => Dealed damage: {amount}");

        if (IsDead)
        {
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
}
