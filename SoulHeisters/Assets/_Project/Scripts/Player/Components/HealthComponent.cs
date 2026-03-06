using System;
using Unity.Netcode;
using UnityEngine;

/// <summary>
/// Network uzerinden senkronize edilen saglik sistemi.
/// 
/// Sorumluluklar:
/// - Mevcut saglik degerini NetworkVariable ile saklamak
/// - IDamageable arayuzunu implement etmek
/// - Server tarafinda hasar uygulamak ve olum event'lerini tetiklemek
/// 
/// Eventler:
/// - OnHealthChanged: Saglik her degistiginde (UI, efektler icin)
/// - OnDeath: Saglik sifira dustugunde (ragdoll, despawn vs. icin)
/// </summary>
public class HealthComponent : NetworkBehaviour, IDamageable
{
    [SerializeField] private float maxHealth = 100f;

    /// <summary>
    /// Network uzerinde herkesin okuyabildigi, yalnizca server'in yazabildigi saglik.
    /// </summary>
    public NetworkVariable<float> currentHealth = new NetworkVariable<float>(
        100f,
        NetworkVariableReadPermission.Everyone,
        NetworkVariableWritePermission.Server
    );

    /// <summary> Mevcut saglik degeri (network senkronize). </summary>
    public float CurrentHealth => currentHealth.Value;

    /// <summary> Saglik sifir veya altina dustugunde true olur. </summary>
    public bool IsDead => currentHealth.Value <= 0;

    /// <summary> Saglik degistiginde (onceki, yeni) degerlerle tetiklenir. </summary>
    public event Action<float, float> OnHealthChanged;

    /// <summary> Saglik sifira dustugunde bir kez tetiklenir. </summary>
    public event Action OnDeath;

    private float _damageReductionPercent = 0;

    public override void OnNetworkSpawn()
    {
        if (IsServer)
        {
            // Server uzerinde baslangic sagligini ayarlayalim
            currentHealth.Value = maxHealth;
        }

        // NetworkVariable degistiginde local handler'i cagir
        currentHealth.OnValueChanged += HandleHealthChanged;
    }

    public override void OnNetworkDespawn()
    {
        currentHealth.OnValueChanged -= HandleHealthChanged;
    }

    /// <summary>
    /// IDamageable implementasyonu.
    /// Hasar sadece server tarafinda uygulanir.
    /// </summary>
    public void TakeDamage(float amount, ulong dealerClientId)
    {
        if (!IsServer || IsDead) return;

        float finalDamage = amount * (1f - _damageReductionPercent);
        currentHealth.Value -= finalDamage;
    }

    /// <summary>
    /// Saglik NetworkVariable'i degistiginde cagrilir.
    /// Buradan event'ler araciligiyla UI ve diger sistemler bilgilendirilir.
    /// </summary>
    private void HandleHealthChanged(float previousValue, float newValue)
    {
        OnHealthChanged?.Invoke(previousValue, newValue);

        // Olum kontrolu
        if (IsDead)
        {
            OnDeath?.Invoke();
            currentHealth.Value = 0;
        }
    }

    /// <summary>
    /// Alinan hasari azaltmak icin yuzde cinsinden damage reduction belirler.
    /// Ornek: 0.3 => %30 daha az hasar.
    /// </summary>
    public void SetDamageReduction(float percent)
    {
        _damageReductionPercent = percent;
    }
}