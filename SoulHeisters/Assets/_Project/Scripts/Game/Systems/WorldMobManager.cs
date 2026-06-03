using System.Collections.Generic;
using Unity.Netcode;
using UnityEngine;

public class WorldMobManager : NetworkBehaviour
{
    private List<MobSpawner> spawners = new();

    public override void OnNetworkSpawn()
    {
        if (!IsServer) return;

        spawners.AddRange(FindObjectsOfType<MobSpawner>());

        if (GameStateManager.Instance != null)
        {
            GameStateManager.Instance.OnMatchStarted += SpawnAllMobs;
        }
    }

    public override void OnNetworkDespawn()
    {
        if (!IsServer) return;

        if (GameStateManager.Instance != null)
        {
            GameStateManager.Instance.OnMatchStarted -= SpawnAllMobs;
        }
    }

    private void SpawnAllMobs()
    {
        foreach (var spawner in spawners)
        {
            spawner.SpawnMob();
        }
    }
}