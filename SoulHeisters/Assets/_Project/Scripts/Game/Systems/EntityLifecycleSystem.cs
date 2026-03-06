using Unity.Netcode;

/// <summary>
/// Ortak entity omur yonetimi icin kullanilan basit sistem.
/// 
/// Sorumluluklar:
/// - NetworkObject'e ait HealthComponent'in OnDeath event'ine abone olmak
/// - Entity oldugunde ortak davranislari uygulamak (su an sadece despawn)
/// 
/// Not:
/// - Sadece server tarafinda aktif olmalidir.
/// - Ilerde loot spawn, XP ver, threat sistemi bildir gibi genisletilebilir.
/// </summary>
public class EntityLifecycleSystem : NetworkBehaviour
{
    public static EntityLifecycleSystem Instance;

    private void Awake()
    {
        Instance = this;
    }

    /// <summary>
    /// Verilen NetworkObject uzerindeki HealthComponent'i bulur ve
    /// olum event'ine abone olur.
    /// </summary>
    public void RegisterEntity(NetworkObject netObj)
    {
        var health = netObj.GetComponent<HealthComponent>();
        if (health == null) return;

        // Entity oldugunde HandleDeath cagirilacak
        health.OnDeath += () => HandleDeath(netObj);
    }

    /// <summary>
    /// Entity oldugunde cagrilan ortak handler.
    /// Burada loot, XP, threat sistemi gibi isler yapilabilir.
    /// Simdilik sadece despawn eder.
    /// </summary>
    private void HandleDeath(NetworkObject netObj)
    {
        if (!IsServer) return;

        // TODO:
        // SpawnLoot(netObj);
        // NotifyThreatSystem(netObj);
        // AwardXP(netObj);

        if (netObj != null && netObj.IsSpawned)
        {
            netObj.Despawn();
        }
    }
}