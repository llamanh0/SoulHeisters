using System.Collections;
using Unity.Netcode;
using UnityEngine;

/// <summary>
/// Oyunun genel durum dongusunu (match flow) yoneten sinif.
/// 
/// Durumlar:
/// - WaitingForPlayers: Yeterli oyuncu gelene kadar bekler.
/// - Starting: Kisa bir geri sayim veya hazirlik suresi.
/// - Playing: Esas oyun suresi.
/// - MatchEnded: Mac sonu, skor gosterme gibi islemler.
/// 
/// Notlar:
/// - Bu sinif sadece server tarafinda calismalidir.
/// - Durum degisimleri event ile diger sistemlere (mob spawn vs.) bildirilir.
/// </summary>
public class GameStateManager : NetworkBehaviour
{
    public static GameStateManager Instance;

    /// <summary>
    /// Aktif mac durumunu tum client'lara senkronize eden degisken.
    /// Sadece server yazabilir.
    /// </summary>
    private NetworkVariable<GameState> currentState =
        new NetworkVariable<GameState>(GameState.WaitingForPlayers);

    /// <summary> Su anki oyun durumu (sadece okunabilir). </summary>
    public GameState CurrentState => currentState.Value;

    /// <summary> Mac basladiginda (Starting'den Playing'e gecis gibi) tetiklenir. </summary>
    public System.Action OnMatchStarted;

    /// <summary> Mac tamamen bittiginde tetiklenir. </summary>
    public System.Action OnMatchEnded;

    [Header("Match Settings")]
    /// <summary> Mac suresi degiskeni. </summary>
    [SerializeField] 
    private float matchDuration = 300f;

    /// <summary>
    /// Macin basladigi an (server Time.time degeri).
    /// Sadece server doldurur.
    /// </summary>
    private float matchStartTime;


    private void Awake()
    {
        Instance = this;
    }

    public override void OnNetworkSpawn()
    {
        // Sadece server oyun dongusunu kontrol eder
        if (IsServer)
        {
            StartCoroutine(GameLoop());
        }
    }

    /// <summary>
    /// Tum oyun dongusunu sonsuz bir dongu halinde calistirir.
    /// Bir mac bittikten sonra yeni bir maca tekrar baslanabilir.
    /// </summary>
    private IEnumerator GameLoop()
    {
        while (true)
        {
            yield return WaitForPlayers();
            yield return StartingPhase();
            yield return PlayingPhase();
            yield return MatchEndPhase();
        }
    }

    /// <summary>
    /// Yeterli sayida oyuncu gelene kadar bekler.
    /// Simdilik minimum oyuncu sayisi 1 olarak belirlenmis.
    /// </summary>
    private IEnumerator WaitForPlayers()
    {
        currentState.Value = GameState.WaitingForPlayers;

        while (NetworkManager.Singleton.ConnectedClients.Count < 1)
            yield return null;
    }

    /// <summary>
    /// Oyuncular geldikten sonra, mac baslamadan onceki hazirlik suresi.
    /// Ornek: geri sayim, UI mesajlari vs.
    /// </summary>
    private IEnumerator StartingPhase()
    {
        currentState.Value = GameState.Starting;

        // Kisa bir bekleme suresi (3 saniye)
        yield return new WaitForSeconds(3f);

        // Mac baslangic zamanini kaydet (sadece server)
        matchStartTime = Time.time;

        // Dis sistemlere macin basladigini bildir
        OnMatchStarted?.Invoke();
    }

    /// <summary>
    /// Esas oyun suresinin devam ettigi faz.
    /// IsMatchFinished true donene kadar devam eder.
    /// </summary>
    private IEnumerator PlayingPhase()
    {
        currentState.Value = GameState.Playing;

        while (!IsMatchFinished())
            yield return null;
    }

    /// <summary>
    /// Mac bittikten sonraki faz.
    /// Skor gosterme, lobby'e donme vs. icin kullanilabilir.
    /// </summary>
    private IEnumerator MatchEndPhase()
    {
        currentState.Value = GameState.MatchEnded;

        // Bir sure mac sonu ekrani icin bekleme suresi
        yield return new WaitForSeconds(5f);

        OnMatchEnded?.Invoke();
    }

    /// <summary>
    /// Macin bitme kosulunu kontrol eder.
    /// </summary>
    /// <returns> 
    /// Macta gecen sure <see cref="matchDuration"/> degerinden
    /// buyukse true, kucukse false.
    /// </returns>
    private bool IsMatchFinished()
    {
        if (!IsServer) return false;

        // Mac basladiktan sonra gecen sure
        float elapsed = Time.time - matchStartTime;

        if (elapsed >= matchDuration)
            return true;

        return false;
    }

    /// <summary>
    /// Kalan mac suresini saniye cinsinden doner.
    /// Sadece server dogru degeri hesaplar, client'lar asagi yukari deger gorur.
    /// </summary>
    public float GetRemainingTime()
    {
        // Match baslamamissa tam sureyi don
        if (CurrentState != GameState.Playing)
        {
            return matchDuration;
        }

        float elapsed = Time.time - matchStartTime;
        float remaining = matchDuration - elapsed;

        return remaining;
    }
}