using System.Collections;
using System.Collections.Generic;
using Unity.Netcode;
using UnityEngine;

/// <summary>
/// Lobi sistemini yoneten ana sinif
/// Oyuncu ekleme/cikarma, hazir durumu, oyun baslat
/// </summary>
public class LobbyManager : NetworkBehaviour
{
    public static LobbyManager Instance { get; private set; }

    [Header("Settings")]
    [SerializeField] private int minPlayersToStart = 1;
    [SerializeField] private int maxPlayers = 8;
    [SerializeField] private string gameSceneName = "GameScene";

    [Header("UI")]
    [SerializeField] private LobbyUI lobbyUI;

    private NetworkList<PlayerLobbyData> _playersInLobby;
    private string _lobbyCode = "";

    #region Unity Lifecycle

    private void Awake()
    {
        if (Instance != null && Instance != this)
        {
            Destroy(gameObject);
            return;
        }
        Instance = this;

        _playersInLobby = new NetworkList<PlayerLobbyData>();
    }

    public override void OnDestroy()
    {
        Debug.Log("[LobbyManager] OnDestroy - Cleaning up");
        
        // Tum coroutine'leri durdur
        StopAllCoroutines();
    }

    #endregion

    #region Network Spawn

    public override void OnNetworkSpawn()
    {
        Debug.Log("[LobbyManager] OnNetworkSpawn called");

        if (IsServer)
        {
            NetworkManager.Singleton.OnClientConnectedCallback += HandleClientConnected;
            NetworkManager.Singleton.OnClientDisconnectCallback += HandleClientDisconnected;

            // Lobi kodu olustur
            GenerateLobbyCode();

            // MEVCUT OYUNCULARI MANUEL EKLE (ÇOK ÖNEMLİ!)
            foreach (var client in NetworkManager.Singleton.ConnectedClientsList)
            {
                Debug.Log($"[LobbyManager] Adding existing client: {client.ClientId}");
            
                string playerName = $"Player{client.ClientId}";
                PlayerLobbyData newPlayer = new PlayerLobbyData(client.ClientId, playerName, false);
                _playersInLobby.Add(newPlayer);
            }

            Debug.Log($"[LobbyManager] Total players added: {_playersInLobby.Count}");
        }

        // Liste degisikliklerini dinle
        _playersInLobby.OnListChanged += HandleLobbyListChanged;

        // UI'i guncelle
        if (lobbyUI != null)
        {
            lobbyUI.SetLobbyCode(_lobbyCode);

            // Mevcut oyunculari UI'a yukle
            Debug.Log($"[LobbyManager] Loading {_playersInLobby.Count} players to UI");
            foreach (var player in _playersInLobby)
            {
                Debug.Log($"[LobbyManager] Adding player card to UI: {player.playerName}");
                lobbyUI.AddPlayerCard(player);
            }
        }
        else
        {
            Debug.LogError("[LobbyManager] LobbyUI is NULL!");
        }
    }

    public override void OnNetworkDespawn()
    {
        if (IsServer && NetworkManager.Singleton != null)
        {
            NetworkManager.Singleton.OnClientConnectedCallback -= HandleClientConnected;
            NetworkManager.Singleton.OnClientDisconnectCallback -= HandleClientDisconnected;
        }

        if (_playersInLobby != null)
        {
            _playersInLobby.OnListChanged -= HandleLobbyListChanged;
        }
    }
    
    

    #endregion

    #region Server - Client Management

    private void HandleClientConnected(ulong clientId)
    {
        if (!IsServer) return;

        Debug.Log($"[LobbyManager] Client connected: {clientId}");

        // Varsayilan isim
        string playerName = $"Player{clientId}";

        PlayerLobbyData newPlayer = new PlayerLobbyData(clientId, playerName, false);
        _playersInLobby.Add(newPlayer);

        Debug.Log($"[LobbyManager] Added player to lobby: {playerName} (Total: {_playersInLobby.Count})");

        // Lobi kodunu cliente gonder
        SendLobbyCodeClientRpc(_lobbyCode, clientId);
    }

