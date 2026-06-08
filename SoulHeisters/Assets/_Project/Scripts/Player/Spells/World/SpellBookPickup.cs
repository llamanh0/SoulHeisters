using Unity.Netcode;
using UnityEngine;

public class SpellBookPickup : NetworkBehaviour
{
    [SerializeField] private SpellDefinitionSO spellDefinition;
    [SerializeField] private AudioClip pickupSound;
    [SerializeField] private float pickupSoundVolume = 0.7f;

    private void OnTriggerEnter(Collider other)
    {
        if (!IsServer) return;

        if (other.TryGetComponent<PlayerReferences>(out var r))
        {
            r.SpellInventory.UnlockSpellClientRpc(spellDefinition.spellType, r.Combat.OwnerClientId);

            PlayPickupSoundClientRpc(transform.position);

            GetComponent<NetworkObject>().Despawn();
        }
    }

    [ClientRpc]
    private void PlayPickupSoundClientRpc(Vector3 pos)
    {
        if (pickupSound != null)
            AudioSource.PlayClipAtPoint(pickupSound, pos, pickupSoundVolume);
    }
}