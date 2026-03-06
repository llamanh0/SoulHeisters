using UnityEngine;
using UnityEngine.UI;

/// <summary>
/// Dunya uzerinde gorunen bir health bar UI'ini yonetir.
/// 
/// Mantik:
/// - Saglik degisimlerini HealthComponent uzerinden dinler
/// - Mevcut sagliga gore fillAmount gunceller
/// - Canvas'i sadece gerekli durumlarda gosterir:
///   * Eger bu bir Player ise ve local owner'a aitse gizli
///   * Saglik tam ya da sifir ise gizli
/// </summary>
public class HealthBarUI : MonoBehaviour
{
    [Header("References")]
    [SerializeField] private HealthComponent healthComponent;
    [SerializeField] private Image healthBarFill;
    [SerializeField] private Canvas canvas;

    [Header("Settings")]
    [SerializeField] private float maxHealth = 100f;

    // Bu obje bir Player mi? (PlayerReferences var mi?)
    private bool _isPlayer;

    private void Start()
    {
        if (healthComponent != null)
        {
            // Bu health, bir Player uzerinde mi calisiyor?
            _isPlayer = healthComponent.GetComponent<PlayerReferences>() != null;

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

    /// <summary>
    /// Saglik degistiginde bar'i gunceller.
    /// </summary>
    private void HandleHealthChanged(float previousHealth, float currentHealth)
    {
        UpdateHealthBar(currentHealth);
    }

    /// <summary>
    /// Hem fillAmount hem de canvas'in acik/kapali olmasini kontrol eder.
    /// </summary>
    private void UpdateHealthBar(float currentHealth)
    {
        if (healthBarFill != null)
        {
            healthBarFill.fillAmount = currentHealth / maxHealth;
        }

        if (canvas == null || healthComponent == null)
            return;

        // Eger bu bir PLAYER ve local owner'a aitse, world-space health bar'i gizle
        if (_isPlayer && healthComponent.IsOwner)
        {
            canvas.enabled = false;
            return;
        }

        // Tam can veya sifir can durumunda gizle
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