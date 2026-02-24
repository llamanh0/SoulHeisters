using UnityEngine;

public class PlayerReferences : MonoBehaviour
{
    [field: SerializeField] public PlayerInputHandler Input { get; private set; }
    [field: SerializeField] public PlayerLocomotion Locomotion { get; private set; }
    [field: SerializeField] public PlayerVisualController Visual { get; private set; }
    [field: SerializeField] public PlayerCombat Combat { get; private set; }
    [field: SerializeField] public HealthComponent Health { get; private set; }
    //[field: SerializeField] public SoulComponent Soul { get; private set; }

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
        Visual = GetComponentInChildren<PlayerVisualController>();
        Combat = GetComponentInChildren<PlayerCombat>();
        Health = GetComponentInChildren<HealthComponent>();
        //Soul = GetComponentInChildren<SoulComponent>();
    }
}