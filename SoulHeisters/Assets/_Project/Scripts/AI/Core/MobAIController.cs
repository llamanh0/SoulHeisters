using Unity.Netcode;
using UnityEngine;

/// <summary>
/// Basit server-side mob yapay zekasi.
/// 
/// Sorumluluklar:
/// - Belirli bir menzil icindeki oyunculari bulmak (aggro)
/// - Hedef belirlemek ve ona dogru hareket etmek
/// - Oldugunde NetworkObject'i despawn etmek (opsiyonel; EntityLifecycleSystem ile cakismamasi gerekir)
/// 
/// Notlar:
/// - Tum mantik sadece server tarafinda calisir (IsServer kontrolu).
/// - Client'lar mob pozisyonunu NetworkTransform uzerinden gorur.
/// </summary>
public class MobAIController : NetworkBehaviour
{
    [SerializeField] private float aggroRange = 10f;
    [SerializeField] private float moveSpeed = 3f;

    private HealthComponent health;
    private Transform target;

    public override void OnNetworkSpawn()
    {
        if (!IsServer) return;

        // health = GetComponent<HealthComponent>();
        // if (health != null)
        // {
        //     health.OnDeath += HandleDeath;
        // }
    }

    private void OnDestroy()
    {
        if (!IsServer) return;

        if (health != null)
        {
            health.OnDeath -= HandleDeath;
        }
    }

    private void Update()
    {
        if (!IsServer) return;

        // Hedef yoksa bir oyuncu ara
        if (target == null)
            FindTarget();

        // Hedef varsa ona dogru ilerle
        if (target != null)
            ChaseTarget();
    }

    /// <summary>
    /// Artik EntityLifecycleSystem tarafindan yapiliyor
    /// </summary>
    private void HandleDeath()
    {
        return;
    }

    /// <summary>
    /// Bagli tum client'larin PlayerObject'lerini tarar ve
    /// aggroRange icinde olan ilk oyuncuyu hedef olarak secer.
    /// </summary>
    private void FindTarget()
    {
        foreach (var client in NetworkManager.Singleton.ConnectedClientsList)
        {
            var player = client.PlayerObject;
            if (player == null) continue;

            float dist = Vector3.Distance(
                transform.position,
                player.transform.position);

            if (dist < aggroRange)
            {
                target = player.transform;
                break;
            }
        }
    }

    /// <summary>
    /// Mevcut hedefe dogru sabit bir hizla hareket eder.
    /// </summary>
    private void ChaseTarget()
    {
        Vector3 dir = (target.position - transform.position).normalized;
        transform.position += dir * moveSpeed * Time.deltaTime;
    }
}