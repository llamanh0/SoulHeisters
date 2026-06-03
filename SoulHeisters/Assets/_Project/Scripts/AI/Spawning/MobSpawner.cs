using Unity.Netcode;
using UnityEngine;

public class MobSpawner : MonoBehaviour
{
    [SerializeField] private MobTypeSO mobType;
    [SerializeField] private bool respawnOnDeath = true;
    [SerializeField] private float respawnDelay = 30f;

    private NetworkObject _currentMob;
    private bool _isWaitingToRespawn;

    public void SpawnMob()
    {
        if (mobType == null || mobType.prefab == null || _isWaitingToRespawn) return;

        var mob = Instantiate(mobType.prefab, transform.position, transform.rotation);
        var netObj = mob.GetComponent<NetworkObject>();

        if (netObj != null)
        {
            netObj.Spawn();
            _currentMob = netObj;

            var ai = mob.GetComponent<MobAIController>();
            if (ai != null)
            {
                ai.SetMobStats(mobType.moveSpeed, mobType.attackRange, mobType.attackDamage,
                               mobType.attackCooldown, mobType.aggroRange);
            }

            var health = mob.GetComponent<HealthComponent>();
            if (health != null)
            {
                health.currentHealth.Value = mobType.maxHealth;
                if (respawnOnDeath)
                {
                    health.OnDeath += HandleMobDeath;
                }
            }

            var dropper = mob.GetComponent<SoulDropper>();
            if (dropper != null)
            {
                dropper.SetDropAmount(mobType.soulReward);

                if (mobType.soulPrefabs != null && mobType.soulPrefabs.Count > 0)
                {
                    dropper.SetSoulPrefabs(mobType.soulPrefabs);
                }
            }

            var anim = mob.GetComponent<Animator>();
            if (anim != null && mobType.animatorController != null)
                anim.runtimeAnimatorController = mobType.animatorController;

            EntityLifecycleSystem.Instance?.RegisterEntity(netObj);
        }
    }

    private void HandleMobDeath()
    {
        if (_isWaitingToRespawn) return;

        _isWaitingToRespawn = true;
        _currentMob = null;

        Invoke(nameof(RespawnMob), respawnDelay);
    }

    private void RespawnMob()
    {
        _isWaitingToRespawn = false;
        SpawnMob();
    }

    public MobTypeSO MobType => mobType;
}