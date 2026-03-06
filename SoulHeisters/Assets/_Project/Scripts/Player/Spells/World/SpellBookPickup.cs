using Unity.Netcode;
using UnityEngine;

/// <summary>
/// Dunyada yer alan ve uzerinden gecilince yeni bir spell acan pickup.
/// 
/// Mantik:
/// - Server tarafinda OnTriggerEnter ile PlayerReferences bulur
/// - Ilgili oyuncunun SpellInventory'sine ClientRpc ile "unlock" bildirimi gonderir
/// - Ardindan pickup NetworkObject'ini despawn eder
/// </summary>
public class SpellBookPickup : NetworkBehaviour
{
    [SerializeField] private SpellDefinitionSO spellDefinition;

    private void OnTriggerEnter(Collider other)
    {
        if (!IsServer) return;

        if (!other.TryGetComponent<PlayerReferences>(out var playerRefs))
            return;

        var inventory = playerRefs.SpellInventory;

        // Sadece ilgili oyuncunun client'ina yeni spell acmasini soyle
        inventory.UnlockSpellClientRpc(spellDefinition.spellType, playerRefs.Combat.OwnerClientId);

        // Pickup artik kullanildi, network'ten kaldir
        GetComponent<NetworkObject>().Despawn();
    }
}