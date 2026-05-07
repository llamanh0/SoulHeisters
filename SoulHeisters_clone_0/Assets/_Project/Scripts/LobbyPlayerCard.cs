using TMPro;
using UnityEngine;
using UnityEngine.UI;

/// <summary>
/// Lobi listesindeki tek bir oyuncu kartini gosterir
/// Isim, hazir durumu, host badge
/// </summary>
public class LobbyPlayerCard : MonoBehaviour
{
    [Header("UI Elements")]
    [SerializeField] private TextMeshProUGUI playerNameText;
    [SerializeField] private GameObject readyIndicator;
    [SerializeField] private GameObject hostBadge;
    [SerializeField] private Image background;

    [Header("Colors")]
    [SerializeField] private Color normalColor = new Color(0.2f, 0.2f, 0.2f, 1f);
    [SerializeField] private Color readyColor = new Color(0.2f, 0.5f, 0.2f, 1f);

    private ulong _clientId;

    public void Setup(PlayerLobbyData data)
    {
        _clientId = data.clientId;
        UpdateData(data);
    }

    public void UpdateData(PlayerLobbyData data)
    {
        if (playerNameText != null)
            playerNameText.text = data.playerName.ToString();

        if (readyIndicator != null)
            readyIndicator.SetActive(data.isReady);

        if (background != null)
            background.color = data.isReady ? readyColor : normalColor;

        // Host badge - ID 0 genelde host
        if (hostBadge != null)
            hostBadge.SetActive(data.clientId == 0);
    }
}