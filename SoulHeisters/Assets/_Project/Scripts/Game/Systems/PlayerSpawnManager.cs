using System.Collections;
using Unity.Netcode;
using UnityEngine;
using UnityEngine.SceneManagement;

public class PlayerSpawnManager : NetworkBehaviour
{
    [Header("References")]
    [SerializeField] private SpawnSystem spawnSystem;
    [SerializeField] private GameObject playerPrefab;

    [Header("Scene Settings")]
    [SerializeField] private string gameSceneName = "GameScene";

    public override void OnNetworkSpawn()
    {
        if (!IsServer) return;

        NetworkManager.Singleton.OnClientConnectedCallback += HandleClientConnected;

        // Host için zaten bağlı clientlar varsa onları da spawn etmeyi dene
        foreach (var client in NetworkManager.Singleton.ConnectedClientsList)
        {
            StartCoroutine(SpawnPlayerRoutine(client.ClientId));
        }
    }

    public override void OnNetworkDespawn()
    {
        if (!IsServer) return;

        if (NetworkManager.Singleton != null)
        {
            NetworkManager.Singleton.OnClientConnectedCallback -= HandleClientConnected;
        }
    }

    private void HandleClientConnected(ulong clientId)
    {
        StartCoroutine(SpawnPlayerRoutine(clientId));
    }

    private IEnumerator SpawnPlayerRoutine(ulong clientId)
    {
        while (SceneManager.GetActiveScene().name != gameSceneName)
        {
            yield return null;
        }

        while (spawnSystem == null)
        {
            spawnSystem = FindObjectOfType<SpawnSystem>();
            yield return null;
        }

        if (playerPrefab == null)
        {
            yield break;
        }

        if (!NetworkManager.Singleton.ConnectedClients.TryGetValue(clientId, out var client))
        {
            yield break;
        }

        if (client.PlayerObject != null)
        {
            yield break;
        }

        Transform spawnPoint = spawnSystem.GetNextSpawnPoint();
        if (spawnPoint == null)
        {
            yield break;
        }

        GameObject playerInstance = Instantiate(
            playerPrefab,
            spawnPoint.position,
            spawnPoint.rotation
        );

        NetworkObject netObj = playerInstance.GetComponent<NetworkObject>();
        if (netObj == null)
        {
            Destroy(playerInstance);
            yield break;
        }

        netObj.SpawnAsPlayerObject(clientId, true);
    }
}