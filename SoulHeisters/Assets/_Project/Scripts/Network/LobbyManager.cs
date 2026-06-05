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
        StopAllCoroutines();
    }

    #endregion

    #region Network Spawn

    public override void OnNetworkSpawn()
    {

        if (IsServer)
        {
            NetworkManager.Singleton.OnClientConnectedCallback += HandleClientConnected;
            NetworkManager.Singleton.OnClientDisconnectCallback += HandleClientDisconnected;

            WaitForRelayCode();

            foreach (var client in NetworkManager.Singleton.ConnectedClientsList)
            {
                string playerName = $"Player{client.ClientId}";
                PlayerLobbyData newPlayer = new PlayerLobbyData(client.ClientId, playerName, false);
                _playersInLobby.Add(newPlayer);
            }
        }

        _playersInLobby.OnListChanged += HandleLobbyListChanged;

        if (lobbyUI != null)
        {
            lobbyUI.SetLobbyCode(_lobbyCode);
            foreach (var player in _playersInLobby)
            {
                lobbyUI.AddPlayerCard(player);
            }
        }
    }

    private async void WaitForRelayCode()
    {
        int attempts = 0;
        while (string.IsNullOrEmpty(RelayManager.Instance.CurrentJoinCode) && attempts < 50)
        {
            await System.Threading.Tasks.Task.Delay(100);
            attempts++;
        }

        GenerateLobbyCode();

        if (lobbyUI != null)
        {
            lobbyUI.SetLobbyCode(_lobbyCode);
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

        string playerName = $"Player{clientId}";
        PlayerLobbyData newPlayer = new PlayerLobbyData(clientId, playerName, false);
        _playersInLobby.Add(newPlayer);

        SendLobbyCodeClientRpc(_lobbyCode, clientId);
    }

    private void HandleClientDisconnected(ulong clientId)
    {
        if (!IsServer) return;

        bool wasHost = clientId == 0;

        for (int i = _playersInLobby.Count - 1; i >= 0; i--)
        {
            if (_playersInLobby[i].clientId == clientId)
            {
                _playersInLobby.RemoveAt(i);
                break;
            }
        }

        if (wasHost)
        {
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
        if (RelayManager.Instance != null && !string.IsNullOrEmpty(RelayManager.Instance.CurrentJoinCode))
        {
            _lobbyCode = RelayManager.Instance.CurrentJoinCode;
        }
        else
        {
            const string chars = "6789BCDFGHJKLMNPQRTW";
            System.Text.StringBuilder code = new System.Text.StringBuilder();
            for (int i = 0; i < 6; i++)
                code.Append(chars[Random.Range(0, chars.Length)]);
            _lobbyCode = code.ToString();
        }
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

    }

    #endregion

    #region List Change Handler

    private void HandleLobbyListChanged(NetworkListEvent<PlayerLobbyData> changeEvent)
    {

        if (lobbyUI == null)
        {
            return;
        }

        switch (changeEvent.Type)
        {
            case NetworkListEvent<PlayerLobbyData>.EventType.Add:
                lobbyUI.AddPlayerCard(changeEvent.Value);
                break;

            case NetworkListEvent<PlayerLobbyData>.EventType.Remove:
                lobbyUI.RemovePlayerCard(changeEvent.Value.clientId);
                break;

            case NetworkListEvent<PlayerLobbyData>.EventType.Value:
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
        for (int i = 0; i < _playersInLobby.Count; i++)
        {
            if (_playersInLobby[i].clientId == clientId)
            {
                PlayerLobbyData data = _playersInLobby[i];
                data.isReady = isReady;
                _playersInLobby[i] = data;
                break;
            }
        }
    }

    [ServerRpc(RequireOwnership = false)]
    public void SetPlayerNameServerRpc(ulong clientId, string newName)
    {
        for (int i = 0; i < _playersInLobby.Count; i++)
        {
            if (_playersInLobby[i].clientId == clientId)
            {
                PlayerLobbyData data = _playersInLobby[i];
                data.playerName = newName;
                _playersInLobby[i] = data;

                if (PlayerNameRegistry.Instance != null)
                {
                    PlayerNameRegistry.Instance.RegisterPlayerNameServerRpc(clientId, newName);
                }

                break;
            }
        }
    }

    #endregion

    #region Start Game

    public void TryStartGame()
    {
        if (!IsServer)
        {
            RequestStartGameServerRpc();
            return;
        }

        if (!CanStartGame(out string reason))
        {
            ShowCannotStartNotificationClientRpc(reason);
            return;
        }
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
        ShowLoadingPanelClientRpc();
        StartCoroutine(LoadGameSceneWithDelay());
    }

    private IEnumerator LoadGameSceneWithDelay()
    {
        yield return new WaitForSeconds(0.5f);

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
        // TODO: UI Toast notification
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