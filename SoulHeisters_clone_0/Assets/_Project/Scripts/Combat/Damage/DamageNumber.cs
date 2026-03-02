using TMPro;
using UnityEngine;
using DG.Tweening;

public class DamageNumber : MonoBehaviour
{
    [SerializeField] private TextMeshProUGUI text;

    public void Setup(float damage)
    {
        if (damage > 40) text.color = Color.red;

        text.text = Mathf.RoundToInt(damage).ToString();

        // Random small offset
        transform.position += new Vector3(
            Random.Range(-0.5f, 0.5f),
            Random.Range(0f, 0.5f),
            0f);

        // Float up
        transform.DOMoveY(transform.position.y + 2f, 1f)
            .SetEase(Ease.OutQuad);

        // Fade out
        text.DOFade(0f, 1f)
            .OnComplete(() => Destroy(gameObject));
    }
}