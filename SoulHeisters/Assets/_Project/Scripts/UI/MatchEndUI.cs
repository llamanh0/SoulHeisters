using UnityEngine;
using TMPro;
using System.Collections;

public class MatchEndUI : MonoBehaviour
{
    [SerializeField] private GameObject matchEndPanel;
    [SerializeField] private TextMeshProUGUI winnerText;
    [SerializeField] private TextMeshProUGUI countdownText;

    private void Awake()
    {
        if (matchEndPanel != null)
            matchEndPanel.SetActive(false);
    }

    public void ShowWinner(string winnerName, int winnerSouls, float returnTime)
    {
        if (matchEndPanel != null)
            matchEndPanel.SetActive(true);

        if (winnerText != null)
            winnerText.text = $"{winnerName}\nKAZANDI!\n{winnerSouls} SOUL";

        StartCoroutine(CountdownRoutine(returnTime));
    }

    private IEnumerator CountdownRoutine(float time)
    {
        float remaining = time;

        while (remaining > 0)
        {
            if (countdownText != null)
                countdownText.text = $"Lobiye dönülüyor: {Mathf.CeilToInt(remaining)}";

            yield return new WaitForSeconds(1f);
            remaining -= 1f;
        }

        if (countdownText != null)
            countdownText.text = "Lobiye dönülüyor...";
    }
}