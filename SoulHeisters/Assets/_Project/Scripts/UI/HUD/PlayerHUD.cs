using TMPro;
using Unity.Netcode;
using UnityEngine;
using UnityEngine.UI;

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

    private const float MAX_HEALTH_DISPLAY = 100f;

    private void Awake()
    {
        _refs = GetComponent<PlayerReferences>();
        if (_refs == null) Debug.LogError("[PlayerHUD] PlayerReferences can not be find!");
    }

    public override void OnNetworkSpawn()
    {
        if (!IsOwner)
        {
            if (hudCanvas != null) hudCanvas.SetActive(false);
            return;
        }

        if (hudCanvas != null) hudCanvas.SetActive(true);

        if (_refs.Health != null)
        {
            _refs.Health.OnHealthChanged += UpdateHealthUI;
            UpdateHealthUI(MAX_HEALTH_DISPLAY, _refs.Health.CurrentHealth);
        }

        if (_refs.Mana != null)
        {
            _refs.Mana.OnManaChanged += UpdateManaUI;
        }
    }

    public override void OnNetworkDespawn()
    {
        if (!IsOwner) return;

        if (_refs.Health != null) _refs.Health.OnHealthChanged -= UpdateHealthUI;
        if (_refs.Mana != null) _refs.Mana.OnManaChanged -= UpdateManaUI;
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