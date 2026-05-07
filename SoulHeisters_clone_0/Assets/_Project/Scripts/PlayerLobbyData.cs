using Unity.Collections;
using Unity.Netcode;

/// <summary>
/// Lobi icindeki oyuncu bilgilerini tutar
/// Network variable'lar ile senkronize edilir
/// </summary>
public struct PlayerLobbyData : INetworkSerializable, System.IEquatable<PlayerLobbyData>
{
    public ulong clientId;
    public FixedString32Bytes playerName;
    public bool isReady;

    public PlayerLobbyData(ulong id, string name, bool ready)
    {
        clientId = id;
        playerName = name;
        isReady = ready;
    }

    public void NetworkSerialize<T>(BufferSerializer<T> serializer) where T : IReaderWriter
    {
        serializer.SerializeValue(ref clientId);
        serializer.SerializeValue(ref playerName);
        serializer.SerializeValue(ref isReady);
    }

    public bool Equals(PlayerLobbyData other)
    {
        return clientId == other.clientId &&
               playerName.Equals(other.playerName) &&
               isReady == other.isReady;
    }
}