    private void HandleClientDisconnected(ulong clientId)
    {
        if (!IsServer) return;

        Debug.Log($"[LobbyManager] Client disconnected: {clientId}");

        // Host ayrildi mi?
        bool wasHost = clientId == 0;

        for (int i = _playersInLobby.Count - 1; i >= 0; i--)
        {
            if (_playersInLobby[i].clientId == clientId)
            {
                _playersInLobby.RemoveAt(i);
                Debug.Log($"[LobbyManager] Removed player (Remaining: {_playersInLobby.Count})");
                break;
            }
        }

        // Host ayrildi, herkesi at
        if (wasHost)
        {
            Debug.Log("[LobbyManager] Host left, closing lobby");
            CloseLobbyServerRpc();
        }
    }

    [ServerRpc(RequireOwnership = false)]
    private void CloseLobbyServerRpc()
    {
        NotifyLobbyClosedClientRpc();
    
        // Biraz bekle ki client mesaji alsın
        StartCoroutine(ShutdownAfterDelay(1f));
    }

    [ClientRpc]
    private void NotifyLobbyClosedClientRpc()
    {
        Debug.Log("[LobbyManager] Lobby closed by host");
    
        // TODO: UI ile bildir
    }

    private IEnumerator ShutdownAfterDelay(float delay)
    {
        yield return new WaitForSeconds(delay);
        NetworkManager.Singleton.Shutdown();
    }

    #endregion

    #region Lobby Code

    private void GenerateLobbyCode()
    {
        // Basit 6 karakterlik kod
        const string chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
        System.Text.StringBuilder code = new System.Text.StringBuilder();

        for (int i = 0; i < 6; i++)
        {
            code.Append(chars[Random.Range(0, chars.Length)]);
        }

        _lobbyCode = code.ToString();
        Debug.Log($"[LobbyManager] Generated lobby code: {_lobbyCode}");
    }

    [ClientRpc]
    private void SendLobbyCodeClientRpc(string code, ulong targetClientId)
    {
        if (NetworkManager.Singleton.LocalClientId != targetClientId)
            return;

        _lobbyCode = code;

        if (lobbyUI != null)
        {
            lobbyUI.SetLobbyCode(code);
        }

        Debug.Log($"[LobbyManager] Received lobby code: {code}");
    }

    #endregion

    #region List Change Handler

    private void HandleLobbyListChanged(NetworkListEvent<PlayerLobbyData> changeEvent)
    {
        Debug.Log($"[LobbyManager] List changed - Type: {changeEvent.Type}");

        if (lobbyUI == null)
        {
            Debug.LogError("[LobbyManager] LobbyUI is null!");
            return;
        }

        switch (changeEvent.Type)
        {
            case NetworkListEvent<PlayerLobbyData>.EventType.Add:
                Debug.Log($"[LobbyManager] Adding player card: {changeEvent.Value.playerName}");
                lobbyUI.AddPlayerCard(changeEvent.Value);
                break;

            case NetworkListEvent<PlayerLobbyData>.EventType.Remove:
                Debug.Log($"[LobbyManager] Removing player card: {changeEvent.Value.clientId}");
                lobbyUI.RemovePlayerCard(changeEvent.Value.clientId);
                break;

            case NetworkListEvent<PlayerLobbyData>.EventType.Value:
                Debug.Log($"[LobbyManager] Updating player card: {changeEvent.Value.playerName}");
                lobbyUI.UpdatePlayerCard(changeEvent.Value);
                break;
        }

        UpdateStartButtonState();
    }

    #endregion

    #region Ready System

    [ServerRpc(RequireOwnership = false)]
    public void SetPlayerReadyServerRpc(ulong clientId, bool isReady)
    {
        Debug.Log($"[LobbyManager] SetPlayerReady - Client: {clientId}, Ready: {isReady}");

        for (int i = 0; i < _playersInLobby.Count; i++)
        {
            if (_playersInLobby[i].clientId == clientId)
            {
                PlayerLobbyData data = _playersInLobby[i];
                data.isReady = isReady;
                _playersInLobby[i] = data;

                Debug.Log($"[LobbyManager] Player {data.playerName} ready state: {isReady}");
                break;
            }
        }
    }

