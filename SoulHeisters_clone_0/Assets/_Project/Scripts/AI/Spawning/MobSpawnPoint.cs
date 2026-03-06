using UnityEngine;

/// <summary>
/// Sahne uzerinde mob'larin spawn olacagi noktayi temsil eder.
/// 
/// Kullanimi:
/// - Inspector'da mobPrefab alanina spawn edilecek mob prefab'i atanir.
/// - WorldMobManager bu script'i kullanarak mob spawn eder.
/// </summary>
public class MobSpawnPoint : MonoBehaviour
{
    [SerializeField] private GameObject mobPrefab;

    /// <summary> Bu spawn noktasinda kullanilacak mob prefab referansi. </summary>
    public GameObject MobPrefab => mobPrefab;

    /// <summary> Mob'un spawn edilecegi pozisyon ve rotasyon. </summary>
    public Transform SpawnTransform => transform;
}