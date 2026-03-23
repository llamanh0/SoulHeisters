using Unity.Netcode;
using UnityEngine;
using UnityEngine.SceneManagement;
using TMPro;

public class MatchEndUI : MonoBehaviour
{
    [SerializeField] private GameObject rootCanvas;
    [SerializeField] private TextMeshProUGUI titleText;
    [SerializeField] private TextMeshProUGUI infoText;

    private void Awake()
    {
        if (rootCanvas != null)
            rootCanvas.SetActive(false);
    }

    private void OnEnable()
    {
        if (GameStateManager.Instance != null)
        {
            GameStateManager.Instance.OnMatchEnded += HandleMatchEnded;
        }
    }

    private void OnDisable()
    {
        if (GameStateManager.Instance != null)
        {
            GameStateManager.Instance.OnMatchEnded -= HandleMatchEnded;
        }
    }

    private void HandleMatchEnded()
    {
        if (rootCanvas != null)
            rootCanvas.SetActive(true);

        if (titleText != null)
            titleText.text = "MATCH ENDED";

        if (infoText != null)
            infoText.text = "Press ESC to return to lobby";
    }

    private void Update()
    {
        if (rootCanvas == null || !rootCanvas.activeSelf) return;

        if (Input.GetKeyDown(KeyCode.Escape))
        {
            ReturnToLobby();
        }
    }

    private void ReturnToLobby()
    {
        // Tüm network baglantisini kapat
        if (NetworkManager.Singleton != null)
        {
            NetworkManager.Singleton.Shutdown();
        }

        // MainMenu sahnesine don
        SceneManager.LoadScene("MainMenu");
    }
}