using UnityEngine;

/// <summary>
/// Oyuncuya ait tum bilesenlere merkezi erisim saglayan referans hub'i.
/// 
/// Amac:
/// - Farkli script'lerin birbiriyle loosely coupled sekilde calismasini saglamak
/// - GetComponent zincirlerini tekrar tekrar yazmaktan kurtulmak
/// 
/// Not:
/// - Referanslar hem Inspector uzerinden, hem de otomatik olarak Awake/Reset'te atanir.
/// </summary>
public class PlayerReferences : MonoBehaviour
{
    [field: SerializeField] public PlayerInputHandler Input { get; private set; }
    [field: SerializeField] public PlayerLocomotion Locomotion { get; private set; }
    [field: SerializeField] public PlayerStateMachine StateMachine { get; private set; }
    [field: SerializeField] public PlayerVisualController Visual { get; private set; }
    [field: SerializeField] public PlayerCombat Combat { get; private set; }
    [field: SerializeField] public HealthComponent Health { get; private set; }
    [field: SerializeField] public ManaComponent Mana { get; private set; }
    [field: SerializeField] public SpellInventory SpellInventory { get; private set; }

    private void Awake()
    {
        InitializeReferences();
    }

    private void Reset()
    {
        // Inspector'dan "Reset" dendiginde de referanslari otomatik bul
        InitializeReferences();
    }

    /// <summary>
    /// Gerekli alt bilesenleri otomatik olarak bulur.
    /// Bu sayede sahnede prefab duzeyinde referanslar kaybolsa bile
    /// yeniden kendini toparlayabilir.
    /// </summary>
    private void InitializeReferences()
    {
        Input = GetComponentInChildren<PlayerInputHandler>();
        Locomotion = GetComponentInChildren<PlayerLocomotion>();
        StateMachine = GetComponent<PlayerStateMachine>();
        Visual = GetComponentInChildren<PlayerVisualController>();
        Combat = GetComponentInChildren<PlayerCombat>();
        Health = GetComponentInChildren<HealthComponent>();
        Mana = GetComponentInChildren<ManaComponent>();
        SpellInventory = GetComponentInChildren<SpellInventory>();
    }
}