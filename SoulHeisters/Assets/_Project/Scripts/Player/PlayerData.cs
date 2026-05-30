using Unity.Collections;
using Unity.Netcode;

public struct PlayerData : INetworkSerializable, System.IEquatable<PlayerData>
{
    public ulong clientId;
    public FixedString64Bytes playerName;
    public int soulCount;
    public int ping;

    public PlayerData(ulong id, string name, int souls, int pingMs)
    {
        clientId = id;
        playerName = name;
        soulCount = souls;
        ping = pingMs;
    }

    public void NetworkSerialize<T>(BufferSerializer<T> serializer) where T : IReaderWriter
    {
        serializer.SerializeValue(ref clientId);
        serializer.SerializeValue(ref playerName);
        serializer.SerializeValue(ref soulCount);
        serializer.SerializeValue(ref ping);
    }

    public bool Equals(PlayerData other)
    {
        return clientId == other.clientId;
    }
}