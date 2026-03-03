using Unity.Netcode;

public class EntityLifecycleSystem : NetworkBehaviour
{
    public static EntityLifecycleSystem Instance;

    private void Awake()
    {
        Instance = this;
    }

    public void RegisterEntity(NetworkObject netObj)
    {
        var health = netObj.GetComponent<HealthComponent>();
        if (health == null) return;

        health.OnDeath += () => HandleDeath(netObj);
    }

    private void HandleDeath(NetworkObject netObj)
    {
        if (!IsServer) return;

        // Future hook:
        // SpawnLoot(netObj);
        // NotifyThreatSystem(netObj);
        // AwardXP(netObj);

        netObj.Despawn();
    }
}