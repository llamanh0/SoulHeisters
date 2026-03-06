using System.Collections.Generic;
using Unity.Netcode;
using UnityEngine;

/// <summary>
/// Dunyadaki mob spawn noktalarini yoneten ve mob'lari mac durumuna gore
/// spawn / despawn eden sistem.
/// 
/// Sorumluluklar:
/// - Sahnedeki tum MobSpawnPoint'leri bulmak
/// - Mac basladiginda her spawn noktasinda mob olusturmak
/// - Mac bittiginde tum aktif mob'lari despawn etmek
/// </summary>
public class WorldMobManager : NetworkBehaviour
{
    private List<MobSpawnPoint> spawnPoints = new();
    private List<NetworkObject> activeMobs = new();

    private void Awake()
    {
        // Sahnedeki tum MobSpawnPoint component'lerini topla
        spawnPoints.AddRange(FindObjectsOfType<MobSpawnPoint>());
    }

    public override void OnNetworkSpawn()
    {
        if (!IsServer) return;

        // Mac baslangici ve bitisi event'lerine abone ol
        if (GameStateManager.Instance != null)
        {
            GameStateManager.Instance.OnMatchStarted += SpawnAllMobs;
            GameStateManager.Instance.OnMatchEnded += DespawnAllMobs;
        }
    }

    private void OnDestroy()
    {
        if (!IsServer) return;

        // Event aboneliklerini temizle
        if (GameStateManager.Instance != null)
        {
            GameStateManager.Instance.OnMatchStarted -= SpawnAllMobs;
            GameStateManager.Instance.OnMatchEnded -= DespawnAllMobs;
        }
    }

    /// <summary>
    /// Tanimli tum spawn noktalarinda birer mob olusturur.
    /// Sadece server tarafinda cagrilmalidir.
    /// </summary>
    private void SpawnAllMobs()
    {
        foreach (var point in spawnPoints)
        {
            GameObject mob = Instantiate(
                point.MobPrefab,
                point.SpawnTransform.position,
                point.SpawnTransform.rotation);

            var netObj = mob.GetComponent<NetworkObject>();
            netObj.Spawn();

            // Ortak olum logigi icin EntityLifecycleSystem'e kayit
            if (EntityLifecycleSystem.Instance != null)
            {
                EntityLifecycleSystem.Instance.RegisterEntity(netObj);
            }

            activeMobs.Add(netObj);
        }
    }

    /// <summary>
    /// Aktif tum mob'lari despawn eder ve listeyi temizler.
    /// Mac bittiginde cagrilir.
    /// </summary>
    private void DespawnAllMobs()
    {
        foreach (var mob in activeMobs)
        {
            if (mob != null && mob.IsSpawned)
            {
                mob.Despawn(true);
            }
        }

        activeMobs.Clear();
    }
}