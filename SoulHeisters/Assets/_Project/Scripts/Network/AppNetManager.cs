using System;
using System.Collections;
using Unity.Netcode;
using UnityEngine;

public class AppNetManager : MonoBehaviour
{
    [Header("Scenes")]
    [SerializeField] private string lobbySceneName = "LobbyScene";

    [Header("Connection")]
    [SerializeField] private float connectionTimeout = 10f;

    public static AppNetManager Instance { get; private set; }

    public event Action OnRelayReady;
    public event Action<string> OnRelayError;
    public bool IsReady { get; private set; }

    private Coroutine _timeoutCoroutine;

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

        if (_timeoutCoroutine != null)
            StopCoroutine(_timeoutCoroutine);
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

        _timeoutCoroutine = StartCoroutine(ConnectionTimeoutRoutine("Host creation"));

        try
        {
            await RelayManager.Instance.InitializeAsync();
            string joinCode = await RelayManager.Instance.CreateRelayAndGetJoinCode();

            if (NetworkManager.Singleton.StartHost())
            {
                Debug.Log("[AppNetManager] Host started successfully");
                IsReady = true;

                if (_timeoutCoroutine != null)
                {
                    StopCoroutine(_timeoutCoroutine);
                    _timeoutCoroutine = null;
                }

                OnRelayReady?.Invoke();

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

            if (_timeoutCoroutine != null)
            {
                StopCoroutine(_timeoutCoroutine);
                _timeoutCoroutine = null;
            }

            OnRelayError?.Invoke(e.Message);
        }
    }

    public async void StartClient(string joinCode)
    {
        Debug.Log($"[AppNetManager] Starting Client with code: {joinCode}");
        IsReady = false;

        _timeoutCoroutine = StartCoroutine(ConnectionTimeoutRoutine("Connection"));

        try
        {
            await RelayManager.Instance.InitializeAsync();
            await RelayManager.Instance.JoinRelayWithCode(joinCode);

            if (NetworkManager.Singleton.StartClient())
            {
                Debug.Log("[AppNetManager] Client started successfully");
                IsReady = true;

                if (_timeoutCoroutine != null)
                {
                    StopCoroutine(_timeoutCoroutine);
                    _timeoutCoroutine = null;
                }

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

            if (_timeoutCoroutine != null)
            {
                StopCoroutine(_timeoutCoroutine);
                _timeoutCoroutine = null;
            }

            OnRelayError?.Invoke(e.Message);
        }
    }

    private IEnumerator ConnectionTimeoutRoutine(string operation)
    {
        yield return new WaitForSeconds(connectionTimeout);

        Debug.LogWarning($"[AppNetManager] {operation} timeout");
        OnRelayError?.Invoke($"{operation} timed out");

        if (NetworkManager.Singleton != null)
            NetworkManager.Singleton.Shutdown();
    }

    public void StartServer()
    {
        Debug.Log("[AppNetManager] Starting Server...");
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