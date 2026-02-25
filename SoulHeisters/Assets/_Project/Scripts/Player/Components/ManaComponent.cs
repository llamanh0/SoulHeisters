using System;
using Unity.Netcode;
using UnityEngine;

public class ManaComponent : NetworkBehaviour
{
    [SerializeField] private float maxMana = 100f;
    [SerializeField] private float regenRate = 15f;

    public NetworkVariable<float> CurrentMana = new NetworkVariable<float>(0f,
        NetworkVariableReadPermission.Everyone,
        NetworkVariableWritePermission.Server);

    public event Action<float, float> OnManaChanged;

    public override void OnNetworkSpawn()
    {
        if (IsServer)
            CurrentMana.Value = maxMana;

        CurrentMana.OnValueChanged += (oldVal, newVal) =>
        {
            OnManaChanged?.Invoke(newVal, maxMana);
        };
    }

    private void Update()
    {
        if (!IsServer) return;

        if (CurrentMana.Value < maxMana)
        {
            CurrentMana.Value += regenRate * Time.deltaTime;
            if (CurrentMana.Value > maxMana)
                CurrentMana.Value = maxMana;
        }
    }

    public bool TryConsume(float amount)
    {
        if (!IsServer) return false;

        if (CurrentMana.Value < amount)
            return false;

        CurrentMana.Value -= amount;
        return true;
    }
}