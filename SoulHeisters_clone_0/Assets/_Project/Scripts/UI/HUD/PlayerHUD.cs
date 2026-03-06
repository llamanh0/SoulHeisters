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
        if (_refs == null)
            Debug.LogError("[PlayerHUD] PlayerReferences bulunamadi!");
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
}