using System;
using Unity.Netcode;
using UnityEngine;

/// <summary>
/// Network uzerinden senkronize edilen mana sistemi.
/// 
/// Sorumluluklar:
/// - Mevcut mana degerini NetworkVariable ile saklamak
/// - Server tarafinda sabit oranda mana regen yapmak
/// - Mana tuketim islemlerini sadece server tarafinda gerceklestirmek
/// 
/// Eventler:
/// - OnManaChanged: Mana her degistiginde (UI icin)
/// </summary>
public class ManaComponent : NetworkBehaviour
{
    [SerializeField] private float maxMana = 100f;
    [SerializeField] private float regenRate = 15f;

    /// <summary>
    /// Network uzerinde senkronize edilen mana miktari.
    /// Herkes okuyabilir, sadece server yazabilir.
    /// </summary>
    public NetworkVariable<float> CurrentMana = new NetworkVariable<float>(
        0f,
        NetworkVariableReadPermission.Everyone,
        NetworkVariableWritePermission.Server
    );

    /// <summary> Parametreler: mevcut mana, maksimum mana. </summary>
    public event Action<float, float> OnManaChanged;

    public override void OnNetworkSpawn()
    {
        if (IsServer)
        {
            CurrentMana.Value = maxMana;
        }

        // Degisimleri UI icin event'e cevir
        CurrentMana.OnValueChanged += (oldVal, newVal) =>
        {
            OnManaChanged?.Invoke(newVal, maxMana);
        };
    }

    private void Update()
    {
        if (!IsServer) return;

        // Server tarafinda mana regen
        if (CurrentMana.Value < maxMana)
        {
            CurrentMana.Value += regenRate * Time.deltaTime;
            if (CurrentMana.Value > maxMana)
                CurrentMana.Value = maxMana;
        }
    }

    /// <summary>
    /// Verilen miktarda mana tuketmeye calisir.
    /// Sadece server tarafinda true donebilir.
    /// </summary>
    public bool TryConsume(float amount)
    {
        if (!IsServer) return false;

        if (CurrentMana.Value < amount)
            return false;

        CurrentMana.Value -= amount;
        return true;
    }
}