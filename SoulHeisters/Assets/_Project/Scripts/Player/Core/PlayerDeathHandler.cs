using Cinemachine;
using Unity.Netcode;
using UnityEngine;

/// <summary>
/// Oyuncu oldugunde kamera ve kontrol davranislarini yonetir.
/// 
/// Sorumluluklar:
/// - HealthComponent.OnDeath event'ine abone olmak
/// - Olumde hareket/combat gibi script'leri devre disi birakmak
/// - Local owner icin "death camera" sanal kamerasini aktif etmek
/// </summary>
public class PlayerDeathHandler : NetworkBehaviour
{
    [Header("Camera Settings")]
    [Tooltip("Oyuncu oldugunde devreye girecek kamera")]
    [SerializeField] private CinemachineVirtualCamera deathCamera;

    [Header("Scripts to Disable")]
    [SerializeField] private MonoBehaviour[] scriptsToDisable;

    private PlayerReferences _refs;

    private void Awake()
    {
        _refs = GetComponent<PlayerReferences>();
        if (_refs == null)
            Debug.LogError("[PlayerDeathHandler] PlayerReferences bulunamadi!");
    }

    public override void OnNetworkSpawn()
    {
        if (_refs.Health != null)
        {
            _refs.Health.OnDeath += HandleDeath;
        }

        // Death camera sadece local owner icin aktif olmali
        if (deathCamera != null)
        {
            deathCamera.gameObject.SetActive(IsOwner);

            if (IsOwner)
            {
                // Baslangicta normal oyun kamerasindan daha dusuk oncelik
                deathCamera.Priority = 5;
            }
        }
    }

    public override void OnNetworkDespawn()
    {
        if (_refs.Health != null)
        {
            _refs.Health.OnDeath -= HandleDeath;
        }
    }

    /// <summary>
    /// Oyuncu oldugunde cagrilir.
    /// - Gorsel olum animasyonu / ragdoll
    /// - Hareket ve combat gibi script'leri kapatma
    /// - Death camera'yi aktif etme
    /// </summary>
    private void HandleDeath()
    {
        // Gorsel olum
        _refs.Visual.HandleDeathVisual();

        // Hareket, combat vb. script'leri devre disi birak
        foreach (var script in scriptsToDisable)
        {
            if (script != null)
                script.enabled = false;
        }

        // Owner icin death kamera devreye girsin
        if (IsOwner && deathCamera != null)
        {
            deathCamera.Priority = 20;
        }
    }
}