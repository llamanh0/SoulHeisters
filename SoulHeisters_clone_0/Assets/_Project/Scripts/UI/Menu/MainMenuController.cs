using TMPro;
using UnityEngine;
using UnityEngine.UI;

/// <summary>
/// Ana menu kontrolcusu
/// Panel gecisleri ve buton eventlerini yonetir
/// </summary>
public class MainMenuController : MonoBehaviour
{
    #region UI Panels

    [Header("Panels")]
    [SerializeField] private GameObject mainMenuPanel;
    [SerializeField] private GameObject playMenuPanel;
    [SerializeField] private GameObject joinMenuPanel;

    #endregion

    #region Main Menu Buttons

    [Header("Main Menu")]
    [SerializeField] private Button playButton;
    [SerializeField] private Button settingsButton;
    [SerializeField] private Button quitButton;

    #endregion

    #region Play Menu Buttons

    [Header("Play Menu")]
    [SerializeField] private Button createGameButton;
    [SerializeField] private Button joinGameButton;
    [SerializeField] private Button playBackButton;

    #endregion

    #region Join Menu

    [Header("Join Menu")]
    [SerializeField] private TMP_InputField lobbyCodeInput;
    [SerializeField] private Button joinButton;
    [SerializeField] private Button joinBackButton;

    #endregion

    #region Unity Lifecycle

    private void Start()
    {
        SetupButtons();
        ShowMainMenu();
    }

    #endregion

    #region Setup

    private void SetupButtons()
    {
        // Main menu
        if (playButton != null)
            playButton.onClick.AddListener(OnPlayClicked);

        if (settingsButton != null)
            settingsButton.onClick.AddListener(OnSettingsClicked);

        if (quitButton != null)
            quitButton.onClick.AddListener(OnQuitClicked);

        // Play menu
        if (createGameButton != null)
            createGameButton.onClick.AddListener(OnCreateGameClicked);

        if (joinGameButton != null)
            joinGameButton.onClick.AddListener(OnJoinGameClicked);

        if (playBackButton != null)
            playBackButton.onClick.AddListener(ShowMainMenu);

        // Join menu
        if (joinButton != null)
            joinButton.onClick.AddListener(OnJoinLobbyClicked);

        if (joinBackButton != null)
            joinBackButton.onClick.AddListener(ShowPlayMenu);
    }

    #endregion

    #region Panel Navigation

    private void ShowMainMenu()
    {
        SetPanelActive(mainMenuPanel, true);
        SetPanelActive(playMenuPanel, false);
        SetPanelActive(joinMenuPanel, false);
    }

    private void ShowPlayMenu()
    {
        SetPanelActive(mainMenuPanel, false);
        SetPanelActive(playMenuPanel, true);
        SetPanelActive(joinMenuPanel, false);
    }

    private void ShowJoinMenu()
    {
        SetPanelActive(mainMenuPanel, false);
        SetPanelActive(playMenuPanel, false);
        SetPanelActive(joinMenuPanel, true);
    }

    private void SetPanelActive(GameObject panel, bool active)
    {
        if (panel != null)
            panel.SetActive(active);
    }

    #endregion

    #region Button Callbacks

    private void OnPlayClicked()
    {
        ShowPlayMenu();
    }

    private void OnSettingsClicked()
    {
        Debug.Log("[MainMenu] Settings - Not implemented yet");
    }

    private void OnQuitClicked()
    {
        Debug.Log("[MainMenu] Quitting game...");
        Application.Quit();

        #if UNITY_EDITOR
        UnityEditor.EditorApplication.isPlaying = false;
        #endif
    }

    private void OnCreateGameClicked()
    {
        Debug.Log("[MainMenu] Creating lobby...");

        if (AppNetManager.Instance != null)
        {
            AppNetManager.Instance.StartHost();
        }
    }

    private void OnJoinGameClicked()
    {
        ShowJoinMenu();
    }

    private void OnJoinLobbyClicked()
    {
        string code = lobbyCodeInput != null ? lobbyCodeInput.text.Trim() : "";

        if (string.IsNullOrWhiteSpace(code))
        {
            Debug.LogWarning("[MainMenu] Join code is empty!");
            return;
        }

        SetPanelActive(joinMenuPanel, false);

        AppNetManager.Instance.StartClient(code);
    }

    #endregion
}