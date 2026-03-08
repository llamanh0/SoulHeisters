using System.Collections.Generic;
using Unity.Netcode;
using UnityEngine;
using Cinemachine;

/// <summary>
/// Oyuncu oldugunda diger yasayan oyunculari izlemeye yarayan spectate sistemi.
/// 
/// Mantik:
/// - Sadece owner player icin aktif olur.
/// - Kendi HealthComponent.OnDeath event'ine abone olur.
/// - Oldugunde sahnedeki yasayan Player'lari bulur.
/// - Death camera'nin Follow/LookAt hedefini bu oyunculardan birine baglar.
/// - YAPILACAK: A/D tuslariyla siradaki oyuncuya gecme.
/// </summary>
[RequireComponent(typeof(PlayerReferences))]
public class PlayerSpectateController : NetworkBehaviour
{
    [Header("Camera")]
    [Tooltip("Olumden sonra kullanilacak Cinemachine sanal kamera.")]
    [SerializeField] private CinemachineVirtualCamera spectateCamera;

    private PlayerReferences _refs;

    /// <summary> Izlenebilecek yasayan player'larin listesi. </summary>
    private List<PlayerReferences> _alivePlayers = new List<PlayerReferences>();

    /// <summary> Su anda izlenen oyuncunun index'i. </summary>
    private int _currentIndex = -1;

    private void Awake()
    {
        _refs = GetComponent<PlayerReferences>();
    }

    public override void OnNetworkSpawn()
    {
        if (!IsOwner)
        {
            // Spectate sistemi sadece local owner icin lazim
            if (spectateCamera != null)
                spectateCamera.gameObject.SetActive(false);
            return;
        }

        // Owner icin: spectateCamera baslangicta acik ama dusuk oncelikli olabilir
        if (spectateCamera != null)
        {
            spectateCamera.gameObject.SetActive(true);
            spectateCamera.Priority = 5;
        }

        if (_refs.Health != null)
        {
            _refs.Health.OnDeath += HandleLocalPlayerDeath;
        }
    }

    public override void OnNetworkDespawn()
    {
        if (!IsOwner) return;

        if (_refs.Health != null)
        {
            _refs.Health.OnDeath -= HandleLocalPlayerDeath;
        }
    }

    /// <summary>
    /// Local player oldugunde cagrilir.
    /// </summary>
    private void HandleLocalPlayerDeath()
    {
        // Match Playing durumunda degilse spectate baslatmayalim
        if (GameStateManager.Instance != null &&
            GameStateManager.Instance.CurrentState != GameState.Playing)
            return;

        // 3 saniyelik death camera bekleme suresinden sonra spectate'e gec
        StartCoroutine(StartSpectateAfterDelay(3f));
    }
    private System.Collections.IEnumerator StartSpectateAfterDelay(float delay)
    {
        // Bu sure boyunca sadece death camera acik kalacak
        yield return new WaitForSeconds(delay);

        FindAlivePlayers();

        if (_alivePlayers.Count == 0)
        {
            // Hic yasayan oyuncu yoksa simdilik hicbir sey yapma
            // Ileride burada match sonu ekrani / lobi akisi eklenebilir.
            yield break;
        }

        _currentIndex = 0;
        SetSpectateTarget(_alivePlayers[_currentIndex]);
    }

    /// <summary>
    /// Sahnedeki tum yasayan PlayerReferences'lari bulur.
    /// Kendi player'ini ve olenleri liste disinda birakir.
    /// </summary>
    private void FindAlivePlayers()
    {
        _alivePlayers.Clear();

        var allPlayers = FindObjectsOfType<PlayerReferences>();
        foreach (var p in allPlayers)
        {
            if (p == _refs) continue; // kendimizi izlemeyelim
            if (p.Health != null && p.Health.IsDead) continue;

            _alivePlayers.Add(p);
        }
    }

    /// <summary>
    /// Spectate kamerayi verilen oyuncunun cameraRoot'una baglar.
    /// </summary>
    private void SetSpectateTarget(PlayerReferences targetPlayer)
    {
        if (spectateCamera == null || targetPlayer == null) return;

        var locomotion = targetPlayer.Locomotion;
        if (locomotion == null) return;

        Transform camRoot = locomotion.CameraRoot;

        spectateCamera.Follow = camRoot;
        spectateCamera.LookAt = camRoot;

        // Spectate kamera onceligini arttir (diger kameralarin uzerine ciksin)
        spectateCamera.Priority = 50;
    }

    private void Update()
    {
        if (!IsOwner) return;
        if (_refs.Health == null || !_refs.Health.IsDead) return;

        /*
        if (Input.GetKeyDown(KeyCode.Q))
        {
            CycleSpectateTarget(-1);
        }
        if (Input.GetKeyDown(KeyCode.E))
        {
            CycleSpectateTarget(1);
        }
        */
    }

    /// <summary>
    /// Yasayan oyuncular arasinda ileri/geri gezmek icin kullanilir.
    /// </summary>
    private void CycleSpectateTarget(int direction)
    {
        if (_alivePlayers.Count == 0) return;

        _currentIndex += direction;

        if (_currentIndex < 0)
            _currentIndex = _alivePlayers.Count - 1;
        else if (_currentIndex >= _alivePlayers.Count)
            _currentIndex = 0;

        SetSpectateTarget(_alivePlayers[_currentIndex]);
    }
}