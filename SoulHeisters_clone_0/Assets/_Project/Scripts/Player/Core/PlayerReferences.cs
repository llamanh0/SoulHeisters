using UnityEngine;

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
    [field: SerializeField] public CharacterControllerManager ControllerManager { get; private set; }

    public Transform CameraRoot => Locomotion != null ? Locomotion.CameraRoot : transform;

    private void Awake()
    {
        InitializeReferences();
    }

    private void Reset()
    {
        InitializeReferences();
    }

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
        ControllerManager = GetComponent<CharacterControllerManager>();
    }
}