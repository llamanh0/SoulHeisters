using Unity.Netcode;
using UnityEngine;

public class AppNetManager : MonoBehaviour
{
    [Header("Scenes")]
    [SerializeField] private string lobbySceneName = "LobbyScene";
    //[SerializeField] private string gameSceneName = "GameScene";

    public static AppNetManager Instance { get; private set; }

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
        {
            SetupNetworkCallbacks();
        }
    }

    private void OnDisable()
    {
        if (NetworkManager.Singleton != null)
        {
            CleanupNetworkCallbacks();
        }
    }

    private void SetupNetworkCallbacks()
    {
        NetworkManager.Singleton.OnServerStarted += HandleServerStarted;
        NetworkManager.Singleton.OnClientConnectedCallback += HandleClientConnected;
        NetworkManager.Singleton.OnClientDisconnectCallback += HandleClientDisconnected;
        
        // SCENE EVENT'LERINI DINLE - COK ONEMLI!
        NetworkManager.Singleton.SceneManager.OnSceneEvent += HandleSceneEvent;
    }

    private void CleanupNetworkCallbacks()
    {
        NetworkManager.Singleton.OnServerStarted -= HandleServerStarted;
        NetworkManager.Singleton.OnClientConnectedCallback -= HandleClientConnected;
        NetworkManager.Singleton.OnClientDisconnectCallback -= HandleClientDisconnected;
        NetworkManager.Singleton.SceneManager.OnSceneEvent -= HandleSceneEvent;
    }

    #region Scene Event Handling

    private void HandleSceneEvent(SceneEvent sceneEvent)
    {
        if (sceneEvent.SceneEventType == SceneEventType.Load)
        {
            Debug.Log($"[AppNetManager] Scene loading: {sceneEvent.SceneName}");
        
            // YENİ SCENE YUKLENMEDEN ONCE TUM COROUTINE'LERI DURDUR
            StopAllCoroutinesInScene();
        
            // Player cleanup
            CleanupPlayerObjectsBeforeSceneChange();
        }
        else if (sceneEvent.SceneEventType == SceneEventType.LoadComplete)
        {
            Debug.Log($"[AppNetManager] Scene loaded: {sceneEvent.SceneName}");
        }
    }

    private void StopAllCoroutinesInScene()
    {
        // Tum MonoBehaviour'lardaki coroutine'leri durdur
        var allMonoBehaviours = FindObjectsOfType<MonoBehaviour>();
    
        foreach (var mb in allMonoBehaviours)
        {
            if (mb != null && mb.gameObject != null)
            {
                mb.StopAllCoroutines();
            }
        }
    
        Debug.Log($"[AppNetManager] Stopped coroutines in {allMonoBehaviours.Length} MonoBehaviours");
    }

    private void CleanupPlayerObjectsBeforeSceneChange()
    {
        // SADECE SERVER/HOST'TA CALIS
        if (!NetworkManager.Singleton.IsServer)
        {
            Debug.Log("[AppNetManager] Not server, skipping player cleanup");
            return;
        }

        Debug.Log("[AppNetManager] Cleaning up player objects before scene change");

        int cleanedCount = 0;

        foreach (var client in NetworkManager.Singleton.ConnectedClientsList)
        {
            if (client.PlayerObject != null)
            {
                var playerObj = client.PlayerObject;
                
                if (playerObj != null && playerObj.gameObject != null && playerObj.IsSpawned)
                {
                    Debug.Log($"[AppNetManager] Despawning player object for client {client.ClientId}");
                    playerObj.Despawn(false); // false = destroy etme, sadece despawn
                    cleanedCount++;
                }
            }
        }

        Debug.Log($"[AppNetManager] Cleaned {cleanedCount} player objects");
    }

    #endregion

    #region Connection Callbacks

    private void HandleServerStarted()
    {
        Debug.Log("[AppNetManager] Server started");
    }

    private void HandleClientConnected(ulong clientId)
    {
        Debug.Log($"[AppNetManager] Player connected => ID: {clientId}");

        if (clientId == NetworkManager.Singleton.LocalClientId)
        {
            Debug.Log("[AppNetManager] You connected successfully!");
        }
    }

    private void HandleClientDisconnected(ulong clientId)
    {
        Debug.Log($"[AppNetManager] Player disconnected => ID: {clientId}");

        if (clientId == NetworkManager.Singleton.LocalClientId)
        {
            Debug.Log("[AppNetManager] You disconnected!");
        }
    }

    #endregion

    #region Start Methods

    public void StartHost()
    {
        Debug.Log("[AppNetManager] Starting Host...");

        if (NetworkManager.Singleton.StartHost())
        {
            Debug.Log("[AppNetManager] Host started successfully");

            if (!string.IsNullOrEmpty(lobbySceneName))
            {
                NetworkManager.Singleton.SceneManager.LoadScene(
                    lobbySceneName, 
                    UnityEngine.SceneManagement.LoadSceneMode.Single);
            }
        }
        else
        {
            Debug.LogError("[AppNetManager] Failed to start Host!");
        }
    }

    public void StartClient()
    {
        Debug.Log("[AppNetManager] Starting Client...");

        var transport = NetworkManager.Singleton.GetComponent<Unity.Netcode.Transports.UTP.UnityTransport>();
        if (transport != null)
        {
            transport.ConnectionData.Address = "127.0.0.1";
            transport.ConnectionData.Port = 7777;
        }

        if (NetworkManager.Singleton.StartClient())
        {
            Debug.Log("[AppNetManager] Client started successfully");
        }
        else
        {
            Debug.LogError("[AppNetManager] Failed to start Client!");
        }
    }

    public void StartServer()
    {
        Debug.Log("[AppNetManager] Starting Server...");
        NetworkManager.Singleton.StartServer();
    }

    #endregion
}