using Unity.Netcode;
using UnityEngine;

public class SpellBookPickup : NetworkBehaviour
{
    [SerializeField] private SpellDefinitionSO spellDefinition;

    private void OnTriggerEnter(Collider other)
    {
        if (!IsServer) return;

        if (!other.TryGetComponent<PlayerReferences>(out var playerRefs))
            return;

        var inventory = playerRefs.SpellInventory;

        if (inventory == null) return;

        inventory.AddSpellServerRpc(spellDefinition.spellType);

        GetComponent<NetworkObject>().Despawn();
    }
}