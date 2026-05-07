using Unity.Netcode.Components;
using UnityEngine;

/// <summary>
/// Client-authoritative animator
/// Client kendi animasyonlarini kontrol eder, server'a gonderir
/// </summary>
[RequireComponent(typeof(Animator))]
public class ClientNetworkAnimator : NetworkAnimator
{
    [Header("Sync Settings")]
    [Tooltip("Animator parametreleri ne siklikla sync edilsin (saniye)")]
    [SerializeField] private float syncInterval = 0.1f;

    private float _lastSyncTime;

    protected override bool OnIsServerAuthoritative()
    {
        return false; // Client kontrol eder
    }

    private void Update()
    {
        // Sadece owner client parametreleri guncellesin
        if (!IsOwner) return;

        // Belirli araliklarla sync et (her frame degil)
        if (Time.time - _lastSyncTime >= syncInterval)
        {
            _lastSyncTime = Time.time;
            SyncAnimatorParameters();
        }
    }

    private void SyncAnimatorParameters()
    {
        // Animator parametrelerini manuel sync et
        // Bunu NetworkAnimator otomatik yapar ama rate limit gerekebilir
    }
}