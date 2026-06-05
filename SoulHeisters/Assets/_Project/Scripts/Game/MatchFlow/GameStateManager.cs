using System;
using System.Collections;
using Unity.Netcode;
using UnityEngine;
using UnityEngine.SceneManagement;

public class GameStateManager : NetworkBehaviour
{
    public static GameStateManager Instance;

    private NetworkVariable<GameState> currentState = new(GameState.WaitingForPlayers);
    private NetworkVariable<float> _networkMatchStartTime = new(0f, NetworkVariableReadPermission.Everyone, NetworkVariableWritePermission.Server);
    private NetworkVariable<int> _countdownTimer = new(3, NetworkVariableReadPermission.Everyone, NetworkVariableWritePermission.Server);

    public GameState CurrentState => currentState.Value;
    public int CountdownTimer => _countdownTimer.Value;

    public Action OnMatchStarted;
    public Action OnMatchEnded;

    [SerializeField] private float matchDuration = 300f;
    [SerializeField] private float returnToLobbyDelay = 10f;
    [SerializeField] private string gameSceneName = "GameScene";
    [SerializeField] private string lobbySceneName = "LobbyScene";

    private float matchStartTime;
    private bool _gameStarted = false;

    private void Awake()
    {
        if (SceneManager.GetActiveScene().name != gameSceneName)
        {
            Destroy(gameObject);
            return;
        }

        if (Instance != null && Instance != this)
        {
            Destroy(gameObject);
            return;
        }
        Instance = this;
    }

    public override void OnNetworkSpawn()
    {
        if (SceneManager.GetActiveScene().name != gameSceneName) return;

        if (IsServer && !_gameStarted)
        {
            _gameStarted = true;
            StartCoroutine(GameLoop());
        }

        currentState.OnValueChanged += HandleStateChanged;
    }

    public override void OnNetworkDespawn()
    {
        currentState.OnValueChanged -= HandleStateChanged;
    }

    private void HandleStateChanged(GameState oldState, GameState newState)
    {
        if (newState == GameState.Playing)
            StartCoroutine(ForceEnableAllControllers());

        if (newState == GameState.MatchEnded)
            UnlockCursor();
    }

    private IEnumerator ForceEnableAllControllers()
    {
        yield return new WaitForSeconds(0.5f);
        foreach (var player in FindObjectsOfType<PlayerReferences>())
        {
            var c = player.GetComponent<CharacterController>();
            if (c != null && !c.enabled)
                c.enabled = true;
        }
    }

    private IEnumerator GameLoop()
    {
        yield return WaitForPlayers();
        yield return StartingPhase();
        yield return PlayingPhase();
        yield return MatchEndPhase();
    }

    private IEnumerator WaitForPlayers()
    {
        currentState.Value = GameState.WaitingForPlayers;
        yield return new WaitForSeconds(0.5f);
        while (!AreAllPlayersReady())
            yield return new WaitForSeconds(0.5f);
    }

    private bool AreAllPlayersReady()
    {
        if (NetworkManager.Singleton.ConnectedClients.Count == 0) return false;

        foreach (var client in NetworkManager.Singleton.ConnectedClientsList)
        {
            if (client.PlayerObject == null) return false;
            var r = client.PlayerObject.GetComponent<PlayerReadyState>();
            if (r == null || !r.IsReady) return false;
        }
        return true;
    }

    private IEnumerator StartingPhase()
    {
        currentState.Value = GameState.Starting;
        for (int i = 3; i > 0; i--)
        {
            _countdownTimer.Value = i;
            yield return new WaitForSeconds(1f);
        }
        OnMatchStarted?.Invoke();
    }

    private IEnumerator PlayingPhase()
    {
        matchStartTime = Time.time;
        _networkMatchStartTime.Value = (float)NetworkManager.ServerTime.Time;
        currentState.Value = GameState.Playing;

        while (!IsMatchFinished())
            yield return null;
    }

    public override void OnDestroy()
    {
        StopAllCoroutines();
    }

    private IEnumerator MatchEndPhase()
    {
        currentState.Value = GameState.MatchEnded;
        OnMatchEnded?.Invoke();

        DisableAllPlayerControls();
        UnlockCursor();

        var winner = DetermineWinner();

        if (winner.clientId != ulong.MaxValue)
        {
            ShowWinnerClientRpc(winner.clientId, winner.playerName, winner.soulCount);
        }

        yield return new WaitForSeconds(returnToLobbyDelay);

        if (IsServer)
        {
            CleanupBeforeLobbyClientRpc();
            yield return new WaitForSeconds(0.5f);
            NetworkManager.Singleton.SceneManager.LoadScene(lobbySceneName, LoadSceneMode.Single);
        }
    }

    private void DisableAllPlayerControls()
    {
        foreach (var player in FindObjectsOfType<PlayerReferences>())
        {
            if (player.Input != null)
                player.Input.enabled = false;

            if (player.Locomotion != null)
                player.Locomotion.enabled = false;

            if (player.Combat != null)
                player.Combat.enabled = false;
        }
    }

    private void UnlockCursor()
    {
        Cursor.lockState = CursorLockMode.None;
        Cursor.visible = true;
    }

    private (ulong clientId, string playerName, int soulCount) DetermineWinner()
    {
        ulong winnerId = ulong.MaxValue;
        string winnerName = "Unknown";
        int maxSouls = -1;

        foreach (var client in NetworkManager.Singleton.ConnectedClientsList)
        {
            if (client.PlayerObject == null) continue;

            var soul = client.PlayerObject.GetComponent<SoulComponent>();
            if (soul != null && soul.SoulCount.Value > maxSouls)
            {
                maxSouls = soul.SoulCount.Value;
                winnerId = client.ClientId;

                if (PlayerNameRegistry.Instance != null)
                    winnerName = PlayerNameRegistry.Instance.GetPlayerName(client.ClientId);
                else
                    winnerName = $"Player {client.ClientId}";
            }
        }

        return (winnerId, winnerName, maxSouls);
    }

    [ClientRpc]
    private void ShowWinnerClientRpc(ulong winnerId, string winnerName, int soulCount)
    {
        UnlockCursor();

        var matchEndUI = FindObjectOfType<MatchEndUI>();
        if (matchEndUI != null)
        {
            matchEndUI.ShowWinner(winnerName, soulCount, returnToLobbyDelay);
        }
    }

    [ClientRpc]
    private void CleanupBeforeLobbyClientRpc()
    {
        var players = FindObjectsOfType<PlayerReferences>();
        foreach (var player in players)
        {
            if (player != null && player.gameObject != null)
            {
                Destroy(player.gameObject);
            }
        }

        UnlockCursor();
    }

    private bool IsMatchFinished()
    {
        return IsServer && (Time.time - matchStartTime) >= matchDuration;
    }

    public float GetRemainingTime()
    {
        if (CurrentState != GameState.Playing) return matchDuration;
        return Mathf.Max(0f, matchDuration - ((float)NetworkManager.ServerTime.Time - _networkMatchStartTime.Value));
    }
}