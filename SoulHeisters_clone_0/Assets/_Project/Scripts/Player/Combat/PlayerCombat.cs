using System.Collections;
using Unity.Netcode;
using Unity.Netcode.Components;
using UnityEngine;

/// <summary>
/// Oyuncunun tum combat/spell atesleme islerini yonetir.
/// 
/// Sorumluluklar:
/// - Input tarafindan tetiklenen spell cast isteklerini calistirmak
/// - Spell'lere mana ve cooldown kontrolunu birakmak
/// - ServerRpc ile server uzerinde gercek spell etkisini olusturmak
/// - ClientRpc ile tum client'lara VFX oynatmak
/// 
/// Network Notlari:
/// - Otorite her zaman owner player'dadir (input sadece owner tarafindan okunur).
/// - Hasar ve mana tuketimi sadece server tarafinda yapilir.
/// </summary>
public class PlayerCombat : NetworkBehaviour
{
    [SerializeField] private Transform firePoint;
    public Transform FirePoint => firePoint;

    [Header("VFXs")]
    [SerializeField] private GameObject boltVFX;
    [SerializeField] private GameObject blinkVFX;
    [SerializeField] private GameObject arcBurstVFX;
    [SerializeField] private GameObject soulGuardVFX;

    [Header("Server Prefab")]
    [SerializeField] private GameObject boltServerPrefab;

    private PlayerReferences _refs;

    private void Awake()
    {
        _refs = GetComponent<PlayerReferences>();
    }

    private void Update()
    {
        // Yalnizca owner olan client, input okuyup spell cast istegi yapabilir
        if (!IsOwner) return;

        // Fire tusuna basili ise mevcut spell'i dene
        if (_refs.Input.FireInput)
        {
            var spell = _refs.SpellInventory.CurrentSpell;
            if (spell == null) return;

            var result = spell.TryCast();

            // UI icin cast sonucunu bildir (yetersiz mana vs.)
            _refs.SpellInventory.HandleCastResult(result);
        }
    }

    /// <summary>
    /// Bolt spell'inin client tarafindaki giris noktasi.
    /// Hedef noktayi hesaplar ve server'a gonderir.
    /// </summary>
    public void ExecuteBolt()
    {
        var def = _refs.SpellInventory.FindSpellDefinition(SpellType.Bolt);
        if (def == null) return;

        Vector3 targetPoint = GetCrosshairHitPoint();

        CastBoltServerRpc(
            targetPoint,
            def.manaCost,
            def.damage,
            def.projectileSpeed);
    }

    #region Server

    /// <summary>
    /// Bolt spell'inin server tarafinda gercek cast islemi.
    /// - Mana kontrolu yapar
    /// - Server'da mermi prefab'ini spawn eder
    /// - Hasari belirler
    /// - Tum client'lara VFX icin RPC gonderir
    /// </summary>
    [ServerRpc]
    public void CastBoltServerRpc(Vector3 targetPoint, float manaCost, float damage, float projectileSpeed)
    {
        // Sadece server mana tuketebilir
        if (!_refs.Mana.TryConsume(manaCost))
            return;

        Vector3 direction = (targetPoint - firePoint.position).normalized;
        Quaternion rotation = Quaternion.LookRotation(direction);

        // Server uzerinde fiziksel mermi objesini olustur
        GameObject serverObj = Instantiate(boltServerPrefab, firePoint.position, rotation);
        var projectile = serverObj.GetComponent<ProjectileController>();
        projectile.Initialize(direction, projectileSpeed, damage, OwnerClientId);

        serverObj.GetComponent<NetworkObject>().Spawn();

        // Tum client'lara sadece gorsel mermi spawn etmeleri icin bilgi gonder
        CastBoltClientRpc(
            firePoint.position,
            rotation,
            direction,
            projectileSpeed);
    }

    /// <summary>
    /// Tum client'larda bolt spell'inin gorsel efektini olusturur.
    /// Buradaki obje sadece VFX icin kullanilir, hasar server mermisinden gelir.
    /// </summary>
    [ClientRpc]
    private void CastBoltClientRpc(Vector3 pos, Quaternion rot, Vector3 dir, float projectileSpeed)
    {
        GameObject visualObj = Instantiate(boltVFX, pos, rot);

        if (visualObj.TryGetComponent<Rigidbody>(out var rb))
        {
            rb.velocity = dir * projectileSpeed;
        }

        Destroy(visualObj, 5f);
    }

    /// <summary>
    /// Blink spell'inin server tarafinda calisan kismi.
    /// - Mana kontrolu
    /// - Onaylanan hedef konumu owner client'a bildirme
    /// - Tum client'lara VFX gonderme
    /// </summary>
    [ServerRpc]
    public void CastBlinkServerRpc(Vector3 targetPosition, float manaCost)
    {
        if (!_refs.Mana.TryConsume(manaCost))
            return;

        // Sadece owner client blink pozisyonunu gercekten uygular
        ApproveBlinkClientRpc(targetPosition, OwnerClientId);

        // Tum client'lara blink VFX gonder
        BlinkVFXClientRpc(targetPosition);
    }

