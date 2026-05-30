using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class ScoreboardPlayerRow : MonoBehaviour
{
    [SerializeField] private TextMeshProUGUI playerNameText;
    [SerializeField] private TextMeshProUGUI soulCountText;
    [SerializeField] private TextMeshProUGUI pingText;
    [SerializeField] private Image background;

    [Header("Colors")]
    [SerializeField] private Color normalColor = new Color(0.2f, 0.2f, 0.2f, 0.8f);
    [SerializeField] private Color localPlayerColor = new Color(0.3f, 0.5f, 0.3f, 0.8f);

    public void Setup(PlayerData data, bool isLocalPlayer)
    {
        if (playerNameText != null)
            playerNameText.text = data.playerName.ToString();

        if (soulCountText != null)
            soulCountText.text = data.soulCount.ToString();

        if (pingText != null)
            pingText.text = $"{data.ping}ms";

        if (background != null)
            background.color = isLocalPlayer ? localPlayerColor : normalColor;
    }
}