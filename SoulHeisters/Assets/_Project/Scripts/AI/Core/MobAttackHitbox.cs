using UnityEngine;

/// <summary>
/// Mob'un melee saldirisinda aktif olan vurma alanini temsil eder.
/// Trigger'a giren IDamageable hedeflere bir kez hasar uygular.
/// </summary>
[RequireComponent(typeof(Collider))]
public class MobAttackHitbox : MonoBehaviour
{
    [SerializeField] private float damage = 15f;

    private MobAIController _owner;
    private bool _hasHitInThisSwing;

    private void Awake()
    {
        // Bu collider mutlaka trigger olmali
        var col = GetComponent<Collider>();
        col.isTrigger = true;

        // Baslangicta kapali olsun
        gameObject.SetActive(false);
    }

    /// <summary>
    /// MobAI tarafindan initialize edilir.
    /// </summary>
    public void Initialize(MobAIController owner, float damageAmount)
    {
        _owner = owner;
        damage = damageAmount;
    }

    /// <summary>
    /// Yeni bir attack swing basladiginda cagrilir.
    /// Bu sayede her swing'de yalnizca bir kez hasar uygulariz.
    /// </summary>
    public void ResetHitFlag()
    {
        _hasHitInThisSwing = false;
    }

    private void OnTriggerEnter(Collider other)
    {
        // Sadece server tarafinda damage uygula
        if (_owner == null || !_owner.IsServer) return;

        if (_hasHitInThisSwing) return;

        // Kendi mob'una vurma
        if (other.GetComponentInParent<MobAIController>() != null)
            return;

        IDamageable damageable = other.GetComponentInParent<IDamageable>();
        if (damageable != null && !damageable.IsDead)
        {
            damageable.TakeDamage(damage, 0);
            _hasHitInThisSwing = true;
        }
    }
}