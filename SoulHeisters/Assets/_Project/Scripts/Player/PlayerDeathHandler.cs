using Unity.Netcode;
using UnityEngine;

public class PlayerDeathHandler : NetworkBehaviour
{
    [Header("References")]
    [SerializeField] private HealthComponent healthComponent;
    [SerializeField] private RagdollController ragdollController;
    [SerializeField] private Collider mainCapsuleCollider; // Root objesindeki ana collider
    [SerializeField] private Rigidbody mainRigidbody; // Root objesindeki ana rigidbody (varsa)

    [Header("Scripts to Disable")]
    // Oyuncu öldüğünde çalışmasını istemediğimiz scriptler
    [SerializeField] private MonoBehaviour[] scriptsToDisable;

    public override void OnNetworkSpawn()
    {
        if (healthComponent != null)
        {
            // Ölüm eventine abone ol
            healthComponent.OnDeath += HandleDeath;
        }
    }

    public override void OnNetworkDespawn()
    {
        if (healthComponent != null)
        {
            // Aboneliği iptal et (Hafıza sızıntısını önler)
            healthComponent.OnDeath -= HandleDeath;
        }
    }

    private void HandleDeath()
    {
        // 1. Ana Collider'ı kapat (Yoksa ragdoll havada asılı kalır veya sapıtır)
        if (mainCapsuleCollider != null) mainCapsuleCollider.enabled = false;

        // 2. Ana Rigidbody'yi durdur
        if (mainRigidbody != null)
        {
            mainRigidbody.isKinematic = true;
            mainRigidbody.velocity = Vector3.zero;
        }

        // 3. Kontrol scriptlerini kapat (Ateş etme, yürüme, etrafa bakma bitsin)
        foreach (var script in scriptsToDisable)
        {
            if (script != null) script.enabled = false;
        }

        // 4. Ragdoll'u serbest bırak (Görsel şölen başlasın)
        if (ragdollController != null) ragdollController.EnableRagdoll();

        // İsteğe bağlı: Ölünce silahı elinden düşürmek için Weapon objesini de serbest bırakabilirsin.
        Debug.Log($"[DeathHandler] {gameObject.name} öldü ve Ragdoll'a geçti.");
    }
}