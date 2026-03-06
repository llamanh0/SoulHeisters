using Unity.Netcode;
using UnityEngine;

/// <summary>
/// Server tarafli calisan basit mermi kontrolu.
/// 
/// Sorumluluklar:
/// - Mermiye hiz ve yon vermek
/// - Omru doldugunda kendini yok etmek
/// - Carpma aninda IDamageable arayuzu uzerinden hasar uygulamak
/// - Sahibini (owner) vurmayi engellemek
/// 
/// Notlar:
/// - Mermi logic'i sadece server tarafinda calisir (OnTriggerEnter icinde IsServer kontrolu).
/// - Client'lar sadece gorsel VFX mermisini gorur (PlayerCombat tarafinda).
/// </summary>
[RequireComponent(typeof(Rigidbody))]
public class ProjectileController : NetworkBehaviour
{
    [SerializeField] private float lifeTime = 5f;

    private Rigidbody _rb;
    private float _damage;
    private ulong _ownerId;
    private bool _hasHit = false;

    private void Awake()
    {
        _rb = GetComponent<Rigidbody>();
    }

    /// <summary>
    /// Mermi ilk olusturuldugunda cagirilir.
    /// Yon, hiz, hasar miktari ve sahibi burada atanir.
    /// </summary>
    public void Initialize(Vector3 direction, float speed, float damageAmount, ulong ownerId)
    {
        _damage = damageAmount;
        _ownerId = ownerId;
        _hasHit = false;

        // Baslangic hizi ver
        _rb.velocity = direction * speed;

        // Belirli bir sure sonra mermiyi otomatik yok et
        Invoke(nameof(DestroyProjectile), lifeTime);
    }

    private void OnTriggerEnter(Collider other)
    {
        // Hasar ve carpma islemleri sadece server tarafinda calismali
        if (!IsServer || _hasHit) return;

        // Vurulan objede NetworkObject var mi kontrol et
        NetworkObject netObj = other.GetComponentInParent<NetworkObject>();
        if (netObj != null)
        {
            // Sahibini vurma (self damage'i engellemek icin)
            if (netObj.OwnerClientId == _ownerId) return;
        }

        _hasHit = true;

        // IDamageable arayuzune sahip bir component bul ve hasar uygula
        IDamageable damageable = other.GetComponentInParent<IDamageable>();
        if (damageable != null)
        {
            damageable.TakeDamage(_damage, _ownerId);
        }

        DestroyProjectile();
    }

    /// <summary>
    /// NetworkObject spawn olduysa onu despawn eder.
    /// </summary>
    private void DestroyProjectile()
    {
        if (NetworkObject != null && NetworkObject.IsSpawned)
        {
            NetworkObject.Despawn(true);
        }
    }
}