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

    private NetworkVariable<bool> _isDead = new NetworkVariable<bool>(
        false,
        NetworkVariableReadPermission.Everyone,
        NetworkVariableWritePermission.Server
    );

    public float CurrentHealth => currentHealth.Value;
    public bool IsDead => _isDead.Value;

    public event Action<float, float> OnHealthChanged;
    public event Action OnDeath;

    private float _damageReductionPercent = 0;

    public override void OnNetworkSpawn()
    {
        if (IsServer)
        {
            currentHealth.Value = maxHealth;
            _isDead.Value = false;
        }

        currentHealth.OnValueChanged += HandleHealthChanged;
        _isDead.OnValueChanged += HandleDeathStateChanged;
    }

    public override void OnNetworkDespawn()
    {
        currentHealth.OnValueChanged -= HandleHealthChanged;
        _isDead.OnValueChanged -= HandleDeathStateChanged;
    }

    public void TakeDamage(float amount, ulong dealerClientId)
    {
        if (!IsServer || _isDead.Value) return;

        float finalDamage = amount * (1f - _damageReductionPercent);
        currentHealth.Value = Mathf.Max(0f, currentHealth.Value - finalDamage);

        Debug.Log($"[HealthComponent] Client {OwnerClientId} took {finalDamage} damage. Health: {currentHealth.Value}");

        if (currentHealth.Value <= 0f && !_isDead.Value)
        {
            _isDead.Value = true;
            Debug.Log($"[HealthComponent] Client {OwnerClientId} died (server)");
        }
    }

    private void HandleHealthChanged(float previousValue, float newValue)
    {
        OnHealthChanged?.Invoke(previousValue, newValue);
    }

    private void HandleDeathStateChanged(bool wasAlive, bool isDead)
    {
        if (isDead)
        {
            Debug.Log($"[HealthComponent] Death state changed to dead for client {OwnerClientId}");
            OnDeath?.Invoke();
        }
        else
        {
            Debug.Log($"[HealthComponent] Death state changed to alive for client {OwnerClientId}");
        }
    }

    public void SetDamageReduction(float percent)
    {
        _damageReductionPercent = percent;
    }

    public void ResetHealth()
    {
        if (!IsServer)
        {
            Debug.LogError("[HealthComponent] ResetHealth called on client!");
            return;
        }

        Debug.Log($"[HealthComponent] Resetting health for client {OwnerClientId}");
        currentHealth.Value = maxHealth;
        _isDead.Value = false;
    }
}