    /// <summary>
    /// Sadece hedef owner client'ta, karakterin pozisyonunu
    /// NetworkTransform.Teleport ile yeni noktaya tasir.
    /// </summary>
    [ClientRpc]
    private void ApproveBlinkClientRpc(Vector3 targetPosition, ulong ownerId)
    {
        // Bu RPC her client'ta calisir;
        // fakat sadece ilgili owner karakterini hareket ettirmeliyiz
        if (NetworkManager.Singleton.LocalClientId != ownerId)
            return;

        var netTransform = GetComponent<NetworkTransform>();
        if (netTransform != null)
        {
            netTransform.Teleport(
                targetPosition,
                transform.rotation,
                transform.localScale);
        }

        // CharacterController'i resetleyerek fiziksel takilmalarin onune gec
        var controller = GetComponent<CharacterController>();
        if (controller != null)
        {
            controller.enabled = false;
            controller.enabled = true;
        }

        _refs.Locomotion.ResetVerticalVelocity();
    }

    [ClientRpc]
    private void BlinkVFXClientRpc(Vector3 position)
    {
        Instantiate(blinkVFX, position, Quaternion.identity);
    }

    /// <summary>
    /// ArcBurst spell'inin server tarafinda calisan AoE hasar islemi.
    /// - Mana kontrolu
    /// - Sphere overlap ile cevredeki IDamageable objelere hasar
    /// </summary>
    [ServerRpc]
    public void CastArcBurstServerRpc(float radius, float damage, float manaCost)
    {
        if (!_refs.Mana.TryConsume(manaCost))
            return;

        Collider[] hits = Physics.OverlapSphere(transform.position, radius);

        foreach (var hit in hits)
        {
            // NetworkObject varsa, owner ile ayniysa kendimizi atla
            if (hit.TryGetComponent<NetworkObject>(out var netObj))
            {
                if (netObj.OwnerClientId == OwnerClientId)
                    continue;
            }

            // IDamageable interface'ine sahip olanlara hasar uygula
            if (hit.TryGetComponent<IDamageable>(out var dmg))
            {
                dmg.TakeDamage(damage, OwnerClientId);
            }
        }

        ArcBurstVFXClientRpc();
    }

    [ClientRpc]
    private void ArcBurstVFXClientRpc()
    {
        // VFX'i karakterin altina dogru biraz offset vererek spawn et
        Instantiate(arcBurstVFX, transform.position - new Vector3(0f, 7f, 0f), Quaternion.identity);
    }

    /// <summary>
    /// SoulGuard spell'inin server tarafinda calisan kismi.
    /// - Mana kontrolu
    /// - Belirli sure boyunca damage reduction uygular
    /// - Tum client'lara VFX bildirir
    /// </summary>
    [ServerRpc]
    public void CastSoulGuardServerRpc(float duration, float damageReduction, float manaCost)
    {
        if (!_refs.Mana.TryConsume(manaCost))
            return;

        StartCoroutine(ApplyDamageReduction(duration, damageReduction));
        SoulGuardVFXClientRpc(duration);
    }

    [ClientRpc]
    private void SoulGuardVFXClientRpc(float duration)
    {
        StartCoroutine(nameof(WaitForSoulGuardDuration), duration);
    }

    #endregion

    #region IEnumerator

    /// <summary>
    /// SoulGuard VFX'ini belirli bir sure aktif tutar.
    /// Bu coroutine tum client'larda calisir.
    /// </summary>
    private IEnumerator WaitForSoulGuardDuration(float duration)
    {
        soulGuardVFX.SetActive(true);
        yield return new WaitForSeconds(duration);
        soulGuardVFX.SetActive(false);
    }

    /// <summary>
    /// Server tarafinda damage reduction yuzdesini belirli sure uygular.
    /// </summary>
    private IEnumerator ApplyDamageReduction(float duration, float reduction)
    {
        _refs.Health.SetDamageReduction(reduction);

        yield return new WaitForSeconds(duration);

        _refs.Health.SetDamageReduction(0f);
    }

    #endregion

    #region Helper

    /// <summary>
    /// Ekranin ortasindan bir ray atarak hedef noktayi hesaplar.
    /// Eger bir seye carpmazsa, sabit bir mesafede nokta kullanilir.
    /// </summary>
    private Vector3 GetCrosshairHitPoint()
    {
        Camera cam = Camera.main;
        Ray ray = cam.ViewportPointToRay(new Vector3(0.5f, 0.5f));

        if (Physics.Raycast(ray, out RaycastHit hit, 1000f))
            return hit.point;

        return ray.GetPoint(100f);
    }

    #endregion
}