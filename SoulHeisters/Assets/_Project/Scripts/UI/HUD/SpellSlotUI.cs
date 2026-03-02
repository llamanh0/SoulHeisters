using UnityEngine;
using DG.Tweening;
using UnityEngine.UI;

public class SpellSlotUI : MonoBehaviour
{
    [SerializeField] private Image cooldownOverlay;
    [SerializeField] private Image background;

    private ISpell _spell;

    public void Setup(ISpell spell)
    {
        _spell = spell;
    }

    public void Clear()
    {
        _spell = null;
    }
    public void PlayNotEnoughManaFeedback()
    {
        background.DOColor(Color.red, 0.1f)
            .OnComplete(() =>
                background.DOColor(new Color(0.09411766f, 0.09411766f, 0.09411766f), 0.2f));
    }

    private void Update()
    {
        if (_spell == null) return;

        float elapsed = Time.time - _spell.LastCastTime;
        float remaining = _spell.Cooldown - elapsed;

        if (remaining > 0)
        {
            cooldownOverlay.fillAmount =
                remaining / _spell.Cooldown;
        }
        else
        {
            cooldownOverlay.fillAmount = 0f;
        }
    }
}