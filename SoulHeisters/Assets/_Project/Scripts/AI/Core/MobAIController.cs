using Unity.Netcode;
using UnityEngine;

/// <summary>
/// Basit server-side mob AI:
/// - Belirli bir mesafede oyuncuyu fark eder (aggro)
/// - Hedefe dogru kosar
/// - Attack menziline girdiginde durur:
///     * Kisa bir "windup" suresi boyunca bekler
///     * Onundeki hitbox'i kisa bir pencere icin aktif eder
///     * Hitbox'a giren IDamageable hedeflere hasar verir
///     * Ardindan kisa bir "recovery/lock" suresi boyunca yerinde kalir
/// 
/// Not:
/// - Tum mantik sadece server tarafinda calisir.
/// - Client'lar sadece sonuclari gorur (NetworkTransform, health degisimi vs.).
/// - Simdilik animasyon yok; sadece hareket + hitbox tabanli damage logic var.
/// </summary>
public class MobAIController : NetworkBehaviour
{
    [Header("Detection")]
    [Tooltip("Mob'un oyuncuyu fark edecegi maksimum mesafe.")]
    [SerializeField] private float aggroRange = 10f;

    [Header("Movement")]
    [Tooltip("Hareket hizi (saniyede birim).")]
    [SerializeField] private float moveSpeed = 3f;

    [Header("Attack")]
    [Tooltip("Hedef bu mesafeye girdiginde mob saldiri yapabilir.")]
    [SerializeField] private float attackRange = 2f;

    [Tooltip("Tek bir saldirinin verdigi hasar.")]
    [SerializeField] private float attackDamage = 15f;

    [Tooltip("Iki saldiri arasindaki minimum sure (saniye).")]
    [SerializeField] private float attackCooldown = 1.5f;

    [Tooltip("Vurmadan onceki bekleme (windup) suresi (saniye).")]
    [SerializeField] private float attackWindupTime = 0.3f;

    [Tooltip("Saldiri yaptiktan sonra yerinde bekleyecegi recovery/lock suresi (saniye).")]
    [SerializeField] private float attackLockTime = 0.7f;

    [Header("Attack Hitbox")]
    [Tooltip("Mob prefabinin icindeki AttackHitbox objesi.")]
    [SerializeField] private MobAttackHitbox attackHitbox;

    [Tooltip("Hitbox'in aktif kalacagi vurus penceresi suresi (saniye).")]
    [SerializeField] private float hitboxActiveTime = 0.2f;

    /// <summary> Saldiri cooldown'u icin son yapilan saldirinin zamani. </summary>
    private float _lastAttackTime;

    /// <summary> Saldiri recovery/lock suresinin bitecegi zaman. </summary>
    private float _attackLockEndTime;

    /// <summary> Mob'un su anki hedef oyuncusu. </summary>
    private Transform _target;

    /// <summary> Su anda bir attack swing (windup + hitbox) icinde miyiz? </summary>
    private bool _isPerformingSwing;

    public override void OnNetworkSpawn()
    {
        if (!IsServer) return;

        // Attack hitbox'i initialize et ve baslangicta kapali tut
        if (attackHitbox != null)
        {
            attackHitbox.Initialize(this, attackDamage);
            attackHitbox.gameObject.SetActive(false);
        }
    }

    private void Update()
    {
        // AI sadece server tarafinda calismali
        if (!IsServer) return;

        if (_target == null)
        {
            FindTarget();
            return;
        }

        HandleChaseAndAttack();
    }

    /// <summary>
    /// AggroRange icindeki ilk PlayerObject'i hedef olarak secer.
    /// </summary>
    private void FindTarget()
    {
        foreach (var client in NetworkManager.Singleton.ConnectedClientsList)
        {
            var playerObject = client.PlayerObject;
            if (playerObject == null) continue;

            float dist = Vector3.Distance(transform.position, playerObject.transform.position);
            if (dist <= aggroRange)
            {
                _target = playerObject.transform;
                break;
            }
        }
    }

    /// <summary>
    /// Hedef varken chase/attack kararini verir.
    /// </summary>
    private void HandleChaseAndAttack()
    {
        if (_target == null) return;

        float dist = Vector3.Distance(transform.position, _target.position);

        // Hedef aggro menzilinden cok uzaklastiysa unut
        if (dist > aggroRange * 1.5f)
        {
            _target = null;
            return;
        }

        // Mevcut attack swing veya recovery/lock suresi icindeysek:
        if (_isPerformingSwing || Time.time < _attackLockEndTime)
        {
            FaceTarget();
            return;
        }

        if (dist > attackRange)
        {
            // Menzil disinda → chase
            ChaseTarget();
        }
        else
        {
            // Menzil icinde → attack swing baslat
            TryStartAttackSwing();
        }
    }

    /// <summary>
    /// Cooldown uygunsa yeni bir attack swing baslatir:
    /// windup → hitbox penceresi → recovery.
    /// </summary>
    private void TryStartAttackSwing()
    {
        if (Time.time < _lastAttackTime + attackCooldown)
            return;

        if (_target == null) return;

        _lastAttackTime = Time.time;
        _isPerformingSwing = true;

        StartCoroutine(AttackSwingRoutine());
    }

    /// <summary>
    /// Attack'in tam akisini yoneten coroutine:
    /// 1) Windup: vurmadan once bekle
    /// 2) Hitbox: kisa sure onunde vurma alani ac
    /// 3) Lock: toparlanma suresi boyunca yerinde bekle
    /// </summary>
    private System.Collections.IEnumerator AttackSwingRoutine()
    {
        // 1) WINDUP — vurmadan once bekle, sadece hedefe bak
        float windupEndTime = Time.time + attackWindupTime;
        while (Time.time < windupEndTime)
        {
            FaceTarget();
            yield return null;
        }

        // 2) HITBOX PENCERESI — belirli sure hitbox'i ac
        if (attackHitbox != null)
        {
            attackHitbox.ResetHitFlag();
            attackHitbox.gameObject.SetActive(true);
        }

        float hitboxEndTime = Time.time + hitboxActiveTime;
        while (Time.time < hitboxEndTime)
        {
            FaceTarget();
            yield return null;
        }

        if (attackHitbox != null)
        {
            attackHitbox.gameObject.SetActive(false);
        }

        // 3) RECOVERY / LOCK — vurduktan sonra hareket kilidi
        _attackLockEndTime = Time.time + attackLockTime;

        _isPerformingSwing = false;
    }

    /// <summary>
    /// Hedefe dogru sabit hizla kosar ve hedefe dogru bakar.
    /// </summary>
    private void ChaseTarget()
    {
        if (_target == null) return;

        Vector3 dir = (_target.position - transform.position).normalized;
        dir.y = 0f;

        transform.position += dir * moveSpeed * Time.deltaTime;

        if (dir != Vector3.zero)
        {
            Quaternion targetRot = Quaternion.LookRotation(dir);
            transform.rotation = Quaternion.Slerp(
                transform.rotation,
                targetRot,
                Time.deltaTime * 10f);
        }
    }

    /// <summary>
    /// Yalnizca hedefe dogru donus yapar, hareket ettirmez.
    /// </summary>
    private void FaceTarget()
    {
        if (_target == null) return;

        Vector3 dir = (_target.position - transform.position).normalized;
        dir.y = 0f;

        if (dir != Vector3.zero)
        {
            Quaternion targetRot = Quaternion.LookRotation(dir);
            transform.rotation = Quaternion.Slerp(
                transform.rotation,
                targetRot,
                Time.deltaTime * 10f);
        }
    }
}