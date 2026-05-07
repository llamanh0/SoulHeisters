using UnityEngine;
using UnityEngine.UI;

/// <summary>
/// UI elementine gradient efekti verir
/// Hollow Knight tarzi atmosferik arkaplan icin
/// </summary>
[RequireComponent(typeof(Image))]
public class GradientBackground : MonoBehaviour
{
    [Header("Colors")]
    [SerializeField] private Color topColor = new Color(0.1f, 0.05f, 0.15f, 1f);    // Koyu mor
    [SerializeField] private Color bottomColor = new Color(0.05f, 0.05f, 0.1f, 1f); // Koyu mavi
    
    [Header("Animation")]
    [SerializeField] private bool animate = true;
    [SerializeField] private float animSpeed = 0.3f;
    
    private Material gradientMaterial;
    private Image image;
    private float timeOffset;

    private void Awake()
    {
        image = GetComponent<Image>();
        SetupGradient();
    }

    private void SetupGradient()
    {
        // Vertex gradient shader kullan
        image.material = new Material(Shader.Find("UI/Default"));
        
        // Manuel gradient ciz
        Texture2D gradientTexture = CreateGradientTexture();
        image.sprite = Sprite.Create(
            gradientTexture,
            new Rect(0, 0, gradientTexture.width, gradientTexture.height),
            new Vector2(0.5f, 0.5f)
        );
    }

    private Texture2D CreateGradientTexture()
    {
        int height = 256;
        Texture2D texture = new Texture2D(1, height);
        
        for (int y = 0; y < height; y++)
        {
            float t = y / (float)height;
            Color color = Color.Lerp(bottomColor, topColor, t);
            texture.SetPixel(0, y, color);
        }
        
        texture.Apply();
        return texture;
    }

    private void Update()
    {
        if (animate)
        {
            // Hafif renk degisimi (pulsing efekt)
            timeOffset += Time.deltaTime * animSpeed;
            float pulse = Mathf.Sin(timeOffset) * 0.05f + 1f;
            image.color = new Color(pulse, pulse, pulse, 1f);
        }
    }
}