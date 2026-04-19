using DG.Tweening;
using UnityEngine;
using UnityEngine.UI;

/// <summary>
/// Tek bir spell slotunun UI davranisini kontrol eder.
/// 
/// Sorumluluklar:
/// - Spell icon gosterimi
/// - Cooldown overlay
/// - Secili slot icin donen parlak cerceve efekti
/// - Yetersiz mana feedback'i
/// </summary>
public class SpellSlotUI : MonoBehaviour
{
    [Header("Core")]
    [SerializeField] private Image spellIcon;
    [SerializeField] private Image cooldownOverlay;
    [SerializeField] private Image background;

    [Header("Selection Glow")]
    [SerializeField] private GameObject glowContainer;
    [SerializeField] private Image glowImage;

    [Header("Glow Settings")]
    [SerializeField] private float rotateSpeed = 90f;
    [SerializeField] private float pulseMinAlpha = 0.4f;
    [SerializeField] private float pulseMaxAlpha = 1f;
    [SerializeField] private float pulseDuration = 0.8f;
    [SerializeField] private Color glowColor = new Color(0f, 0.8f, 1f, 1f);

    private ISpell _spell;
    private bool _isSelected;
    private Tweener _pulseTween;

    /// <summary>
    /// Bu slotta gosterilecek spell'i ve icon'unu baglar.
    /// </summary>
    public void Setup(ISpell spell, SpellDefinitionSO definition)
    {
        _spell = spell;

        if (spellIcon != null)
        {
            spellIcon.sprite = definition != null ? definition.icon : null;
            spellIcon.enabled = spellIcon.sprite != null;
            spellIcon.preserveAspect = true;
        }

        if (cooldownOverlay != null)
            cooldownOverlay.fillAmount = 0f;
    }

    /// <summary>
    /// Slotu bosaltir.
    /// </summary>
    public void Clear()
    {
        _spell = null;

        if (spellIcon != null)
        {
            spellIcon.sprite = null;
            spellIcon.enabled = false;
        }

        if (cooldownOverlay != null)
            cooldownOverlay.fillAmount = 0f;

        SetSelected(false);
    }

    /// <summary>
    /// Secili slot olarak isaretler veya isaretini kaldirir.
    /// Secili olunca donen parlak cerceve aktif olur.
    /// </summary>
    public void SetSelected(bool isSelected)
    {
        _isSelected = isSelected;

        if (glowContainer != null)
            glowContainer.SetActive(isSelected);

        if (isSelected)
            StartGlowEffect();
        else
            StopGlowEffect();
    }

    /// <summary>
    /// Yetersiz mana durumunda arka plan rengini kisa sure kirmiziya cekip geri doner.
    /// </summary>
    public void PlayNotEnoughManaFeedback()
    {
        if (background == null) return;

        background.DOColor(Color.red, 0.1f)
            .OnComplete(() =>
                background.DOColor(new Color(0.09411766f, 0.09411766f, 0.09411766f), 0.2f));
    }

    private void Update()
    {
        UpdateCooldown();
        UpdateGlowRotation();
    }

    /// <summary>
    /// Cooldown overlay'ini gunceller.
    /// </summary>
    private void UpdateCooldown()
    {
        if (_spell == null || cooldownOverlay == null) return;

        float elapsed = Time.time - _spell.LastCastTime;
        float remaining = _spell.Cooldown - elapsed;

        if (remaining > 0)
            cooldownOverlay.fillAmount = remaining / _spell.Cooldown;
        else
            cooldownOverlay.fillAmount = 0f;
    }

    /// <summary>
    /// Secili slottaki glow objesini surekli dondurur.
    /// </summary>
    private void UpdateGlowRotation()
    {
        if (!_isSelected || glowContainer == null) return;

        glowContainer.transform.Rotate(0f, 0f, -rotateSpeed * Time.deltaTime);
    }

    /// <summary>
    /// Glow efektini baslatir: renk atar ve pulse animasyonu oynatir.
    /// </summary>
    private void StartGlowEffect()
    {
        if (glowImage == null) return;

        // Onceki tween varsa durdur
        _pulseTween?.Kill();

        glowImage.color = glowColor;

        // Alpha pulse: parlak <-> soluk arasi gidip gelir
        _pulseTween = glowImage
            .DOFade(pulseMinAlpha, pulseDuration)
            .SetLoops(-1, LoopType.Yoyo)
            .SetEase(Ease.InOutSine);
    }

    /// <summary>
    /// Glow efektini durdurur.
    /// </summary>
    private void StopGlowEffect()
    {
        _pulseTween?.Kill();
        _pulseTween = null;

        if (glowImage != null)
        {
            Color c = glowImage.color;
            c.a = 0f;
            glowImage.color = c;
        }

        // Rotasyonu sifirla
        if (glowContainer != null)
            glowContainer.transform.rotation = Quaternion.identity;
    }
}