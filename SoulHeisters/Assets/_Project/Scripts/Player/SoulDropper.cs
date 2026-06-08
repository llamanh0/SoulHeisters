using Unity.Netcode;
using UnityEngine;
using System.Collections.Generic;

public class SoulDropper : NetworkBehaviour
{
    [SerializeField] private List<GameObject> soulPickupPrefabs = new();
    [SerializeField] private int soulDropAmount = 1;
    [SerializeField] private float dropForce = 8f;
    [SerializeField] private float dropRadius = 1.5f;
    [SerializeField] private float dropHeight = 1f;
    [SerializeField] private SoulAudioLibrary audioLibrary;

    private HealthComponent _health;
    private SoulComponent _soulComponent;
    private bool _isPlayer;

    private void Awake()
    {
        _health = GetComponent<HealthComponent>();
        _soulComponent = GetComponent<SoulComponent>();
        _isPlayer = GetComponent<PlayerReferences>() != null;
    }

    public override void OnNetworkSpawn()
    {
        if (!IsServer) return;

        if (_health != null)
        {
            _health.OnDeath += HandleDeath;
        }
    }

    public override void OnNetworkDespawn()
    {
        if (_health != null)
            _health.OnDeath -= HandleDeath;
    }

    private void HandleDeath()
    {
        if (!IsServer) return;

        if (soulPickupPrefabs == null || soulPickupPrefabs.Count == 0)
            return;

        int dropCount = soulDropAmount;

        if (_isPlayer && _soulComponent != null)
        {
            int currentSouls = _soulComponent.SoulCount.Value;
            dropCount = Mathf.FloorToInt(currentSouls * 0.5f);
            int remainingSouls = currentSouls - dropCount;
            _soulComponent.SoulCount.Value = remainingSouls;
        }

        if (dropCount <= 0)
            return;

        Vector3 dropPosition = transform.position + Vector3.up * dropHeight;

        for (int i = 0; i < dropCount; i++)
        {
            GameObject prefabToUse = soulPickupPrefabs[Random.Range(0, soulPickupPrefabs.Count)];

            float angle = (360f / dropCount) * i;
            float randomAngleOffset = Random.Range(-15f, 15f);
            angle += randomAngleOffset;

            float radian = angle * Mathf.Deg2Rad;
            float randomRadius = Random.Range(0.5f, dropRadius);

            Vector3 direction = new Vector3(
                Mathf.Cos(radian) * randomRadius,
                Random.Range(0.8f, 1.2f),
                Mathf.Sin(radian) * randomRadius
            ).normalized;

            var soul = Instantiate(prefabToUse, dropPosition, Quaternion.identity);

            var rb = soul.GetComponent<Rigidbody>();
            if (rb != null)
            {
                rb.isKinematic = false;
                rb.useGravity = true;
                rb.AddForce(direction * dropForce, ForceMode.Impulse);
            }

            if (audioLibrary != null)
            {
                var pickup = soul.GetComponent<SoulPickup>();
                if (pickup != null)
                {
                    var dropSound = audioLibrary.GetRandomDropSound();
                    var collectSound = audioLibrary.GetRandomCollectSound();
                    pickup.SetAudioClips(dropSound, collectSound);
                }
            }

            var netObj = soul.GetComponent<NetworkObject>();
            if (netObj != null)
            {
                netObj.Spawn();
            }
        }
    }

    public void SetDropAmount(int amount)
    {
        soulDropAmount = amount;
    }

    public void SetSoulPrefabs(List<GameObject> prefabs)
    {
        soulPickupPrefabs = prefabs;
    }

    public void SetAudioLibrary(SoulAudioLibrary library)
    {
        audioLibrary = library;
    }
}