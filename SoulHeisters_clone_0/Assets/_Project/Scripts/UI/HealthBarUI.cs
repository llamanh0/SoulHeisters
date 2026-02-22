using UnityEngine;
using UnityEngine.UI;

public class HealthBarUI : MonoBehaviour
{
    [Header("References")]
    [SerializeField] private HealthComponent healthComponent;
    [SerializeField] private Image healthBarFill;
    [SerializeField] private Canvas canvas;

    [Header("Settings")]
    [SerializeField] private float maxHealth = 100f;

    private void Start()
    {
        if (healthComponent != null)
        {
            healthComponent.OnHealthChanged += HandleHealthChanged;

            UpdateHealthBar(healthComponent.CurrentHealth);
        }
    }

    private void OnDestroy()
    {
        if (healthComponent != null)
        {
            healthComponent.OnHealthChanged -= HandleHealthChanged;
        }
    }

    private void HandleHealthChanged(float previousHealth, float currentHealth)
    {
        UpdateHealthBar(currentHealth);
    }

    private void UpdateHealthBar(float currentHealth)
    {
        if (healthBarFill != null)
        {
            healthBarFill.fillAmount = currentHealth / maxHealth;
        }

        if (canvas != null)
        {
            if (healthComponent.IsOwner)
            {
                canvas.enabled = false;
                return;
            }

            if (currentHealth <= 0 || currentHealth >= maxHealth)
            {
                canvas.enabled = false;
            }
            else
            {
                canvas.enabled = true;
            }
        }
    }
}