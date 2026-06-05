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
        NetworkManager.Singleton.OnClientDisconnectCallback += HandleClientDisconnected;
    }

    private void CleanupNetworkCallbacks()
    {
        NetworkManager.Singleton.OnClientDisconnectCallback -= HandleClientDisconnected;
    }

    public async void StartHost()
    {
        IsReady = false;

        try
        {
            await RelayManager.Instance.InitializeAsync();
            string joinCode = await RelayManager.Instance.CreateRelayAndGetJoinCode();

            if (NetworkManager.Singleton.StartHost())
            {
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
            OnRelayError?.Invoke(e.Message);
        }
    }

    private void SpawnPlayerNameRegistry()
    {
        if (!NetworkManager.Singleton.IsServer) return;

        if (PlayerNameRegistry.Instance != null)
        {
            return;
        }

        if (playerNameRegistryPrefab == null)
        {
            return;
        }

        GameObject instance = Instantiate(playerNameRegistryPrefab);
        var netObj = instance.GetComponent<NetworkObject>();

        if (netObj != null)
        {
            netObj.Spawn();
        }
        else
        {
            Destroy(instance);
        }
    }

    public async void StartClient(string joinCode)
    {
        IsReady = false;

        try
        {
            await RelayManager.Instance.InitializeAsync();
            await RelayManager.Instance.JoinRelayWithCode(joinCode);

            if (NetworkManager.Singleton.StartClient())
            {
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
            OnRelayError?.Invoke(e.Message);
        }
    }

    public void StartServer()
    {
        NetworkManager.Singleton.StartServer();
    }

    private void HandleClientDisconnected(ulong clientId)
    {

        if (clientId == NetworkManager.Singleton.LocalClientId)
        {
            UnityEngine.SceneManagement.SceneManager.LoadScene("MenuScene");
        }
    }
}