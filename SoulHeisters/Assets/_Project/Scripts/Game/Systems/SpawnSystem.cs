using UnityEngine;

public class SpawnSystem : MonoBehaviour
{
    [SerializeField] private Transform[] spawnPoints;
    private int _nextSpawnIndex = 0;

    private void OnDrawGizmos()
    {
        if (spawnPoints == null) return;

        for (int i = 0; i < spawnPoints.Length; i++)
        {
            if (spawnPoints[i] == null) continue;

            Gizmos.color = Color.green;
            Gizmos.DrawWireSphere(spawnPoints[i].position, 0.5f);
            UnityEditor.Handles.Label(spawnPoints[i].position + Vector3.up, $"Spawn {i}");
        }
    }

    public Transform GetNextSpawnPoint()
    {
        if (spawnPoints == null || spawnPoints.Length == 0)
        {
            Debug.LogError("[SpawnSystem] No spawn points assigned!");
            return null;
        }

        if (spawnPoints[_nextSpawnIndex] == null)
        {
            Debug.LogError($"[SpawnSystem] Spawn point {_nextSpawnIndex} is null!");
            return null;
        }

        Transform point = spawnPoints[_nextSpawnIndex];
        Debug.Log($"[SpawnSystem] Returning spawn point {_nextSpawnIndex}: {point.position}");

        _nextSpawnIndex = (_nextSpawnIndex + 1) % spawnPoints.Length;
        return point;
    }
}