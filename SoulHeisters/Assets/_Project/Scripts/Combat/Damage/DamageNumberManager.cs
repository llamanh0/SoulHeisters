using UnityEngine;

/// <summary>
/// Hasar sayilarini olusturmak icin basit singleton manager.
/// 
/// Kullanimi:
/// - DamageNumberManager.Instance.SpawnDamageNumber(worldPos, damage);
/// </summary>
public class DamageNumberManager : MonoBehaviour
{
    public static DamageNumberManager Instance;

    [SerializeField] private GameObject damageNumberPrefab;

    private void Awake()
    {
        // Basit singleton atamasi, sahnede tek oldugu varsayiliyor
        Instance = this;
    }

    /// <summary>
    /// Verilen world pozisyonunda bir DamageNumber olusturur.
    /// </summary>
    public void SpawnDamageNumber(Vector3 worldPos, float damage)
    {
        if (damageNumberPrefab == null) return;

        GameObject obj = Instantiate(damageNumberPrefab, worldPos, Quaternion.identity);

        if (obj.TryGetComponent<DamageNumber>(out var dmgNumber))
        {
            dmgNumber.Setup(damage);
        }
    }
}