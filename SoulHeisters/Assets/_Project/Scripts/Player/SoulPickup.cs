using Unity.Netcode;
using UnityEngine;
using DG.Tweening;
using System.Collections.Generic;

public class SoulPickup : NetworkBehaviour
{
    [SerializeField] private int soulAmount = 1;
    [SerializeField] private float magnetRange = 5f;
    [SerializeField] private float magnetSpeed = 10f;
    [SerializeField] private float rotateSpeed = 180f;
    [SerializeField] private float floatAmount = 0.3f;
    [SerializeField] private float floatSpeed = 2f;
    [SerializeField] private float targetHeightOffset = 1.5f;
    [SerializeField] private float respawnIgnoreDuration = 2f;
    [SerializeField] private AudioClip dropSound;
    [SerializeField] private AudioClip collectSound;
    [SerializeField] private float dropSoundVolume = 0.5f;
    [SerializeField] private float collectSoundVolume = 0.7f;

    private Transform _target;
    private bool _isBeingCollected;
    private bool _isMagnetActive;
    private Tweener _floatTween;
    private Rigidbody _rb;
    private static HashSet<ulong> _recentlyRespawnedPlayers = new();

    private void Awake()
    {
        _rb = GetComponent<Rigidbody>();
        var col = GetComponent<Collider>();
        if (col != null)
            col.isTrigger = true;
    }

    public override void OnNetworkSpawn()
    {
        if (IsServer)
        {
            Invoke(nameof(StartFloating), 0.6f);
        }

        DisableParticleShapeEmission();

        if (dropSound != null)
            AudioSource.PlayClipAtPoint(dropSound, transform.position, dropSoundVolume);
    }

    private void DisableParticleShapeEmission()
    {
        var particles = GetComponentsInChildren<ParticleSystem>();
        foreach (var ps in particles)
        {
            var shape = ps.shape;
            if (shape.shapeType == ParticleSystemShapeType.Mesh ||
                shape.shapeType == ParticleSystemShapeType.MeshRenderer ||
                shape.shapeType == ParticleSystemShapeType.SkinnedMeshRenderer)
            {
                shape.shapeType = ParticleSystemShapeType.Sphere;
                shape.radius = 0.1f;
            }
        }
    }

    private void StartFloating()
    {
        if (_rb != null)
        {
            _rb.linearVelocity = Vector3.zero;
            _rb.angularVelocity = Vector3.zero;
            _rb.isKinematic = true;
            _rb.useGravity = false;
        }

        _floatTween = transform.DOMoveY(transform.position.y + floatAmount, 1f / floatSpeed)
            .SetEase(Ease.InOutSine)
            .SetLoops(-1, LoopType.Yoyo);
    }

    private void OnDestroy()
    {
        _floatTween?.Kill();
        transform.DOKill();
    }

    private void Update()
    {
        transform.Rotate(Vector3.up, rotateSpeed * Time.deltaTime);

        if (!IsServer || _isBeingCollected) return;

        if (_target != null)
        {
            var playerHealth = _target.GetComponent<HealthComponent>();
            if (playerHealth != null && playerHealth.IsDead)
            {
                _target = null;
                _isMagnetActive = false;
                return;
            }

            if (!_isMagnetActive)
            {
                _isMagnetActive = true;
                _floatTween?.Kill();
            }

            Vector3 targetPos = _target.position + Vector3.up * targetHeightOffset;
            transform.position = Vector3.MoveTowards(transform.position, targetPos, magnetSpeed * Time.deltaTime);
            return;
        }

        foreach (var client in NetworkManager.Singleton.ConnectedClientsList)
        {
            var player = client.PlayerObject;
            if (player == null) continue;

            if (_recentlyRespawnedPlayers.Contains(client.ClientId))
                continue;

            var health = player.GetComponent<HealthComponent>();
            if (health != null && health.IsDead) continue;

            float dist = Vector3.Distance(transform.position, player.transform.position);

            if (dist <= magnetRange && _target == null)
            {
                _target = player.transform;
                break;
            }
        }
    }

    private void OnTriggerEnter(Collider other)
    {
        if (!IsServer || _isBeingCollected) return;

        var player = other.GetComponentInParent<PlayerReferences>();
        if (player != null)
        {
            var soul = player.GetComponent<SoulComponent>();
            var health = player.GetComponent<HealthComponent>();

            if (soul != null && health != null && !health.IsDead)
            {
                _isBeingCollected = true;
                soul.AddSoulServerRpc(soulAmount);
                _floatTween?.Kill();

                PlayCollectSoundClientRpc(transform.position);

                if (NetworkObject != null && NetworkObject.IsSpawned)
                    NetworkObject.Despawn(true);
            }
        }
    }

    [ClientRpc]
    private void PlayCollectSoundClientRpc(Vector3 pos)
    {
        if (collectSound != null)
            AudioSource.PlayClipAtPoint(collectSound, pos, collectSoundVolume);
    }

    public void SetSoulAmount(int amount)
    {
        soulAmount = amount;
    }

    public void SetAudioClips(AudioClip drop, AudioClip collect)
    {
        dropSound = drop;
        collectSound = collect;
    }

    public static void MarkPlayerAsRespawned(ulong clientId, float duration)
    {
        _recentlyRespawnedPlayers.Add(clientId);
    }

    public static void ClearRespawnedPlayer(ulong clientId)
    {
        _recentlyRespawnedPlayers.Remove(clientId);
    }
}