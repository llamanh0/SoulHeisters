using DG.Tweening;
using UnityEngine;
using UnityEngine.UI;

/// <summary>
/// Tek bir spell slotunun UI davranisini kontrol eder.
/// 
/// Sorumluluklar:
/// - Bagli oldugu ISpell'in cooldown durumuna gore overlay fillAmount guncellemek
/// - Yetersiz mana durumunda kisa bir renk degisim feedback'i vermek
/// - Spell icon'unu gostermek
/// </summary>
public class SpellSlotUI : MonoBehaviour
{
    [SerializeField] private Image spellIcon;
    [SerializeField] private Image cooldownOverlay;
    [SerializeField] private Image background;

    private ISpell _spell;

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
        {
            cooldownOverlay.fillAmount = 0f;
        }
    }

    /// <summary>
    /// Slotu bosaltir (herhangi bir spell gostermez).
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
        if (_spell == null || cooldownOverlay == null) return;

        float elapsed = Time.time - _spell.LastCastTime;
        float remaining = _spell.Cooldown - elapsed;

        if (remaining > 0)
        {
            cooldownOverlay.fillAmount = remaining / _spell.Cooldown;
        }
        else
        {
            cooldownOverlay.fillAmount = 0f;
        }
    }
}