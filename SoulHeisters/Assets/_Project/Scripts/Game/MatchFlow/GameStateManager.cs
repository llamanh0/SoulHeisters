using System.Collections;
using System.Collections.Generic;
using Unity.Netcode;
using UnityEngine;
using UnityEngine.SceneManagement;

public class GameStateManager : NetworkBehaviour
{
    public static GameStateManager Instance;

    private NetworkVariable<GameState> currentState =
        new NetworkVariable<GameState>(GameState.WaitingForPlayers);

    private NetworkVariable<float> _networkMatchStartTime = new(
        0f, NetworkVariableReadPermission.Everyone, NetworkVariableWritePermission.Server);

    private NetworkVariable<int> _countdownTimer = new(
        3, NetworkVariableReadPermission.Everyone, NetworkVariableWritePermission.Server);

    public GameState CurrentState => currentState.Value;
    public int CountdownTimer => _countdownTimer.Value;

    public System.Action OnMatchStarted;
    public System.Action OnMatchEnded;

    [Header("Match Settings")]
    [SerializeField] private float matchDuration = 300f;
    [SerializeField] private string gameSceneName = "GameScene";

    private float matchStartTime;
    private bool _gameStarted = false;

    private void Awake()
    {
        if (SceneManager.GetActiveScene().name != gameSceneName)
        {
            Debug.LogWarning("[GameStateManager] Not in GameScene, destroying");
            Destroy(gameObject);
            return;
        }

        if (Instance != null && Instance != this)
        {
            Destroy(gameObject);
            return;
        }
        Instance = this;
        Debug.Log("[GameStateManager] Initialized in GameScene");
    }

    public override void OnNetworkSpawn()
    {
        if (SceneManager.GetActiveScene().name != gameSceneName)
        {
            Debug.LogWarning("[GameStateManager] OnNetworkSpawn not in GameScene, ignoring");
            return;
        }

        if (IsServer && !_gameStarted)
        {
            Debug.Log("[GameStateManager] Starting game loop");
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
        {
            StartCoroutine(ForceEnableAllControllers());
        }
    }

    private IEnumerator ForceEnableAllControllers()
    {
        yield return new WaitForSeconds(0.5f);

        var allPlayers = FindObjectsOfType<PlayerReferences>();

        foreach (var player in allPlayers)
        {
            if (player == null) continue;

            var netObj = player.GetComponent<NetworkObject>();
            if (netObj == null) continue;

            var controller = player.GetComponent<CharacterController>();
            if (controller != null && !controller.enabled)
            {
                controller.enabled = true;
                Debug.Log($"[GameStateManager] Force enabled controller for client {netObj.OwnerClientId}");
            }
        }

        Debug.Log("[GameStateManager] Controller check complete");
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
        Debug.Log("[GameStateManager] Waiting for all players to be ready...");

        yield return new WaitForSeconds(0.5f);

        while (!AreAllPlayersReady())
        {
            yield return new WaitForSeconds(0.5f);
        }

        Debug.Log("[GameStateManager] All players ready!");
    }

    private bool AreAllPlayersReady()
    {
        if (NetworkManager.Singleton.ConnectedClients.Count == 0)
            return false;

        List<PlayerReadyState> playerStates = new List<PlayerReadyState>();

        foreach (var client in NetworkManager.Singleton.ConnectedClientsList)
        {
            if (client.PlayerObject == null)
            {
                Debug.Log($"[GameStateManager] Client {client.ClientId} has no PlayerObject yet");
                return false;
            }

            var readyState = client.PlayerObject.GetComponent<PlayerReadyState>();
            if (readyState == null)
            {
                Debug.LogWarning($"[GameStateManager] Client {client.ClientId} has no PlayerReadyState");
                return false;
            }

            if (!readyState.IsReady)
            {
                Debug.Log($"[GameStateManager] Client {client.ClientId} not ready yet");
                return false;
            }

            playerStates.Add(readyState);
        }

        Debug.Log($"[GameStateManager] All {playerStates.Count} players are ready!");
        return true;
    }

    private IEnumerator StartingPhase()
    {
        currentState.Value = GameState.Starting;
        Debug.Log("[GameStateManager] Match starting countdown...");

        for (int i = 3; i > 0; i--)
        {
            _countdownTimer.Value = i;
            Debug.Log($"[GameStateManager] Countdown: {i}");
            yield return new WaitForSeconds(1f);
        }

        Debug.Log("[GameStateManager] Match started!");
        OnMatchStarted?.Invoke();
    }

    private IEnumerator PlayingPhase()
    {
        matchStartTime = Time.time;
        _networkMatchStartTime.Value = (float)NetworkManager.ServerTime.Time;
        currentState.Value = GameState.Playing;

        Debug.Log("[GameStateManager] Playing phase started");

        while (!IsMatchFinished())
            yield return null;

        Debug.Log("[GameStateManager] Match finished!");
    }

    public override void OnDestroy()
    {
        Debug.Log("[GameStateManager] OnDestroy");
        StopAllCoroutines();
    }

    private IEnumerator MatchEndPhase()
    {
        currentState.Value = GameState.MatchEnded;
        OnMatchEnded?.Invoke();

        yield return new WaitForSeconds(5f);

        if (IsServer)
        {
            Debug.Log("[GameStateManager] Match ended, cleaning up");
        }
    }

    private bool IsMatchFinished()
    {
        if (!IsServer) return false;
        float elapsed = Time.time - matchStartTime;
        return elapsed >= matchDuration;
    }

    public float GetRemainingTime()
    {
        if (CurrentState != GameState.Playing) return matchDuration;
        float elapsed = (float)NetworkManager.ServerTime.Time - _networkMatchStartTime.Value;
        return Mathf.Max(0f, matchDuration - elapsed);
    }
}