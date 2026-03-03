using System.Collections.Generic;
using Unity.Netcode;
using UnityEngine;

public class WorldMobManager : NetworkBehaviour
{
    private List<MobSpawnPoint> spawnPoints = new();
    private List<NetworkObject> activeMobs = new();

    private void Awake()
    {
        spawnPoints.AddRange(FindObjectsOfType<MobSpawnPoint>());
    }

    public override void OnNetworkSpawn()
    {
        if (!IsServer) return;

        GameStateManager.Instance.OnMatchStarted += SpawnAllMobs;
        GameStateManager.Instance.OnMatchEnded += DespawnAllMobs;
    }

    private void SpawnAllMobs()
    {
        foreach (var point in spawnPoints)
        {
            GameObject mob = Instantiate(point.MobPrefab,
                                         point.SpawnTransform.position,
                                         point.SpawnTransform.rotation);

            var netObj = mob.GetComponent<NetworkObject>();
            netObj.Spawn();

            EntityLifecycleSystem.Instance.RegisterEntity(netObj);

            activeMobs.Add(netObj);
        }
    }

    private void DespawnAllMobs()
    {
        foreach (var mob in activeMobs)
        {
            if (mob != null && mob.IsSpawned)
                mob.Despawn(true);
        }

        activeMobs.Clear();
    }
}