    [ServerRpc(RequireOwnership = false)]
    public void SetPlayerNameServerRpc(ulong clientId, string newName)
    {
        Debug.Log($"[LobbyManager] SetPlayerName - Client: {clientId}, Name: {newName}");

        for (int i = 0; i < _playersInLobby.Count; i++)
        {
            if (_playersInLobby[i].clientId == clientId)
            {
                PlayerLobbyData data = _playersInLobby[i];
                data.playerName = newName;
                _playersInLobby[i] = data;

                Debug.Log($"[LobbyManager] Player name updated to: {newName}");
                break;
            }
        }
    }

    #endregion

    #region Start Game

    public void TryStartGame()
    {
        Debug.Log("[LobbyManager] TryStartGame called");

        if (!IsServer)
        {
            RequestStartGameServerRpc();
            return;
        }

        if (!CanStartGame(out string reason))
        {
            Debug.LogWarning($"[LobbyManager] Cannot start: {reason}");
            
            // UI'de bildirim goster
            ShowCannotStartNotificationClientRpc(reason);
            return;
        }

        Debug.Log("[LobbyManager] Starting game...");
        StartGameServerRpc();
    }

    [ServerRpc(RequireOwnership = false)]
    private void RequestStartGameServerRpc()
    {
        if (CanStartGame(out string reason))
            StartGameServerRpc();
        else
            ShowCannotStartNotificationClientRpc(reason);
    }

    [ServerRpc(RequireOwnership = false)]
    private void StartGameServerRpc()
    {
        Debug.Log($"[LobbyManager] Starting game - Loading {gameSceneName}");

        // UI'de loading goster
        ShowLoadingPanelClientRpc();

        // SADECE SCENE YUKLE
        // AppNetManager otomatik olarak cleanup yapacak
        StartCoroutine(LoadGameSceneWithDelay());
    }

    private IEnumerator LoadGameSceneWithDelay()
    {
        yield return new WaitForSeconds(0.5f);

        Debug.Log($"[LobbyManager] Loading scene: {gameSceneName}");

        NetworkManager.Singleton.SceneManager.LoadScene(
            gameSceneName,
            UnityEngine.SceneManagement.LoadSceneMode.Single
        );
    }

    [ClientRpc]
    private void ShowLoadingPanelClientRpc()
    {
        if (lobbyUI != null)
        {
            lobbyUI.ShowLoadingPanel(true);
        }
    }

    [ClientRpc]
    private void ShowCannotStartNotificationClientRpc(string reason)
    {
        Debug.Log($"[LobbyManager] Cannot start: {reason}");
        
        // TODO: UI Toast notification
        // Simdilik sadece log
    }

    private bool CanStartGame(out string reason)
    {
        int playerCount = _playersInLobby.Count;

        // Minimum oyuncu kontrolu
        if (playerCount < minPlayersToStart)
        {
            reason = $"En az {minPlayersToStart} oyuncu gerekli (Suanda: {playerCount})";
            return false;
        }

        // Tum oyuncular hazir mi kontrol et (opsiyonel - kapat istersen)
        int readyCount = 0;
        foreach (var player in _playersInLobby)
        {
            if (player.isReady)
                readyCount++;
        }
        
        if (readyCount < playerCount)
        {
            reason = $"Tum oyuncular hazir olmali ({readyCount}/{playerCount})";
            return false;
        }

        reason = "";
        return true;
    }

    private void UpdateStartButtonState()
    {
        if (lobbyUI == null) return;

        bool canStart = IsServer && CanStartGame(out _);
        lobbyUI.SetStartButtonInteractable(canStart);
    }

    #endregion

    #region Public Getters

    public int GetPlayerCount() => _playersInLobby.Count;

    public bool IsLobbyFull() => _playersInLobby.Count >= maxPlayers;

    #endregion
}