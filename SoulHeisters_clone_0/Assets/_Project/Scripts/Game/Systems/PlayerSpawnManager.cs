using System.Collections;
using Unity.Netcode;
using UnityEngine;
using UnityEngine.SceneManagement;

/// <summary>
/// Oyuncu spawn sistemini yonetir
/// SADECE GameScene'de calisir
/// </summary>
public class PlayerSpawnManager : NetworkBehaviour
{
    [Header("References")]
    [SerializeField] private SpawnSystem spawnSystem;
    [SerializeField] private GameObject playerPrefab;

    [Header("Scene Settings")]
    [SerializeField] private string gameSceneName = "GameScene";

    private bool _hasInitialized = false;

    public override void OnNetworkSpawn()
    {
        if (!IsServer) return;

        // Sahne kontrolu
        string currentScene = SceneManager.GetActiveScene().name;
        Debug.Log($"[PlayerSpawnManager] OnNetworkSpawn in scene: {currentScene}");

        if (currentScene != gameSceneName)
        {
            Debug.Log("[PlayerSpawnManager] Not in GameScene, waiting for scene load");
            NetworkManager.Singleton.SceneManager.OnLoadEventCompleted += OnSceneLoadCompleted;
            return;
        }

        InitializeSpawning();
    }

    public override void OnNetworkDespawn()
    {
        if (!IsServer) return;

        if (NetworkManager.Singleton != null)
        {
            NetworkManager.Singleton.OnClientConnectedCallback -= HandleClientConnected;
            NetworkManager.Singleton.SceneManager.OnLoadEventCompleted -= OnSceneLoadCompleted;
        }
    }

    private void OnSceneLoadCompleted(string sceneName, UnityEngine.SceneManagement.LoadSceneMode loadSceneMode, 
        System.Collections.Generic.List<ulong> clientsCompleted, System.Collections.Generic.List<ulong> clientsTimedOut)
    {
        Debug.Log($"[PlayerSpawnManager] Scene load completed: {sceneName}");

        if (sceneName == gameSceneName && !_hasInitialized)
        {
            InitializeSpawning();
        }
    }

    private void InitializeSpawning()
    {
        if (_hasInitialized)
        {
            Debug.LogWarning("[PlayerSpawnManager] Already initialized!");
            return;
        }

        _hasInitialized = true;
        Debug.Log("[PlayerSpawnManager] Initializing spawning in GameScene");

        // Client connected event'i dinle
        NetworkManager.Singleton.OnClientConnectedCallback += HandleClientConnected;

        // Mevcut tum client'lar icin spawn et
        foreach (var client in NetworkManager.Singleton.ConnectedClientsList)
        {
            Debug.Log($"[PlayerSpawnManager] Checking client {client.ClientId}");

            // Zaten player object varsa atla
            if (client.PlayerObject != null)
            {
                Debug.Log($"[PlayerSpawnManager] Client {client.ClientId} already has PlayerObject");
                continue;
            }

            StartCoroutine(SpawnPlayerRoutine(client.ClientId));
        }
    }

    private void HandleClientConnected(ulong clientId)
    {
        Debug.Log($"[PlayerSpawnManager] Client connected: {clientId}");

        // Henuz initialize olmadiysa atla
        if (!_hasInitialized)
        {
            Debug.Log("[PlayerSpawnManager] Not initialized yet, skipping");
            return;
        }

        // Sahne kontrolu
        if (SceneManager.GetActiveScene().name != gameSceneName)
        {
            Debug.Log("[PlayerSpawnManager] Not in GameScene, skipping spawn");
            return;
        }

        StartCoroutine(SpawnPlayerRoutine(clientId));
    }

    private IEnumerator SpawnPlayerRoutine(ulong clientId)
    {
        Debug.Log($"[PlayerSpawnManager] Starting spawn routine for client {clientId}");

        // SpawnSystem yuklenene kadar bekle
        int attempts = 0;
        while (spawnSystem == null && attempts < 100)
        {
            spawnSystem = FindObjectOfType<SpawnSystem>();
            attempts++;
            yield return null;
        }

        if (spawnSystem == null)
        {
            Debug.LogError("[PlayerSpawnManager] SpawnSystem not found!");
            yield break;
        }

        // Client hala bagli mi?
        if (!NetworkManager.Singleton.ConnectedClients.TryGetValue(clientId, out var client))
        {
            Debug.LogWarning($"[PlayerSpawnManager] Client {clientId} not found");
            yield break;
        }

        // Zaten player object varsa atla
        if (client.PlayerObject != null)
        {
            Debug.Log($"[PlayerSpawnManager] Client {clientId} already has PlayerObject, skipping");
            yield break;
        }

        if (playerPrefab == null)
        {
            Debug.LogError("[PlayerSpawnManager] Player prefab is null!");
            yield break;
        }

        Transform spawnPoint = spawnSystem.GetNextSpawnPoint();
        if (spawnPoint == null)
        {
            Debug.LogError("[PlayerSpawnManager] No spawn point available!");
            yield break;
        }

        Debug.Log($"[PlayerSpawnManager] Spawning player {clientId} at {spawnPoint.position}");

        GameObject playerInstance = Instantiate(
            playerPrefab,
            spawnPoint.position,
            spawnPoint.rotation
        );

        NetworkObject netObj = playerInstance.GetComponent<NetworkObject>();
        if (netObj == null)
        {
            Debug.LogError("[PlayerSpawnManager] NetworkObject not found on player prefab!");
            Destroy(playerInstance);
            yield break;
        }

        // Spawn!
        netObj.SpawnAsPlayerObject(clientId, true);
        Debug.Log($"[PlayerSpawnManager] Player {clientId} spawned successfully (NetworkObjectId: {netObj.NetworkObjectId})");
    }
}