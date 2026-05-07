using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

/// <summary>
/// Lobi UI elementlerini kontrol eder
/// Oyuncu kartlari, butonlar, bilgiler
/// </summary>
public class LobbyUI : MonoBehaviour
{
    #region UI References

    [Header("Info")]
    [SerializeField] private TextMeshProUGUI lobbyCodeText;
    [SerializeField] private TextMeshProUGUI playerCountText;

    [Header("Player List")]
    [SerializeField] private Transform playerListContent;
    [SerializeField] private GameObject playerCardPrefab;

    [Header("Bottom Panel")]
    [SerializeField] private TMP_InputField nameInputField;
    [SerializeField] private Button readyButton;
    [SerializeField] private Button startButton;
    [SerializeField] private Button leaveButton;

    [Header("Loading")]
    [SerializeField] private GameObject loadingPanel;

    #endregion

    #region Private Fields

    private Dictionary<ulong, LobbyPlayerCard> _playerCards = new();
    private bool _isLocalPlayerReady = false;

    #endregion

    #region Unity Lifecycle

    private void Start()
    {
        SetupButtons();
        SetupNameInput();
        UpdatePlayerCountText();
        
        // Loading panel kapat
        if (loadingPanel != null)
            loadingPanel.SetActive(false);
    }
    
    private void OnDestroy()
    {
        Debug.Log("[LobbyUI] OnDestroy - Cleaning up");

        // Tum coroutine'leri durdur
        StopAllCoroutines();

        // Event listener'lari temizle
        if (readyButton != null)
            readyButton.onClick.RemoveAllListeners();

        if (startButton != null)
            startButton.onClick.RemoveAllListeners();

        if (leaveButton != null)
            leaveButton.onClick.RemoveAllListeners();

        if (nameInputField != null)
            nameInputField.onEndEdit.RemoveAllListeners();
    }

    #endregion

    #region Setup

    private void SetupButtons()
    {
        if (readyButton != null)
        {
            readyButton.onClick.AddListener(OnReadyButtonClicked);
            UpdateReadyButtonText();
        }

        if (startButton != null)
        {
            startButton.onClick.AddListener(OnStartButtonClicked);
            
            // Sadece host'ta goster
            bool isHost = Unity.Netcode.NetworkManager.Singleton != null &&
                          Unity.Netcode.NetworkManager.Singleton.IsHost;
            startButton.gameObject.SetActive(isHost);
        }

        if (leaveButton != null)
        {
            leaveButton.onClick.AddListener(OnLeaveButtonClicked);
        }
    }

    private void SetupNameInput()
    {
        if (nameInputField != null)
        {
            // Varsayilan random isim
            string defaultName = $"Player_{Random.Range(1000, 9999)}";
            nameInputField.text = defaultName;

            nameInputField.onEndEdit.AddListener(OnNameChanged);

            // Ilk ismi ayarla
            OnNameChanged(defaultName);
        }
    }

    #endregion

    #region Player Cards

    public void AddPlayerCard(PlayerLobbyData playerData)
    {
        if (_playerCards.ContainsKey(playerData.clientId))
        {
            Debug.LogWarning($"[LobbyUI] Player card already exists: {playerData.clientId}");
            return;
        }

        if (playerCardPrefab == null || playerListContent == null)
        {
            Debug.LogError("[LobbyUI] Player card prefab or content is null!");
            return;
        }

        GameObject cardObj = Instantiate(playerCardPrefab, playerListContent);
        LobbyPlayerCard card = cardObj.GetComponent<LobbyPlayerCard>();

        if (card != null)
        {
            card.Setup(playerData);
            _playerCards.Add(playerData.clientId, card);
        }

        UpdatePlayerCountText();
    }

    public void RemovePlayerCard(ulong clientId)
    {
        if (_playerCards.TryGetValue(clientId, out var card))
        {
            Destroy(card.gameObject);
            _playerCards.Remove(clientId);
        }

        UpdatePlayerCountText();
    }

    public void UpdatePlayerCard(PlayerLobbyData playerData)
    {
        if (_playerCards.TryGetValue(playerData.clientId, out var card))
        {
            card.UpdateData(playerData);
        }
    }

    #endregion

    #region Button Callbacks

    private void OnReadyButtonClicked()
    {
        _isLocalPlayerReady = !_isLocalPlayerReady;

        if (LobbyManager.Instance != null)
        {
            ulong localId = Unity.Netcode.NetworkManager.Singleton.LocalClientId;
            LobbyManager.Instance.SetPlayerReadyServerRpc(localId, _isLocalPlayerReady);
        }

        UpdateReadyButtonText();
    }

    private void OnStartButtonClicked()
    {
        if (LobbyManager.Instance != null)
        {
            LobbyManager.Instance.TryStartGame();
        }
    }

    private void OnLeaveButtonClicked()
    {
        if (Unity.Netcode.NetworkManager.Singleton != null)
        {
            Unity.Netcode.NetworkManager.Singleton.Shutdown();
        }

        UnityEngine.SceneManagement.SceneManager.LoadScene("MenuScene");
    }

    private void OnNameChanged(string newName)
    {
        if (string.IsNullOrWhiteSpace(newName))
        {
            newName = "Player";
            if (nameInputField != null)
                nameInputField.text = newName;
        }

        if (LobbyManager.Instance != null)
        {
            ulong localId = Unity.Netcode.NetworkManager.Singleton.LocalClientId;
            LobbyManager.Instance.SetPlayerNameServerRpc(localId, newName);
        }
    }

    #endregion

    #region UI Updates

    private void UpdateReadyButtonText()
    {
        if (readyButton == null) return;

        var text = readyButton.GetComponentInChildren<TextMeshProUGUI>();
        if (text != null)
        {
            text.text = _isLocalPlayerReady ? "HAZIR DEGIL" : "HAZIRIM";
        }

        // Renk degistir
        var img = readyButton.GetComponent<Image>();
        if (img != null)
        {
            img.color = _isLocalPlayerReady 
                ? new Color32(67, 181, 129, 255)  // Yesil
                : new Color32(88, 101, 242, 255); // Mavi
        }
    }

    private void UpdatePlayerCountText()
    {
        if (playerCountText == null) return;

        int count = _playerCards.Count;
        playerCountText.text = $"Oyuncular: {count}/8";
    }

    public void SetLobbyCode(string code)
    {
        if (lobbyCodeText != null)
            lobbyCodeText.text = $"Lobi Kodu: {code}";
    }

    public void SetStartButtonInteractable(bool interactable)
    {
        if (startButton != null)
            startButton.interactable = interactable;
    }

    public void ShowLoadingPanel(bool show)
    {
        if (loadingPanel != null)
            loadingPanel.SetActive(show);
    }

    #endregion
}