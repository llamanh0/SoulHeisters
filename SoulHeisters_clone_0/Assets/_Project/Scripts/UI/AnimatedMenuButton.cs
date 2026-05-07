using UnityEngine;
using UnityEngine.UI;
using UnityEngine.EventSystems;
using DG.Tweening;
using TMPro;

/// <summary>
/// Hollow Knight tarzi animasyonlu buton
/// Hover, click ve idle animasyonlar
/// </summary>
[RequireComponent(typeof(Button))]
public class AnimatedMenuButton : MonoBehaviour, IPointerEnterHandler, IPointerExitHandler, IPointerDownHandler, IPointerUpHandler
{
    [Header("References")]
    [SerializeField] private Image buttonImage;
    [SerializeField] private TextMeshProUGUI buttonText;
    [SerializeField] private Image glowImage; // Arka planda glow efekti (opsiyonel)

    [Header("Colors")]
    [SerializeField] private Color normalColor = new Color(0.2f, 0.2f, 0.25f, 0.8f);
    [SerializeField] private Color hoverColor = new Color(0.3f, 0.3f, 0.4f, 1f);
    [SerializeField] private Color pressedColor = new Color(0.15f, 0.15f, 0.2f, 1f);
    [SerializeField] private Color textNormalColor = new Color(0.7f, 0.7f, 0.8f, 1f);
    [SerializeField] private Color textHoverColor = Color.white;

    [Header("Animation")]
    [SerializeField] private float hoverScale = 1.05f;
    [SerializeField] private float pressScale = 0.95f;
    [SerializeField] private float animDuration = 0.2f;
    [SerializeField] private bool idlePulse = true;
    [SerializeField] private float pulseDuration = 2f;

    private Vector3 originalScale;
    private Sequence idleSequence;

    private void Awake()
    {
        if (buttonImage == null)
            buttonImage = GetComponent<Image>();
        
        if (buttonText == null)
            buttonText = GetComponentInChildren<TextMeshProUGUI>();

        originalScale = transform.localScale;
        
        // Baslangic renkleri
        if (buttonImage != null)
            buttonImage.color = normalColor;
        
        if (buttonText != null)
            buttonText.color = textNormalColor;
    }

    private void Start()
    {
        if (idlePulse)
            StartIdlePulse();
    }

    private void OnDestroy()
    {
        // DOTween temizligi
        transform.DOKill();
        if (buttonImage != null) buttonImage.DOKill();
        if (buttonText != null) buttonText.DOKill();
        if (glowImage != null) glowImage.DOKill();
        idleSequence?.Kill();
    }

    #region Idle Animation

    private void StartIdlePulse()
    {
        idleSequence?.Kill();
        
        idleSequence = DOTween.Sequence();
        idleSequence.Append(transform.DOScale(originalScale * 1.02f, pulseDuration).SetEase(Ease.InOutSine));
        idleSequence.Append(transform.DOScale(originalScale, pulseDuration).SetEase(Ease.InOutSine));
        idleSequence.SetLoops(-1);
    }

    private void StopIdlePulse()
    {
        idleSequence?.Kill();
        transform.DOScale(originalScale, animDuration);
    }

    #endregion

    #region Pointer Events

    public void OnPointerEnter(PointerEventData eventData)
    {
        StopIdlePulse();

        // Scale
        transform.DOScale(originalScale * hoverScale, animDuration)
            .SetEase(Ease.OutBack);

        // Renk
        if (buttonImage != null)
            buttonImage.DOColor(hoverColor, animDuration);

        if (buttonText != null)
        {
            buttonText.DOColor(textHoverColor, animDuration);
            
            // Text hafif buyusun
            buttonText.transform.DOScale(1.1f, animDuration).SetEase(Ease.OutBack);
        }

        // Glow efekti
        if (glowImage != null)
        {
            glowImage.DOFade(0.6f, animDuration);
        }

        // Ses efekti (opsiyonel)
        // AudioManager.PlaySound("UI_Hover");
    }

    public void OnPointerExit(PointerEventData eventData)
    {
        // Normal duruma don
        transform.DOScale(originalScale, animDuration)
            .SetEase(Ease.OutQuad);

        if (buttonImage != null)
            buttonImage.DOColor(normalColor, animDuration);

        if (buttonText != null)
        {
            buttonText.DOColor(textNormalColor, animDuration);
            buttonText.transform.DOScale(1f, animDuration);
        }

        if (glowImage != null)
        {
            glowImage.DOFade(0f, animDuration);
        }

        if (idlePulse)
            StartIdlePulse();
    }

    public void OnPointerDown(PointerEventData eventData)
    {
        // Basilma efekti
        transform.DOScale(originalScale * pressScale, animDuration * 0.5f)
            .SetEase(Ease.InQuad);

        if (buttonImage != null)
            buttonImage.DOColor(pressedColor, animDuration * 0.5f);

        // Ses efekti
        // AudioManager.PlaySound("UI_Click");
    }

    public void OnPointerUp(PointerEventData eventData)
    {
        // Hover durumuna geri don (eger hala hover'daysa)
        transform.DOScale(originalScale * hoverScale, animDuration * 0.5f)
            .SetEase(Ease.OutQuad);

        if (buttonImage != null)
            buttonImage.DOColor(hoverColor, animDuration * 0.5f);
    }

    #endregion
}