using System.Collections;
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

    public GameState CurrentState => currentState.Value;

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
        Debug.Log("[GameStateManager] Waiting for players...");

        yield return new WaitForSeconds(0.5f);

        int attempts = 0;
        while (NetworkManager.Singleton.ConnectedClients.Count < 1 && attempts < 50)
        {
            attempts++;
            yield return new WaitForSeconds(0.1f);
        }

        Debug.Log($"[GameStateManager] {NetworkManager.Singleton.ConnectedClients.Count} players ready");
    }

    private IEnumerator StartingPhase()
    {
        currentState.Value = GameState.Starting;
        Debug.Log("[GameStateManager] Match starting...");

        yield return new WaitForSeconds(1f);

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