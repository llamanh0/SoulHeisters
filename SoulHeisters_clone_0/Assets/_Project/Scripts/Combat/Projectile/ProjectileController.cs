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
        if (!IsServer || _hasHit) return;

        Debug.Log($"[Projectile] Trigger hit: {other.name}");

        // Parent zincirini yazdir
        PrintParentChain(other.transform);

        // NetworkObject kontrolu (self-hit sadece player icin)
        NetworkObject netObj = other.GetComponentInParent<NetworkObject>();
        if (netObj != null)
        {
            Debug.Log($"[Projectile] Hit has NetworkObject: {netObj.name}, OwnerId: {netObj.OwnerClientId}");

            var playerRefs = netObj.GetComponent<PlayerReferences>();
            if (playerRefs != null && netObj.OwnerClientId == _ownerId)
            {
                Debug.Log("[Projectile] Hit owner player itself, ignoring.");
                return;
            }
        }

        _hasHit = true;

        // Once interface olarak IDamageable ara
        IDamageable damageable = other.GetComponentInParent<IDamageable>();
        if (damageable != null)
        {
            var mb = damageable as MonoBehaviour;
            Debug.Log($"[Projectile] IDamageable found (type {damageable.GetType().Name}) on object: {mb.gameObject.name}");
            damageable.TakeDamage(_damage, _ownerId);
        }
        else
        {
            // Sonra direkt HealthComponent ara
            var health = other.GetComponentInParent<HealthComponent>();
            if (health != null)
            {
                Debug.Log($"[Projectile] HealthComponent found directly on: {health.gameObject.name}");
                health.TakeDamage(_damage, _ownerId);
            }
            else
            {
                Debug.Log("[Projectile] No IDamageable/HealthComponent found in parents.");
            }
        }

        DestroyProjectile();
    }

    // DEBUG ICIN: parent zincirini yazdir
    private void PrintParentChain(Transform t)
    {
        string chain = t.name;
        Transform p = t.parent;
        while (p != null)
        {
            chain = p.name + " -> " + chain;
            p = p.parent;
        }
        Debug.Log("[Projectile] Parent chain: " + chain);
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