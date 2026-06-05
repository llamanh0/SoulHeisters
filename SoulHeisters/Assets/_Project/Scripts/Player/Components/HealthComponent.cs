using System;
using Unity.Netcode;
using UnityEngine;

public class HealthComponent : NetworkBehaviour, IDamageable
{
    [SerializeField] private float maxHealth = 100f;
    public NetworkVariable<float> currentHealth = new(100f, NetworkVariableReadPermission.Everyone, NetworkVariableWritePermission.Server);
    private NetworkVariable<bool> _isDead = new(false, NetworkVariableReadPermission.Everyone, NetworkVariableWritePermission.Server);

    public float CurrentHealth => currentHealth.Value;
    public bool IsDead => _isDead.Value;

    public event Action<float, float> OnHealthChanged;
    public event Action OnDeath;

    private float _damageReductionPercent = 0f;

    public override void OnNetworkSpawn()
    {
        if (IsServer)
        {
            currentHealth.Value = maxHealth;
            _isDead.Value = false;
        }

        currentHealth.OnValueChanged += HandleHealthChanged;
        _isDead.OnValueChanged += HandleDeathChanged;
    }

    public override void OnNetworkDespawn()
    {
        currentHealth.OnValueChanged -= HandleHealthChanged;
        _isDead.OnValueChanged -= HandleDeathChanged;
    }

    private void HandleHealthChanged(float p, float n)
    {
        OnHealthChanged?.Invoke(p, n);
    }

    private void HandleDeathChanged(bool w, bool d)
    {
        if (d)
        {
            OnDeath?.Invoke();
        }
    }

    public void TakeDamage(float amt, ulong dealerId)
    {
        if (!IsServer || _isDead.Value) return;

        float actualDamage = amt * (1f - _damageReductionPercent);
        currentHealth.Value = Mathf.Max(0f, currentHealth.Value - actualDamage);

        if (currentHealth.Value <= 0f && !_isDead.Value)
        {
            _isDead.Value = true;
        }
    }

    public void SetDamageReduction(float p)
    {
        _damageReductionPercent = Mathf.Clamp01(p);
    }

    public void ResetHealth()
    {
        if (IsServer)
        {
            currentHealth.Value = maxHealth;
            _isDead.Value = false;
        }
    }
}