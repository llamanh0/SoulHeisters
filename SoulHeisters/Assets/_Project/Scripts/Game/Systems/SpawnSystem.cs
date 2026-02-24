using UnityEngine;

public class SpawnSystem : MonoBehaviour
{
    [SerializeField] private Transform[] spawnPoints;

    public Transform GetRandomSpawnPoint()
    {
        if (spawnPoints.Length == 0) { return null; }

        int index = Random.Range(0, spawnPoints.Length);
        return spawnPoints[index];
    }
}