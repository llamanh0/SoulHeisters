using System.Collections.Generic;
using Unity.Netcode;
using UnityEngine;
using Cinemachine;

[RequireComponent(typeof(PlayerReferences))]
public class PlayerSpectateController : NetworkBehaviour
{
    [Header("Camera")]
    [SerializeField] private CinemachineVirtualCamera spectateCamera;

    private PlayerReferences _refs;
    private List<PlayerReferences> _alivePlayers = new List<PlayerReferences>();
    private int _currentIndex = -1;
    private bool _isSpectating = false;

    private void Awake()
    {
        _refs = GetComponent<PlayerReferences>();
    }

    public override void OnNetworkSpawn()
    {
        if (!IsOwner)
        {
            if (spectateCamera != null)
                spectateCamera.gameObject.SetActive(false);
            return;
        }

        if (spectateCamera != null)
        {
            spectateCamera.gameObject.SetActive(true);
            spectateCamera.Priority = 5;
        }

        if (_refs.Health != null)
        {
            _refs.Health.OnDeath += HandleLocalPlayerDeath;
        }
    }

    public override void OnNetworkDespawn()
    {
        if (!IsOwner) return;

        if (_refs.Health != null)
        {
            _refs.Health.OnDeath -= HandleLocalPlayerDeath;
        }
    }

    private void HandleLocalPlayerDeath()
    {
        if (GameStateManager.Instance != null &&
            GameStateManager.Instance.CurrentState != GameState.Playing)
            return;

        StartCoroutine(StartSpectateAfterDelay(3f));
    }

    private System.Collections.IEnumerator StartSpectateAfterDelay(float delay)
    {
        yield return new WaitForSeconds(delay);

        FindAlivePlayers();

        if (_alivePlayers.Count == 0)
        {
            Debug.Log("[PlayerSpectateController] No alive players to spectate");
            yield break;
        }

        _currentIndex = 0;
        _isSpectating = true;
        SetSpectateTarget(_alivePlayers[_currentIndex]);
    }

    private void FindAlivePlayers()
    {
        _alivePlayers.Clear();
        var allPlayers = FindObjectsOfType<PlayerReferences>();

        foreach (var p in allPlayers)
        {
            if (p == _refs) continue;
            if (p.Health != null && p.Health.IsDead) continue;
            _alivePlayers.Add(p);
        }

        Debug.Log($"[PlayerSpectateController] Found {_alivePlayers.Count} alive players");
    }

    private void SetSpectateTarget(PlayerReferences targetPlayer)
    {
        if (spectateCamera == null || targetPlayer == null) return;

        var locomotion = targetPlayer.Locomotion;
        if (locomotion == null) return;

        Transform camRoot = locomotion.CameraRoot;
        spectateCamera.Follow = camRoot;
        spectateCamera.LookAt = camRoot;
        spectateCamera.Priority = 50;

        Debug.Log($"[PlayerSpectateController] Spectating player {targetPlayer.GetComponent<NetworkObject>().OwnerClientId}");
    }

    public void StopSpectating()
    {
        _isSpectating = false;
        _currentIndex = -1;
        _alivePlayers.Clear();

        if (spectateCamera != null)
        {
            spectateCamera.Follow = null;
            spectateCamera.LookAt = null;
            spectateCamera.Priority = 5;
        }

        Debug.Log("[PlayerSpectateController] Spectating stopped");
    }

    private void Update()
    {
        if (!IsOwner || !_isSpectating) return;
        if (_refs.Health == null || !_refs.Health.IsDead) return;
    }

    private void CycleSpectateTarget(int direction)
    {
        if (_alivePlayers.Count == 0) return;

        _currentIndex += direction;
        if (_currentIndex < 0)
            _currentIndex = _alivePlayers.Count - 1;
        else if (_currentIndex >= _alivePlayers.Count)
            _currentIndex = 0;

        SetSpectateTarget(_alivePlayers[_currentIndex]);
    }
}