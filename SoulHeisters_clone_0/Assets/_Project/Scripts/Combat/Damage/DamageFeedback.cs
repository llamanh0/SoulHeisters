using Unity.Netcode;
using UnityEngine;

/// <summary>
/// Saglik degisimlerini dinleyerek hasar alindiginda ekranda
/// hasar sayilari gosteren basit feedback sistemi.
/// 
/// Calisma mantigi:
/// - HealthComponent.OnHealthChanged event'ine abone olur.
/// - Sadece local owner olmayan objelerde (diger oyuncular veya mob'lar)
///   hasar alindiginda DamageNumber spawn eder.
/// 
/// Not:
/// - Bu script NetworkBehaviour oldugu icin IsOwner, bu entity'nin
///   local client'a mi ait oldugunu gosterir.
/// </summary>
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

        health.OnHealthChanged += HandleHealthChanged;
    }

    public override void OnNetworkDespawn()
    {
        if (health != null)
        {
            health.OnHealthChanged -= HandleHealthChanged;
        }
    }

    /// <summary>
    /// Saglik her degistiginde cagrilir.
    /// Eger saglik azaldiysa ve bu entity local owner degilse,
    /// ekranda hasar sayisi gosterilir.
    /// </summary>
    private void HandleHealthChanged(float oldVal, float newVal)
    {
        // Hasar alinmamis (artik saglik artmis) ise cik
        if (newVal >= oldVal) return;

        // Kendi karakterimiz icin damage number gostermek istemiyorsak:
        if (IsOwner) return;

        float damage = oldVal - newVal;

        if (DamageNumberManager.Instance != null)
        {
            // Hasar sayisini, karakterin biraz ustunde spawn et
            DamageNumberManager.Instance.SpawnDamageNumber(
                transform.position + Vector3.up * 2f,
                damage);
        }
    }
}