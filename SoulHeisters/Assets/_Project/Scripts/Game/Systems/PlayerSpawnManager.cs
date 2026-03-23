using Unity.Netcode;
using UnityEngine;

public class PlayerSpawnManager : NetworkBehaviour
{
    [SerializeField] private SpawnSystem spawnSystem;

    public override void OnNetworkSpawn()
    {
        if (!IsServer) return;
        NetworkManager.Singleton.OnClientConnectedCallback += HandlePlayerSpawn;
    }

    private void HandlePlayerSpawn(ulong clientId)
    {
        var playerObj = NetworkManager.Singleton.ConnectedClients[clientId].PlayerObject;
        if (playerObj == null || spawnSystem == null) return;

        Transform spawnPoint = spawnSystem.GetRandomSpawnPoint();
        if (spawnPoint != null)
        {
            playerObj.transform.position = spawnPoint.position;
            playerObj.transform.rotation = spawnPoint.rotation;
        }
    }
}