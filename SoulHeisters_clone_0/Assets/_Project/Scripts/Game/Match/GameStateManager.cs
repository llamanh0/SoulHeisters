using System.Collections;
using Unity.Netcode;
using UnityEngine;

public class GameStateManager : NetworkBehaviour
{
    public static GameStateManager Instance;

    private NetworkVariable<GameState> currentState = new NetworkVariable<GameState>(GameState.WaitingForPlayers);

    public GameState CurrentState => currentState.Value;

    public System.Action OnMatchStarted;
    public System.Action OnMatchEnded;

    private void Awake()
    {
        Instance = this;
    }

    public override void OnNetworkSpawn()
    {
        if (IsServer)
        {
            StartCoroutine(GameLoop());
        }
    }

    private IEnumerator GameLoop()
    {
        while (true)
        {
            yield return WaitForPlayers();
            yield return StartingPhase();
            yield return PlayingPhase();
            yield return MatchEndPhase();
        }
    }

    private IEnumerator WaitForPlayers()
    {
        currentState.Value = GameState.WaitingForPlayers;

        while (NetworkManager.Singleton.ConnectedClients.Count < 1)
            yield return null;
    }

    private IEnumerator StartingPhase()
    {
        currentState.Value = GameState.Starting;
        yield return new WaitForSeconds(3f);
        OnMatchStarted?.Invoke();
    }

    private IEnumerator PlayingPhase()
    {
        currentState.Value = GameState.Playing;

        while (!IsMatchFinished())
            yield return null;
    }

    private IEnumerator MatchEndPhase()
    {
        currentState.Value = GameState.MatchEnded;
        yield return new WaitForSeconds(5f);
        OnMatchEnded?.Invoke();
    }

    private bool IsMatchFinished()
    {
        // simdilik false
        return false;
    }
}