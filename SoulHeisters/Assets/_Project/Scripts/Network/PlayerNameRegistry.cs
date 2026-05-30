using System.Collections.Generic;
using Unity.Netcode;
using UnityEngine;

public class PlayerNameRegistry : NetworkBehaviour
{
    public static PlayerNameRegistry Instance { get; private set; }

    private Dictionary<ulong, string> _playerNames = new Dictionary<ulong, string>();

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

    [ServerRpc(RequireOwnership = false)]
    public void RegisterPlayerNameServerRpc(ulong clientId, string playerName)
    {
        _playerNames[clientId] = playerName;
        Debug.Log($"[PlayerNameRegistry] Registered: {playerName} (ID: {clientId})");

        BroadcastPlayerNameClientRpc(clientId, playerName);
    }

    [ClientRpc]
    private void BroadcastPlayerNameClientRpc(ulong clientId, string playerName)
    {
        _playerNames[clientId] = playerName;
        Debug.Log($"[PlayerNameRegistry] Client received: {playerName} (ID: {clientId})");
    }

    public string GetPlayerName(ulong clientId)
    {
        if (_playerNames.TryGetValue(clientId, out string name))
        {
            return name;
        }
        return $"Player {clientId}";
    }

    public bool HasPlayer(ulong clientId)
    {
        return _playerNames.ContainsKey(clientId);
    }

    public override void OnNetworkSpawn()
    {
        if (IsServer)
        {
            NetworkManager.Singleton.OnClientConnectedCallback += SyncNamesToNewClient;
        }
    }

    public override void OnNetworkDespawn()
    {
        if (IsServer && NetworkManager.Singleton != null)
        {
            NetworkManager.Singleton.OnClientConnectedCallback -= SyncNamesToNewClient;
        }
    }

    private void SyncNamesToNewClient(ulong newClientId)
    {
        foreach (var kvp in _playerNames)
        {
            SendNameToClientRpc(kvp.Key, kvp.Value,
                new ClientRpcParams
                {
                    Send = new ClientRpcSendParams
                    {
                        TargetClientIds = new ulong[] { newClientId }
                    }
                });
        }
    }

    [ClientRpc]
    private void SendNameToClientRpc(ulong clientId, string playerName, ClientRpcParams rpcParams = default)
    {
        _playerNames[clientId] = playerName;
        Debug.Log($"[PlayerNameRegistry] Synced: {playerName} (ID: {clientId})");
    }
}