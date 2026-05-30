using System.Collections;
using Unity.Netcode;
using UnityEngine;

public class PlayerReadyState : NetworkBehaviour
{
    private NetworkVariable<bool> _isReady = new NetworkVariable<bool>(
        false,
        NetworkVariableReadPermission.Everyone,
        NetworkVariableWritePermission.Server
    );

    public bool IsReady => _isReady.Value;

    public override void OnNetworkSpawn()
    {
        if (IsOwner)
        {
            StartCoroutine(WaitForSceneLoadAndSetReady());
        }
    }

    private IEnumerator WaitForSceneLoadAndSetReady()
    {
        yield return new WaitForSeconds(0.5f);

        int attempts = 0;
        while (!IsSceneFullyLoaded() && attempts < 100)
        {
            yield return new WaitForSeconds(0.1f);
            attempts++;
        }

        Debug.Log($"[PlayerReadyState] Client {OwnerClientId} scene loaded");

        var controller = GetComponent<CharacterController>();
        if (controller != null)
        {
            controller.enabled = true;
            Debug.Log($"[PlayerReadyState] CharacterController enabled for client {OwnerClientId}");
        }

        SetReady(true);
        Debug.Log($"[PlayerReadyState] Client {OwnerClientId} set ready");
    }

    private bool IsSceneFullyLoaded()
    {
        var spawnSystem = FindObjectOfType<SpawnSystem>();
        var gameStateManager = FindObjectOfType<GameStateManager>();

        return spawnSystem != null && gameStateManager != null;
    }

    public void SetReady(bool ready)
    {
        if (IsServer)
        {
            _isReady.Value = ready;
            Debug.Log($"[PlayerReadyState] Client {OwnerClientId} ready: {ready}");
        }
        else if (IsOwner)
        {
            SetReadyServerRpc(ready);
        }
    }

    [ServerRpc]
    private void SetReadyServerRpc(bool ready)
    {
        _isReady.Value = ready;
        Debug.Log($"[PlayerReadyState] Client {OwnerClientId} ready: {ready}");
    }
}