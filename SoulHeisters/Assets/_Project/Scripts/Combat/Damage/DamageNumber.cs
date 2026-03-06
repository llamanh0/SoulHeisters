using TMPro;
using UnityEngine;
using DG.Tweening;

/// <summary>
/// Ekranda goruntulenen tek bir hasar sayisini temsil eder.
/// Spawn edildikten sonra yukari dogru ucar, saydamlasir ve yok olur.
/// </summary>
public class DamageNumber : MonoBehaviour
{
    [SerializeField] private TextMeshProUGUI text;

    /// <summary>
    /// Hasar miktarini ayarlar ve animasyonu baslatir.
    /// </summary>
    public void Setup(float damage)
    {
        // Yuksek hasar icin farkli renk (ornek: kirmizi)
        if (damage > 40)
            text.color = Color.red;

        text.text = Mathf.RoundToInt(damage).ToString();

        // Baslangic pozisyonuna kucuk rastgele bir offset ekle
        transform.position += new Vector3(
            Random.Range(-0.5f, 0.5f),
            Random.Range(0f, 0.5f),
            0f);

        // Yukari dogru kayma animasyonu
        transform.DOMoveY(transform.position.y + 2f, 1f)
            .SetEase(Ease.OutQuad);

        // Yavasca saydamlasip kaybolma
        text.DOFade(0f, 1f)
            .OnComplete(() => Destroy(gameObject));
    }
}