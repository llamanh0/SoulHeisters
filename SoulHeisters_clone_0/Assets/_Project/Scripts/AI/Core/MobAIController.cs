using Unity.Netcode;
using UnityEngine;

public class MobAIController : NetworkBehaviour
{
    [SerializeField] private float aggroRange = 10f;
    [SerializeField] private float moveSpeed = 3f;

    private HealthComponent health;

    private Transform target;
    public override void OnNetworkSpawn()
    {
        if (!IsServer) return;

        health = GetComponent<HealthComponent>();
        health.OnDeath += HandleDeath;
    }

    private void Update()
    {
        if (!IsServer) return;

        if (target == null)
            FindTarget();

        if (target != null)
            ChaseTarget();
    }
    private void HandleDeath()
    {
        GetComponent<NetworkObject>().Despawn();
    }

    private void FindTarget()
    {
        foreach (var client in NetworkManager.Singleton.ConnectedClientsList)
        {
            var player = client.PlayerObject;
            if (player == null) continue;

            float dist = Vector3.Distance(transform.position,
                                          player.transform.position);

            if (dist < aggroRange)
            {
                target = player.transform;
                break;
            }
        }
    }

    private void ChaseTarget()
    {
        Vector3 dir = (target.position - transform.position).normalized;
        transform.position += dir * moveSpeed * Time.deltaTime;
    }
}