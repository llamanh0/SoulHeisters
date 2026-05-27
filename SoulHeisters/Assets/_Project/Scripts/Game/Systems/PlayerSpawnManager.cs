using System.Collections;
using System.Collections.Generic;
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

    private HashSet<ulong> _spawnedPlayers = new HashSet<ulong>();
    private bool _hasInitialized = false;

    public override void OnNetworkSpawn()
    {
        if (!IsServer) return;

        string currentScene = SceneManager.GetActiveScene().name;
        Debug.Log($"[PlayerSpawnManager] OnNetworkSpawn in scene: {currentScene}");

        NetworkManager.Singleton.SceneManager.OnLoadEventCompleted += OnSceneLoadCompleted;
        NetworkManager.Singleton.OnClientConnectedCallback += HandleClientConnected;

        if (currentScene == gameSceneName)
        {
            Debug.Log("[PlayerSpawnManager] Already in GameScene, initializing immediately");
            InitializeSpawning();
        }
    }

    public override void OnNetworkDespawn()
    {
        if (!IsServer) return;

        if (NetworkManager.Singleton != null)
        {
            NetworkManager.Singleton.OnClientConnectedCallback -= HandleClientConnected;

            if (NetworkManager.Singleton.SceneManager != null)
                NetworkManager.Singleton.SceneManager.OnLoadEventCompleted -= OnSceneLoadCompleted;
        }
    }

    private void OnSceneLoadCompleted(
        string sceneName,
        LoadSceneMode loadSceneMode,
        List<ulong> clientsCompleted,
        List<ulong> clientsTimedOut)
    {
        Debug.Log($"[PlayerSpawnManager] Scene load completed: {sceneName}");
        Debug.Log($"[PlayerSpawnManager] Clients completed: {clientsCompleted.Count}");
        Debug.Log($"[PlayerSpawnManager] Clients timed out: {clientsTimedOut.Count}");

        if (sceneName == gameSceneName && !_hasInitialized)
        {
            StartCoroutine(WaitAndInitialize());
        }
    }

    private IEnumerator WaitAndInitialize()
    {
        yield return new WaitForSeconds(0.2f);

        Debug.Log("[PlayerSpawnManager] Initializing after scene load");
        InitializeSpawning();
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

        foreach (var client in NetworkManager.Singleton.ConnectedClientsList)
        {
            Debug.Log($"[PlayerSpawnManager] Checking client {client.ClientId}");

            if (client.PlayerObject != null)
            {
                Debug.Log($"[PlayerSpawnManager] Client {client.ClientId} already has PlayerObject");
                continue;
            }

            if (_spawnedPlayers.Contains(client.ClientId))
            {
                Debug.Log($"[PlayerSpawnManager] Client {client.ClientId} already spawned");
                continue;
            }

            StartCoroutine(SpawnPlayerRoutine(client.ClientId));
        }
    }

    private void HandleClientConnected(ulong clientId)
    {
        Debug.Log($"[PlayerSpawnManager] Client connected: {clientId}");

        if (!_hasInitialized)
        {
            Debug.Log("[PlayerSpawnManager] Not initialized yet, skipping spawn");
            return;
        }

        if (SceneManager.GetActiveScene().name != gameSceneName)
        {
            Debug.Log("[PlayerSpawnManager] Not in GameScene, skipping spawn");
            return;
        }

        if (_spawnedPlayers.Contains(clientId))
        {
            Debug.Log($"[PlayerSpawnManager] Client {clientId} already spawned");
            return;
        }

        StartCoroutine(SpawnPlayerRoutine(clientId));
    }

    private IEnumerator SpawnPlayerRoutine(ulong clientId)
    {
        Debug.Log($"[PlayerSpawnManager] Starting spawn routine for client {clientId}");

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

        if (!NetworkManager.Singleton.ConnectedClients.TryGetValue(clientId, out var client))
        {
            Debug.LogWarning($"[PlayerSpawnManager] Client {clientId} not found");
            yield break;
        }

        if (client.PlayerObject != null)
        {
            Debug.Log($"[PlayerSpawnManager] Client {clientId} already has PlayerObject, skipping");
            yield break;
        }

        if (_spawnedPlayers.Contains(clientId))
        {
            Debug.Log($"[PlayerSpawnManager] Client {clientId} already in spawned list");
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

        Vector3 spawnPosition = spawnPoint.position;
        Quaternion spawnRotation = spawnPoint.rotation;

        Debug.Log($"[PlayerSpawnManager] Spawning player {clientId} at {spawnPosition}");

        GameObject playerInstance = Instantiate(playerPrefab, spawnPosition, spawnRotation);

        NetworkObject netObj = playerInstance.GetComponent<NetworkObject>();
        if (netObj == null)
        {
            Debug.LogError("[PlayerSpawnManager] NetworkObject not found on player prefab!");
            Destroy(playerInstance);
            yield break;
        }

        netObj.SpawnAsPlayerObject(clientId, true);
        _spawnedPlayers.Add(clientId);

        yield return new WaitForSeconds(0.1f);

        SetPlayerPositionClientRpc(clientId, spawnPosition, spawnRotation);

        Debug.Log($"[PlayerSpawnManager] Player {clientId} spawned successfully");
    }

    [ClientRpc]
    private void SetPlayerPositionClientRpc(ulong clientId, Vector3 position, Quaternion rotation)
    {
        if (NetworkManager.Singleton.LocalClientId != clientId) return;

        var playerObject = NetworkManager.Singleton.LocalClient.PlayerObject;
        if (playerObject == null)
        {
            Debug.LogWarning("[PlayerSpawnManager] PlayerObject not found for position set");
            return;
        }

        StartCoroutine(ForcePositionRoutine(playerObject.gameObject, position, rotation));
    }

    private IEnumerator ForcePositionRoutine(GameObject player, Vector3 position, Quaternion rotation)
    {
        var controller = player.GetComponent<CharacterController>();
        var networkTransform = player.GetComponent<ClientNetworkTransform>();

        if (controller != null)
            controller.enabled = false;

        yield return null;

        player.transform.position = position;
        player.transform.rotation = rotation;

        if (networkTransform != null)
        {
            networkTransform.Teleport(position, rotation, player.transform.localScale);
        }

        yield return null;

        if (controller != null)
        {
            player.transform.position = position;
            controller.enabled = true;
        }

        Debug.Log($"[PlayerSpawnManager] Position set to: {player.transform.position}");
    }
}