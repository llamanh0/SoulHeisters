using Unity.Netcode;
using UnityEngine;

public class MobAttackHitbox : MonoBehaviour
{
    [SerializeField] private float damage = 15f;
    private MobAIController _owner;
    private bool _hasHitInThisSwing;

    private void Awake()
    {
        var col = GetComponent<Collider>();
        if (col == null) col = gameObject.AddComponent<BoxCollider>();
        col.isTrigger = true;
    }

    public void Initialize(MobAIController owner, float dmg)
    {
        _owner = owner;
        damage = dmg;
    }

    public void ResetHitFlag()
    {
        _hasHitInThisSwing = false;
    }

    private void OnTriggerEnter(Collider other)
    {
        if (_owner == null || !_owner.IsServer || _hasHitInThisSwing) return;

        var ownerHealth = _owner.GetComponent<HealthComponent>();
        if (ownerHealth != null && ownerHealth.IsDead) return;

        if (other.GetComponentInParent<MobAIController>() != null) return;

        var player = other.GetComponentInParent<PlayerReferences>();
        if (player != null)
        {
            var health = player.Health;
            if (health != null && !health.IsDead)
            {
                health.TakeDamage(damage, 0);
                _hasHitInThisSwing = true;
            }
        }
    }
}