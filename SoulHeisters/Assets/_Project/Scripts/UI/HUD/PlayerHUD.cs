using Unity.Netcode;
using UnityEngine;
using UnityEngine.UI;
using TMPro;

public class PlayerHUD : NetworkBehaviour
{
    [Header("UI References")]
    [SerializeField] private GameObject hudCanvas;

    [Header("Health UI")]
    [SerializeField] private Image healthFill;
    [SerializeField] private TextMeshProUGUI healthText;
    [SerializeField] private HealthComponent healthComponent;

    [Header("Mana UI")]
    [SerializeField] private Image manaFill;
    [SerializeField] private TextMeshProUGUI manaText;
    [SerializeField] private PlayerCombat playerCombat;

    private const float MAX_HEALTH_DISPLAY = 100f;

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
            UpdateHealthUI(MAX_HEALTH_DISPLAY, healthComponent.CurrentHealth);
        }

        if (playerCombat != null)
        {
            playerCombat.OnManaChanged += UpdateManaUI;
        }
    }

    public override void OnNetworkDespawn()
    {
        if (!IsOwner) return;

        if (healthComponent != null) healthComponent.OnHealthChanged -= UpdateHealthUI;
        if (playerCombat != null) playerCombat.OnManaChanged -= UpdateManaUI;
    }

    private void UpdateHealthUI(float previousHealth, float currentHealth)
    {
        if (healthFill != null) healthFill.fillAmount = currentHealth / MAX_HEALTH_DISPLAY;
        if (healthText != null) healthText.text = $"{Mathf.CeilToInt(currentHealth)}";
    }

    private void UpdateManaUI(float currentMana, float maxMana)
    {
        if (manaFill != null)
        {
            manaFill.fillAmount = currentMana / maxMana;
        }

        if (manaText != null)
        {
            manaText.text = $"{Mathf.FloorToInt(currentMana)}";
        }
    }
}