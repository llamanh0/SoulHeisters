using Unity.Netcode;
using UnityEngine;

/// <summary>
/// Uygulama seviyesinde network baslangic ve baglanti yonetimi.
/// 
/// Sorumluluklar:
/// - Singleton olarak uygulama boyunca yasamak
/// - Host / Client / Server baslatma fonksiyonlari saglamak
/// - NetworkManager event'lerini dinleyip loglamak
/// - Baslangicta kullanilan debug UI canvas'ini ac/kapa yapmak
/// </summary>
public class AppNetManager : MonoBehaviour
{
    [SerializeField] private GameObject DebugCanvas;

    [Header("Scenes")]
    [SerializeField] private string gameSceneName = "GameScene";

    /// <summary>
    /// Uygulama seviyesinde tekil instance.
    /// </summary>
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
    }

    private void OnEnable()
    {
        if (NetworkManager.Singleton != null)
        {
            // Yeni bir client baglandiginda veya koptugunda event'leri dinle
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

    /// <summary>
    /// Herhangi bir client baglandiginda NetworkManager tarafindan cagrilir.
    /// </summary>
    private void HandleClientConnected(ulong clientId)
    {
        Debug.Log($"[AppNetManager] Connected Player => ID: {clientId}");

        // Eger baglanan oyuncu local client ise, basari mesajini yazdir
        if (clientId == NetworkManager.Singleton.LocalClientId)
        {
            Debug.Log("[AppNetManager] You Connected Successfully!");
        }
    }

    /// <summary>
    /// Herhangi bir client baglantiyi kestiginde NetworkManager tarafindan cagrilir.
    /// </summary>
    private void HandleClientDisconnected(ulong clientId)
    {
        Debug.Log($"[AppNetManager] Disconnected Player => ID: {clientId}");

        if (clientId == NetworkManager.Singleton.LocalClientId)
        {
            Debug.Log("[AppNetManager] You Disconnected Successfully!");

            // TODO: Burada ana menuye donus gibi islemler eklenebilir.
        }
    }

    // ───────────────────── Public API ─────────────────────

    /// <summary>
    /// Hem server'i hem de local client'i baslatir.
    /// Genellikle oyun sahibinin kullandigi mod.
    /// </summary>
    public void StartHost()
    {
        Debug.Log("[AppNetManager] Host is being started.");
        if (NetworkManager.Singleton.StartHost())
        {
            if (DebugCanvas != null)
                DebugCanvas.SetActive(false);

            // Host basarili basladiysa oyun sahnesini network uzerinden yukle
            if (!string.IsNullOrEmpty(gameSceneName))
            {
                NetworkManager.Singleton.SceneManager.LoadScene(
                    gameSceneName, UnityEngine.SceneManagement.LoadSceneMode.Single);
            }
        }
        else
        {
            Debug.LogError("[AppNetManager] Failed to start Host.");
        }
    }

    /// <summary>
    /// Sadece client olarak baglanir, server baska bir makinede calisir.
    /// </summary>
    public void StartClient()
    {
        Debug.Log("[AppNetManager] Client is being started.");
        if (NetworkManager.Singleton.StartClient())
        {
            if (DebugCanvas != null)
                DebugCanvas.SetActive(false);
            // Client icin sahne gecisini server tarafindaki SceneManager yonetecek
        }
        else
        {
            Debug.LogError("[AppNetManager] Failed to start Client.");
        }
    }

    /// <summary>
    /// (Opsiyonel) Sadece server modunda calistirmak icin kullanilabilir.
    /// </summary>
    public void StartServer()
    {
        Debug.Log("[AppNetManager] Server is being started.");
        NetworkManager.Singleton.StartServer();
        if (DebugCanvas != null)
            DebugCanvas.SetActive(false);
    }
}