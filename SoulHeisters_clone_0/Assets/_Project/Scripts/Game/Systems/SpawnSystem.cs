using UnityEngine;

/// <summary>
/// Sahnedeki on tanimli spawn noktalarindan rastgele birini secen basit sistem.
/// 
/// Kullanimi:
/// - spawnPoints dizisine Unity Inspector'dan Transform referanslari verilir.
/// - GetRandomSpawnPoint ile rastgele bir spawn noktasi alinir.
/// </summary>
public class SpawnSystem : MonoBehaviour
{
    [SerializeField] private Transform[] spawnPoints;

    /// <summary>
    /// Rastgele bir spawn noktasi doner.
    /// Eger hic spawn noktasi yoksa null doner.
    /// </summary>
    public Transform GetRandomSpawnPoint()
    {
        if (spawnPoints == null || spawnPoints.Length == 0)
            return null;

        int index = Random.Range(0, spawnPoints.Length);
        return spawnPoints[index];
    }
}