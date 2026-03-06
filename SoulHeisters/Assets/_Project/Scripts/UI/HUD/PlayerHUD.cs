using TMPro;
using Unity.Netcode;
using UnityEngine;
using UnityEngine.UI;

/// <summary>
/// Oyuncunun ekrandaki HUD'ini (health ve mana bar) yonetir.
/// 
/// Mantik:
/// - Sadece owner olan oyuncu icin HUD aktif olur.
/// - HealthComponent ve ManaComponent event'lerine abone olur.
/// - Saglik ve mana degistiginde ilgili UI ogelerini gunceller.
/// </summary>
public class PlayerHUD : NetworkBehaviour
{
    [Header("UI References")]
    [SerializeField] private GameObject hudCanvas;

    [Header("Match UI")]
    [SerializeField] private TextMeshProUGUI matchTimerText;

    [Header("Health UI")]
    [SerializeField] private Image healthFill;
    [SerializeField] private TextMeshProUGUI healthText;

    [Header("Mana UI")]
    [SerializeField] private Image manaFill;
    [SerializeField] private TextMeshProUGUI manaText;

    private PlayerReferences _refs;

    // Not: UI max health sabit alinmis, dilersen HealthComponent'ten dinamik alabilirsin
    private const float MAX_HEALTH_DISPLAY = 100f;

    private void Awake()
    {
        _refs = GetComponent<PlayerReferences>();
    }

    private void Update()
    {
        if (!IsOwner) return;

        UpdateMatchTimerUI();
    }

    public override void OnNetworkSpawn()
    {
        // Sadece owner kendi HUD'unu gorsun
        if (!IsOwner)
        {
            if (hudCanvas != null) hudCanvas.SetActive(false);
            return;
        }

        if (hudCanvas != null) hudCanvas.SetActive(true);

        // Health event'lerine abone ol
        if (_refs.Health != null)
        {
            _refs.Health.OnHealthChanged += UpdateHealthUI;
            // Baslangic degeri set et
            UpdateHealthUI(MAX_HEALTH_DISPLAY, _refs.Health.CurrentHealth);
        }

        // Mana event'lerine abone ol
        if (_refs.Mana != null)
        {
            _refs.Mana.OnManaChanged += UpdateManaUI;
        }
    }

    public override void OnNetworkDespawn()
    {
        if (!IsOwner) return;

        if (_refs.Health != null)
            _refs.Health.OnHealthChanged -= UpdateHealthUI;

        if (_refs.Mana != null)
            _refs.Mana.OnManaChanged -= UpdateManaUI;
    }

    /// <summary>
    /// Saglik her degistiginde cagrilir, health bar ve text'i gunceller.
    /// previousHealth parametresi su an sadece imza uyumu icin kullaniliyor.
    /// </summary>
    private void UpdateHealthUI(float previousHealth, float currentHealth)
    {
        if (healthFill != null)
            healthFill.fillAmount = currentHealth / MAX_HEALTH_DISPLAY;

        if (healthText != null)
            healthText.text = $"{Mathf.CeilToInt(currentHealth)}";
    }

    /// <summary>
    /// Mana her degistiginde cagrilir, mana bar ve text'i gunceller.
    /// </summary>
    private void UpdateManaUI(float currentMana, float maxMana)
    {
        if (manaFill != null)
            manaFill.fillAmount = currentMana / maxMana;

        if (manaText != null)
            manaText.text = $"{Mathf.FloorToInt(currentMana)}";
    }

    /// <summary>
    /// GameStateManager'dan kalan mac suresini okuyup HUD'e yazar.
    /// Sadece Playing durumunda sure geriye sayar, diger durumlarda
    /// farkli metinler gosterebilir.
    /// </summary>
    private void UpdateMatchTimerUI()
    {
        if (matchTimerText == null) return;
        if (GameStateManager.Instance == null) return;

        var gsm = GameStateManager.Instance;

        switch (gsm.CurrentState)
        {
            case GameState.WaitingForPlayers:
                matchTimerText.text = "Waiting for players...";
                break;

            case GameState.Starting:
                matchTimerText.text = "Match starting...";
                break;

            case GameState.Playing:
                // Burada kalan sureyi hesaplayacagiz
                float remaining = GetRemainingMatchTime();
                remaining = Mathf.Max(0f, remaining);

                int minutes = Mathf.FloorToInt(remaining / 60f);
                int seconds = Mathf.FloorToInt(remaining % 60f);

                matchTimerText.text = $"{minutes:00}:{seconds:00}";
                break;

            case GameState.MatchEnded:
                matchTimerText.text = "Match ended";
                break;

            default:
                matchTimerText.text = "";
                break;
        }
    }

    /// <summary>
    /// GameStateManager'dan kalan sureyi ceker.
    /// Ayrica null kontrolu yapar.
    /// </summary>
    private float GetRemainingMatchTime()
    {
        if (GameStateManager.Instance == null)
            return 0f;

        return GameStateManager.Instance.GetRemainingTime();
    }
}