using Unity.Netcode;
using UnityEngine;
using System.Collections;

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
        var h = netObj?.GetComponent<HealthComponent>();
        if (h != null)
            h.OnDeath += () => HandleDeath(netObj);
    }

    private void HandleDeath(NetworkObject netObj)
    {
        if (!IsServer || netObj == null || !netObj.IsSpawned) return;

        var isMob = netObj.GetComponent<MobAIController>() != null;

        if (isMob)
        {
            StartCoroutine(DespawnMobAfterDelay(netObj, 0.5f));
        }
    }

    private IEnumerator DespawnMobAfterDelay(NetworkObject netObj, float delay)
    {
        yield return new WaitForSeconds(delay);

        if (netObj != null && netObj.IsSpawned)
        {
            netObj.Despawn(true);
        }
    }
}