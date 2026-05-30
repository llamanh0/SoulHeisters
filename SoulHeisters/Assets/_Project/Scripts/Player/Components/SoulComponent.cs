using System;
using Unity.Netcode;
using UnityEngine;

public class SoulComponent : NetworkBehaviour
{
    public NetworkVariable<int> SoulCount = new NetworkVariable<int>(
        0,
        NetworkVariableReadPermission.Everyone,
        NetworkVariableWritePermission.Server
    );

    public event Action<int> OnSoulChanged;

    public override void OnNetworkSpawn()
    {
        SoulCount.OnValueChanged += HandleSoulChanged;
    }

    public override void OnNetworkDespawn()
    {
        SoulCount.OnValueChanged -= HandleSoulChanged;
    }

    private void HandleSoulChanged(int oldValue, int newValue)
    {
        OnSoulChanged?.Invoke(newValue);
        Debug.Log($"[SoulComponent] Soul changed: {oldValue} → {newValue}");
    }

    [ServerRpc(RequireOwnership = false)]
    public void AddSoulServerRpc(int amount)
    {
        SoulCount.Value += amount;
    }

    [ServerRpc(RequireOwnership = false)]
    public void RemoveSoulServerRpc(int amount)
    {
        SoulCount.Value = Mathf.Max(0, SoulCount.Value - amount);
    }
}