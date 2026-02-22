using Unity.Netcode;
using UnityEngine;
using UnityEngine.UI;
using TMPro;

public class PlayerHUD : NetworkBehaviour
{
    [Header("UI References")]
    [Tooltip("Sadece bize ait olan ana Canvas objesi")]
    [SerializeField] private GameObject hudCanvas;
    [SerializeField] private Image healthFill;
    [SerializeField] private TextMeshProUGUI healthText;

    [Header("Player References")]
    [SerializeField] private HealthComponent healthComponent;

    private const float MAX_HEALTH = 100f;

    public override void OnNetworkSpawn()
    {
        if (!IsOwner)
        {
            if (hudCanvas != null) hudCanvas.SetActive(false);
            return;
        }

        if (hudCanvas != null) hudCanvas.SetActive(true);

        if (healthComponent != null)
        {
            healthComponent.OnHealthChanged += UpdateHealthUI;
            UpdateHealthUI(MAX_HEALTH, healthComponent.CurrentHealth);
        }
    }

    public override void OnNetworkDespawn()
    {
        if (IsOwner && healthComponent != null)
        {
            healthComponent.OnHealthChanged -= UpdateHealthUI;
        }
    }

    private void UpdateHealthUI(float previousHealth, float currentHealth)
    {
        if (healthFill != null)
        {
            healthFill.fillAmount = currentHealth / MAX_HEALTH;
        }

        if (healthText != null)
        {
            healthText.text = $"{Mathf.CeilToInt(currentHealth)} / {MAX_HEALTH}";
        }
    }
}