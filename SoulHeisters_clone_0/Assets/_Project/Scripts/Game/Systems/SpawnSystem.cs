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
    private int _nextSpawnIndex = 0;

    /// <summary>
    /// Rastgele bir spawn noktasi doner.
    /// Eger hic spawn noktasi yoksa null doner.
    /// </summary>
    public Transform GetNextSpawnPoint()
    {
        if (spawnPoints == null || spawnPoints.Length == 0)
        {
            return null;
        }

        Transform point = spawnPoints[_nextSpawnIndex];
        _nextSpawnIndex = (_nextSpawnIndex + 1) % spawnPoints.Length;
        return point;
    }
}