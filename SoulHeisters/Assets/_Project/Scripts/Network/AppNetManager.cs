using System;
using System.Collections;
using Unity.Netcode;
using UnityEngine;

public class AppNetManager : MonoBehaviour
{
    [Header("Scenes")]
    [SerializeField] private string lobbySceneName = "LobbyScene";

    [Header("Network Prefabs")]
    [SerializeField] private GameObject playerNameRegistryPrefab;

    public static AppNetManager Instance { get; private set; }

    public event Action OnRelayReady;
    public event Action<string> OnRelayError;
    public bool IsReady { get; private set; }

    private void Awake()
    {
        if (Instance != null && Instance != this)
        {
            Destroy(gameObject);
            return;
        }
        Instance = this;
        DontDestroyOnLoad(gameObject);
        Application.runInBackground = true;
        QualitySettings.vSyncCount = 0;
        Application.targetFrameRate = 60;
    }

    private void OnEnable()
    {
        if (NetworkManager.Singleton != null)
            SetupNetworkCallbacks();
    }

    private void OnDisable()
    {
        if (NetworkManager.Singleton != null)
            CleanupNetworkCallbacks();
    }

    private void SetupNetworkCallbacks()
    {
        NetworkManager.Singleton.OnServerStarted += HandleServerStarted;
        NetworkManager.Singleton.OnClientConnectedCallback += HandleClientConnected;
        NetworkManager.Singleton.OnClientDisconnectCallback += HandleClientDisconnected;
        NetworkManager.Singleton.SceneManager.OnSceneEvent += HandleSceneEvent;
    }

    private void CleanupNetworkCallbacks()
    {
        NetworkManager.Singleton.OnServerStarted -= HandleServerStarted;
        NetworkManager.Singleton.OnClientConnectedCallback -= HandleClientConnected;
        NetworkManager.Singleton.OnClientDisconnectCallback -= HandleClientDisconnected;

        if (NetworkManager.Singleton.SceneManager != null)
            NetworkManager.Singleton.SceneManager.OnSceneEvent -= HandleSceneEvent;
    }

    public async void StartHost()
    {
        Debug.Log("[AppNetManager] Starting Host...");
        IsReady = false;

        try
        {
            await RelayManager.Instance.InitializeAsync();
            string joinCode = await RelayManager.Instance.CreateRelayAndGetJoinCode();

            if (NetworkManager.Singleton.StartHost())
            {
                Debug.Log("[AppNetManager] Host started successfully");
                IsReady = true;
                OnRelayReady?.Invoke();

                SpawnPlayerNameRegistry();

                if (!string.IsNullOrEmpty(lobbySceneName))
                {
                    NetworkManager.Singleton.SceneManager.LoadScene(
                        lobbySceneName,
                        UnityEngine.SceneManagement.LoadSceneMode.Single);
                }
            }
            else
            {
                throw new Exception("NetworkManager.StartHost() returned false");
            }
        }
        catch (Exception e)
        {
            Debug.LogError($"[AppNetManager] StartHost failed: {e.Message}");
            OnRelayError?.Invoke(e.Message);
        }
    }

    private void SpawnPlayerNameRegistry()
    {
        if (!NetworkManager.Singleton.IsServer) return;

        if (PlayerNameRegistry.Instance != null)
        {
            Debug.Log("[AppNetManager] PlayerNameRegistry already exists");
            return;
        }

        if (playerNameRegistryPrefab == null)
        {
            Debug.LogError("[AppNetManager] PlayerNameRegistry prefab is null!");
            return;
        }

        GameObject instance = Instantiate(playerNameRegistryPrefab);
        var netObj = instance.GetComponent<NetworkObject>();

        if (netObj != null)
        {
            netObj.Spawn();
            Debug.Log("[AppNetManager] PlayerNameRegistry spawned");
        }
        else
        {
            Debug.LogError("[AppNetManager] No NetworkObject on PlayerNameRegistry prefab!");
            Destroy(instance);
        }
    }

    public async void StartClient(string joinCode)
    {
        Debug.Log($"[AppNetManager] Starting Client with code: {joinCode}");
        IsReady = false;

        try
        {
            await RelayManager.Instance.InitializeAsync();
            await RelayManager.Instance.JoinRelayWithCode(joinCode);

            if (NetworkManager.Singleton.StartClient())
            {
                Debug.Log("[AppNetManager] Client started successfully");
                IsReady = true;
                OnRelayReady?.Invoke();
            }
            else
            {
                throw new Exception("NetworkManager.StartClient() returned false");
            }
        }
        catch (Exception e)
        {
            Debug.LogError($"[AppNetManager] StartClient failed: {e.Message}");
            OnRelayError?.Invoke(e.Message);
        }
    }

    public void StartServer()
    {
        NetworkManager.Singleton.StartServer();
    }

    private void HandleSceneEvent(SceneEvent sceneEvent)
    {
        switch (sceneEvent.SceneEventType)
        {
            case SceneEventType.Load:
                Debug.Log($"[AppNetManager] Scene loading: {sceneEvent.SceneName}");
                break;
            case SceneEventType.LoadComplete:
                Debug.Log($"[AppNetManager] Scene loaded: {sceneEvent.SceneName}");
                break;
            case SceneEventType.UnloadComplete:
                Debug.Log($"[AppNetManager] Scene unloaded: {sceneEvent.SceneName}");
                break;
        }
    }

    private void HandleServerStarted()
    {
        Debug.Log("[AppNetManager] Server started");
    }

    private void HandleClientConnected(ulong clientId)
    {
        Debug.Log($"[AppNetManager] Client connected: {clientId}");
    }

    private void HandleClientDisconnected(ulong clientId)
    {
        Debug.Log($"[AppNetManager] Client disconnected: {clientId}");

        if (clientId == NetworkManager.Singleton.LocalClientId)
        {
            Debug.Log("[AppNetManager] Local client disconnected, returning to menu");
            UnityEngine.SceneManagement.SceneManager.LoadScene("MenuScene");
        }
    }
}