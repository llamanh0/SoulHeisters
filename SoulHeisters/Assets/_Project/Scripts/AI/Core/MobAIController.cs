using System.Collections;
using Unity.Netcode;
using UnityEngine;

public class MobAIController : NetworkBehaviour
{
    [SerializeField] private float aggroRange = 10f;
    [SerializeField] private float moveSpeed = 3f;
    [SerializeField] private float attackRange = 2f;
    [SerializeField] private float attackDamage = 15f;
    [SerializeField] private float attackCooldown = 1.5f;
    [SerializeField] private float attackWindupTime = 0.3f;
    [SerializeField] private float attackLockTime = 0.7f;
    [SerializeField] private float hitboxActiveTime = 0.2f;
    [SerializeField] private float hitStunDuration = 1.1f;
    [SerializeField] private MobAttackHitbox attackHitbox;

    private float _lastAttackTime;
    private float _attackLockEndTime;
    private float _hitStunEndTime;
    private Transform _target;
    private bool _isPerformingSwing;
    private bool _isInHitStun;
    private HealthComponent _health;
    private bool _isDead;
    private Animator _animator;

    private void Awake()
    {
        _health = GetComponent<HealthComponent>();
        _animator = GetComponent<Animator>();
    }

    public override void OnNetworkSpawn()
    {
        if (!IsServer) return;

        if (attackHitbox != null)
        {
            attackHitbox.Initialize(this, attackDamage);
            attackHitbox.gameObject.SetActive(false);
        }

        if (_health != null)
        {
            _health.OnDeath += HandleDeath;
            _health.OnHealthChanged += HandleHealthChanged;
        }
    }

    public override void OnNetworkDespawn()
    {
        if (_health != null)
        {
            _health.OnDeath -= HandleDeath;
            _health.OnHealthChanged -= HandleHealthChanged;
        }
    }

    private void HandleHealthChanged(float oldVal, float newVal)
    {
        if (newVal >= oldVal || _isDead) return;

        _isInHitStun = true;
        _hitStunEndTime = Time.time + hitStunDuration;

        if (_animator != null)
        {
            _animator.SetTrigger("Hit");
            PlayHitAnimationClientRpc();
        }
    }

    private void HandleDeath()
    {
        _isDead = true;
        _target = null;
        StopAllCoroutines();

        if (attackHitbox != null)
            attackHitbox.gameObject.SetActive(false);

        if (_animator != null)
        {
            _animator.SetBool("IsDead", true);
            PlayDeathAnimationClientRpc();
        }
    }

    private void Update()
    {
        if (!IsServer || _isDead) return;

        if (_isInHitStun && Time.time < _hitStunEndTime)
            return;

        _isInHitStun = false;

        if (_target == null)
        {
            FindTarget();
            return;
        }

        HandleChaseAndAttack();
    }

    private void FindTarget()
    {
        foreach (var client in NetworkManager.Singleton.ConnectedClientsList)
        {
            var p = client.PlayerObject;
            if (p == null) continue;

            var health = p.GetComponent<HealthComponent>();
            if (health != null && health.IsDead) continue;

            if (Vector3.Distance(transform.position, p.transform.position) <= aggroRange)
            {
                _target = p.transform;
                break;
            }
        }
    }

    private void HandleChaseAndAttack()
    {
        if (_target == null) return;

        var targetHealth = _target.GetComponent<HealthComponent>();
        if (targetHealth != null && targetHealth.IsDead)
        {
            _target = null;
            return;
        }

        float dist = Vector3.Distance(transform.position, _target.position);

        if (dist > aggroRange * 1.5f)
        {
            _target = null;
            if (_animator != null)
                _animator.SetBool("IsMoving", false);
            return;
        }

        if (_isPerformingSwing || Time.time < _attackLockEndTime)
        {
            FaceTarget();
            return;
        }

        if (dist > attackRange)
            ChaseTarget();
        else
            TryStartAttackSwing();
    }

    private void TryStartAttackSwing()
    {
        if (Time.time < _lastAttackTime + attackCooldown || _target == null) return;

        _lastAttackTime = Time.time;
        _isPerformingSwing = true;

        if (_animator != null)
        {
            _animator.SetBool("IsMoving", false);
            _animator.SetTrigger("Attack");
            PlayAttackAnimationClientRpc();
        }

        StartCoroutine(AttackSwingRoutine());
    }

    private IEnumerator AttackSwingRoutine()
    {
        float w = Time.time + attackWindupTime;
        while (Time.time < w)
        {
            FaceTarget();
            yield return null;
        }

        if (attackHitbox != null)
        {
            attackHitbox.ResetHitFlag();
            attackHitbox.gameObject.SetActive(true);
            SetHitboxActiveClientRpc(true);
        }

        float h = Time.time + hitboxActiveTime;
        while (Time.time < h)
        {
            FaceTarget();
            yield return null;
        }

        if (attackHitbox != null)
        {
            attackHitbox.gameObject.SetActive(false);
            SetHitboxActiveClientRpc(false);
        }

        _attackLockEndTime = Time.time + attackLockTime;
        _isPerformingSwing = false;
    }

    private void ChaseTarget()
    {
        if (_target == null) return;

        Vector3 dir = (_target.position - transform.position).normalized;
        dir.y = 0f;
        transform.position += dir * moveSpeed * Time.deltaTime;

        if (_animator != null)
            _animator.SetBool("IsMoving", true);

        if (dir != Vector3.zero)
            transform.rotation = Quaternion.Slerp(transform.rotation, Quaternion.LookRotation(dir), Time.deltaTime * 10f);
    }

    private void FaceTarget()
    {
        if (_target == null) return;

        Vector3 dir = (_target.position - transform.position).normalized;
        dir.y = 0f;

        if (dir != Vector3.zero)
            transform.rotation = Quaternion.Slerp(transform.rotation, Quaternion.LookRotation(dir), Time.deltaTime * 10f);
    }

    [ClientRpc]
    private void SetHitboxActiveClientRpc(bool isActive)
    {
        if (attackHitbox != null)
            attackHitbox.gameObject.SetActive(isActive);
    }

    [ClientRpc]
    private void PlayAttackAnimationClientRpc()
    {
        if (_animator != null)
            _animator.SetTrigger("Attack");
    }

    [ClientRpc]
    private void PlayHitAnimationClientRpc()
    {
        if (_animator != null)
            _animator.SetTrigger("Hit");
    }

    [ClientRpc]
    private void PlayDeathAnimationClientRpc()
    {
        if (_animator != null)
            _animator.SetBool("IsDead", true);
    }

    public void SetMobStats(float speed, float range, float damage, float cooldown, float aggro)
    {
        moveSpeed = speed;
        attackRange = range;
        attackDamage = damage;
        attackCooldown = cooldown;
        aggroRange = aggro;

        if (attackHitbox != null)
            attackHitbox.Initialize(this, damage);
    }
}