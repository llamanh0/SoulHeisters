using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class MainMenuController : MonoBehaviour
{
    [Header("Panels")]
    [SerializeField] private GameObject mainMenuPanel;
    [SerializeField] private GameObject playMenuPanel;
    [SerializeField] private GameObject joinMenuPanel;
    [SerializeField] private GameObject loadingPanel;
    [SerializeField] private TextMeshProUGUI loadingText;

    [Header("Main Menu")]
    [SerializeField] private Button playButton;
    [SerializeField] private Button settingsButton;
    [SerializeField] private Button quitButton;

    [Header("Play Menu")]
    [SerializeField] private Button createGameButton;
    [SerializeField] private Button joinGameButton;
    [SerializeField] private Button playBackButton;

    [Header("Join Menu")]
    [SerializeField] private TMP_InputField lobbyCodeInput;
    [SerializeField] private Button joinButton;
    [SerializeField] private Button joinBackButton;
    [SerializeField] private TextMeshProUGUI errorText;

    private void Start()
    {
        SetupButtons();
        SetupAppNetEvents();
        ShowMainMenu();

        if (loadingPanel != null)
            loadingPanel.SetActive(false);

        if (errorText != null)
            errorText.gameObject.SetActive(false);
    }

    private void OnDestroy()
    {
        if (AppNetManager.Instance != null)
        {
            AppNetManager.Instance.OnRelayReady -= HandleRelayReady;
            AppNetManager.Instance.OnRelayError -= HandleRelayError;
        }
    }

    private void SetupButtons()
    {
        if (playButton != null)
            playButton.onClick.AddListener(OnPlayClicked);
        if (settingsButton != null)
            settingsButton.onClick.AddListener(OnSettingsClicked);
        if (quitButton != null)
            quitButton.onClick.AddListener(OnQuitClicked);
        if (createGameButton != null)
            createGameButton.onClick.AddListener(OnCreateGameClicked);
        if (joinGameButton != null)
            joinGameButton.onClick.AddListener(OnJoinGameClicked);
        if (playBackButton != null)
            playBackButton.onClick.AddListener(ShowMainMenu);
        if (joinButton != null)
            joinButton.onClick.AddListener(OnJoinLobbyClicked);
        if (joinBackButton != null)
            joinBackButton.onClick.AddListener(ShowPlayMenu);
    }

    private void SetupAppNetEvents()
    {
        if (AppNetManager.Instance == null) return;

        AppNetManager.Instance.OnRelayReady += HandleRelayReady;
        AppNetManager.Instance.OnRelayError += HandleRelayError;
    }

    private void HandleRelayReady()
    {
        HideLoading();
        HideError();
    }

    private void HandleRelayError(string error)
    {
        Debug.LogError($"[MainMenu] Connection error: {error}");

        HideLoading();
        ShowError("Connection failed. Check the code and try again.");
        ShowJoinMenu();

        if (Unity.Netcode.NetworkManager.Singleton != null)
        {
            Unity.Netcode.NetworkManager.Singleton.Shutdown();
        }
    }

    private void ShowMainMenu()
    {
        SetPanelActive(mainMenuPanel, true);
        SetPanelActive(playMenuPanel, false);
        SetPanelActive(joinMenuPanel, false);
        HideError();
    }

    private void ShowPlayMenu()
    {
        SetPanelActive(mainMenuPanel, false);
        SetPanelActive(playMenuPanel, true);
        SetPanelActive(joinMenuPanel, false);
        HideError();
    }

    private void ShowJoinMenu()
    {
        SetPanelActive(mainMenuPanel, false);
        SetPanelActive(playMenuPanel, false);
        SetPanelActive(joinMenuPanel, true);
    }

    private void ShowLoading(string message = "Connecting...")
    {
        if (loadingPanel != null)
            loadingPanel.SetActive(true);
        if (loadingText != null)
            loadingText.text = message;
    }

    private void HideLoading()
    {
        if (loadingPanel != null)
            loadingPanel.SetActive(false);
    }

    private void ShowError(string message)
    {
        if (errorText != null)
        {
            errorText.text = message;
            errorText.gameObject.SetActive(true);
        }
    }

    private void HideError()
    {
        if (errorText != null)
            errorText.gameObject.SetActive(false);
    }

    private void SetPanelActive(GameObject panel, bool active)
    {
        if (panel != null) panel.SetActive(active);
    }

    private void OnPlayClicked() => ShowPlayMenu();

    private void OnSettingsClicked()
    {
        Debug.Log("[MainMenu] Settings - Not implemented yet");
    }

    private void OnQuitClicked()
    {
        Application.Quit();
#if UNITY_EDITOR
        UnityEditor.EditorApplication.isPlaying = false;
#endif
    }

    private void OnCreateGameClicked()
    {
        if (AppNetManager.Instance == null) return;

        ShowLoading("Creating lobby...");
        SetPanelActive(playMenuPanel, false);

        AppNetManager.Instance.StartHost();
    }

    private void OnJoinGameClicked() => ShowJoinMenu();

    private void OnJoinLobbyClicked()
    {
        string code = lobbyCodeInput != null ? lobbyCodeInput.text.Trim() : "";

        if (string.IsNullOrWhiteSpace(code))
        {
            ShowError("Please enter a join code");
            return;
        }

        HideError();
        ShowLoading($"Joining {code}...");
        SetPanelActive(joinMenuPanel, false);

        AppNetManager.Instance.StartClient(code);
    }
}