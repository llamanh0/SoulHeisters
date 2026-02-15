using Unity.Netcode;
using UnityEngine;

public class AppNetManager : MonoBehaviour
{
    public static AppNetManager Instance { get;  private set; }

    private void Awake()
    {
        if (Instance != null && Instance != this)
        {
            Destroy(gameObject);
            return;
        }
        Instance = this;
        DontDestroyOnLoad(gameObject);
    }

    private void OnEnable()
    {
        if(NetworkManager.Singleton != null)
        {
            NetworkManager.Singleton.OnClientConnectedCallback += HandleClientConnected;
            NetworkManager.Singleton.OnClientDisconnectCallback += HandleClientDisconnected;
        }
    }

    private void OnDisable()
    {
        if (NetworkManager.Singleton != null)
        {
            NetworkManager.Singleton.OnClientConnectedCallback -= HandleClientConnected;
            NetworkManager.Singleton.OnClientDisconnectCallback -= HandleClientDisconnected;
        }
    }

    private void HandleClientConnected(ulong clientId)
    {
        Debug.Log($"[AppNetManager] Connected Player => ID: {clientId}");

        // If connected player is the LocalPlayer => Success
        if (clientId == NetworkManager.Singleton.LocalClientId) 
        { 
            Debug.Log("[AppNetManager] You Connected Successfully!");
        }
    }

    private void HandleClientDisconnected(ulong clientId)
    {
        Debug.Log($"[AppNetManager] Disconnected Player => ID: {clientId}");

        if (clientId == NetworkManager.Singleton.LocalClientId)
        {
            Debug.Log("[AppNetManager] You Disconnected Successfully!");

            // WILL ADD: Return to Main Menu
        }
    }

    // Connection Functions
    public void StartHost()
    {
        Debug.Log("Host is being start.");
        NetworkManager.Singleton.StartHost();
    }

    public void StartClient()
    {
        Debug.Log("Client is being start.");
        NetworkManager.Singleton.StartClient();
    }
}
