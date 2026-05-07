using UnityEngine;
using UnityEngine.UI;
using DG.Tweening;

/// <summary>
/// Scene gecislerinde fade in/out efekti
/// Hollow Knight tarzi smooth gecisler
/// </summary>
public class SceneTransition : MonoBehaviour
{
    public static SceneTransition Instance { get; private set; }

    [Header("References")]
    [SerializeField] private CanvasGroup fadeCanvasGroup;
    [SerializeField] private Image fadeImage;

    [Header("Settings")]
    [SerializeField] private float fadeDuration = 0.8f;
    [SerializeField] private Color fadeColor = Color.black;

    private void Awake()
    {
        if (Instance != null && Instance != this)
        {
            Destroy(gameObject);
            return;
        }
        Instance = this;
        DontDestroyOnLoad(gameObject);

        // Baslangicta gorunmez
        if (fadeCanvasGroup != null)
            fadeCanvasGroup.alpha = 0;

        if (fadeImage != null)
            fadeImage.color = fadeColor;
    }

    
    /// <summary>
    /// Ekrani karart
    /// </summary>
    public void FadeOut(System.Action onComplete = null)
    {
        fadeCanvasGroup.blocksRaycasts = true;
        fadeCanvasGroup.DOFade(1f, fadeDuration)
            .SetEase(Ease.InOutQuad)
            .OnComplete(() => onComplete?.Invoke());
    }

    /// <summary>
    /// Ekrani aciginlastir
    /// </summary>
    public void FadeIn(System.Action onComplete = null)
    {
        fadeCanvasGroup.DOFade(0f, fadeDuration)
            .SetEase(Ease.InOutQuad)
            .OnComplete(() =>
            {
                fadeCanvasGroup.blocksRaycasts = false;
                onComplete?.Invoke();
            });
    }

    /// <summary>
    /// Fade out -> Aksiyon -> Fade in
    /// </summary>
    public void Transition(System.Action duringFade)
    {
        FadeOut(() =>
        {
            duringFade?.Invoke();
            FadeIn();
        });
    }
}