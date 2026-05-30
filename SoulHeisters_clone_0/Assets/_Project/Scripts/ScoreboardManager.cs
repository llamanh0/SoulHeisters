using System.Collections.Generic;
using Unity.Netcode;
using UnityEngine;

public class ScoreboardManager : NetworkBehaviour
{
    public static ScoreboardManager Instance { get; private set; }

    private void Awake()
    {
        if (Instance != null && Instance != this)
        {
            Destroy(gameObject);
            return;
        }
        Instance = this;
    }

    public List<PlayerData> GetAllPlayerData()
    {
        List<PlayerData> playerDataList = new List<PlayerData>();

        if (NetworkManager.Singleton == null) return playerDataList;

        foreach (var client in NetworkManager.Singleton.ConnectedClientsList)
        {
            if (client.PlayerObject == null) continue;

            string playerName = PlayerNameRegistry.Instance != null
                ? PlayerNameRegistry.Instance.GetPlayerName(client.ClientId)
                : $"Player {client.ClientId}";

            var soulComponent = client.PlayerObject.GetComponent<SoulComponent>();
            int souls = soulComponent != null ? soulComponent.SoulCount.Value : 0;

            int ping = GetClientPing(client.ClientId);

            playerDataList.Add(new PlayerData(client.ClientId, playerName, souls, ping));
        }

        playerDataList.Sort((a, b) => b.soulCount.CompareTo(a.soulCount));

        return playerDataList;
    }

    private int GetClientPing(ulong clientId)
    {
        if (NetworkManager.Singleton.IsServer && clientId == NetworkManager.ServerClientId)
        {
            return 0;
        }

        try
        {
            var transport = NetworkManager.Singleton.NetworkConfig.NetworkTransport;
            ulong rtt = transport.GetCurrentRtt(clientId);

            return (int)(rtt / 2);
        }
        catch
        {
            return 0;
        }
    }
}