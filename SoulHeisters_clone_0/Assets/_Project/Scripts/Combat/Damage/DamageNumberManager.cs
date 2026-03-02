using UnityEngine;

public class DamageNumberManager : MonoBehaviour
{
    public static DamageNumberManager Instance;

    [SerializeField] private GameObject damageNumberPrefab;

    private void Awake()
    {
        Instance = this;
    }

    public void SpawnDamageNumber(Vector3 worldPos, float damage)
    {
        GameObject obj =
            Instantiate(damageNumberPrefab, worldPos, Quaternion.identity);

        obj.GetComponent<DamageNumber>().Setup(damage);
    }
}