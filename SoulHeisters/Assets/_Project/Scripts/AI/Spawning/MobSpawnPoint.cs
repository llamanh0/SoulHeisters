using UnityEngine;

public class MobSpawnPoint : MonoBehaviour
{
    [SerializeField] private GameObject mobPrefab;

    public GameObject MobPrefab => mobPrefab;

    public Transform SpawnTransform => transform;
}