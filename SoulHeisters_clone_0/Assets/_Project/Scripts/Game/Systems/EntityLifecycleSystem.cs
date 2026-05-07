using Unity.Netcode;
using UnityEngine;

/// <summary>
/// Entity yasam dongusu yoneticisi
/// Olum durumlarini izler ve temizlik yapar
/// </summary>
public class EntityLifecycleSystem : NetworkBehaviour
{
    public static EntityLifecycleSystem Instance;

    private void Awake()
    {
        if (Instance != null && Instance != this)
        {
            Destroy(gameObject);
            return;
        }
        Instance = this;
    }

    public void RegisterEntity(NetworkObject netObj)
    {
        if (netObj == null)
        {
            Debug.LogWarning("[EntityLifecycleSystem] Tried to register null NetworkObject");
            return;
        }

        var health = netObj.GetComponent<HealthComponent>();
        if (health == null)
        {
            Debug.LogWarning("[EntityLifecycleSystem] NetworkObject has no HealthComponent");
            return;
        }

        // Despawn et
        health.OnDeath += () => HandleDeath(netObj);
    }

    private void HandleDeath(NetworkObject netObj)
    {
        if (!IsServer) return;

        // NULL CHECK - COK ONEMLI!
        if (netObj == null || netObj.gameObject == null)
        {
            Debug.LogWarning("[EntityLifecycleSystem] NetworkObject already destroyed");
            return;
        }

        if (!netObj.IsSpawned)
        {
            Debug.LogWarning("[EntityLifecycleSystem] NetworkObject is not spawned");
            return;
        }

        Debug.Log($"[EntityLifecycleSystem] Despawning entity: {netObj.gameObject.name}");
        netObj.Despawn(true);
    }
}