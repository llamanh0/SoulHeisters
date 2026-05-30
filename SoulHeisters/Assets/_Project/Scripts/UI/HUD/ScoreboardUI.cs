using System.Collections.Generic;
using TMPro;
using Unity.Netcode;
using UnityEngine;
using UnityEngine.InputSystem;

public class ScoreboardUI : MonoBehaviour
{
    [Header("UI References")]
    [SerializeField] private CanvasGroup scoreboardCanvasGroup;
    [SerializeField] private Transform playerListContent;
    [SerializeField] private GameObject playerRowPrefab;

    [Header("Stats")]
    [SerializeField] private TextMeshProUGUI fpsText;
    [SerializeField] private TextMeshProUGUI pingText;

    private List<GameObject> _activeRows = new List<GameObject>();
    private float _updateInterval = 0.5f;
    private float _lastUpdateTime;
    private bool _isVisible = false;

    private int _frameCount;
    private float _fpsTimer;
    private int _currentFPS;

    private void Start()
    {
        HideScoreboard();
    }

    private void Update()
    {
        UpdateFPS();
        HandleScoreboardInput();

        if (_isVisible)
        {
            if (Time.time - _lastUpdateTime >= _updateInterval)
            {
                _lastUpdateTime = Time.time;
                RefreshScoreboard();
            }
        }
    }

    private void HandleScoreboardInput()
    {
        if (Keyboard.current == null) return;

        bool tabPressed = Keyboard.current.tabKey.isPressed;

        if (tabPressed && !_isVisible)
        {
            ShowScoreboard();
        }
        else if (!tabPressed && _isVisible)
        {
            HideScoreboard();
        }
    }

    private void ShowScoreboard()
    {
        _isVisible = true;

        if (scoreboardCanvasGroup != null)
        {
            scoreboardCanvasGroup.alpha = 1f;
            scoreboardCanvasGroup.interactable = true;
            scoreboardCanvasGroup.blocksRaycasts = true;
        }

        RefreshScoreboard();
    }

    private void HideScoreboard()
    {
        _isVisible = false;

        if (scoreboardCanvasGroup != null)
        {
            scoreboardCanvasGroup.alpha = 0f;
            scoreboardCanvasGroup.interactable = false;
            scoreboardCanvasGroup.blocksRaycasts = false;
        }
    }

    private void UpdateFPS()
    {
        _frameCount++;
        _fpsTimer += Time.deltaTime;

        if (_fpsTimer >= 1f)
        {
            _currentFPS = _frameCount;
            _frameCount = 0;
            _fpsTimer = 0f;

            if (fpsText != null)
            {
                fpsText.text = $"FPS: {_currentFPS}";

                if (_currentFPS >= 60)
                    fpsText.color = Color.green;
                else if (_currentFPS >= 30)
                    fpsText.color = Color.yellow;
                else
                    fpsText.color = Color.red;
            }
        }
    }

    private void RefreshScoreboard()
    {
        ClearRows();

        if (ScoreboardManager.Instance == null) return;

        List<PlayerData> players = ScoreboardManager.Instance.GetAllPlayerData();

        foreach (var playerData in players)
        {
            CreatePlayerRow(playerData);
        }

        UpdatePingDisplay();
    }

    private void ClearRows()
    {
        foreach (var row in _activeRows)
        {
            if (row != null) Destroy(row);
        }
        _activeRows.Clear();
    }

    private void CreatePlayerRow(PlayerData data)
    {
        if (playerRowPrefab == null || playerListContent == null) return;

        GameObject row = Instantiate(playerRowPrefab, playerListContent);
        _activeRows.Add(row);

        var rowComponent = row.GetComponent<ScoreboardPlayerRow>();
        if (rowComponent != null)
        {
            bool isLocalPlayer = data.clientId == NetworkManager.Singleton.LocalClientId;
            rowComponent.Setup(data, isLocalPlayer);
        }
    }

    private void UpdatePingDisplay()
    {
        if (pingText == null) return;

        if (NetworkManager.Singleton == null || !NetworkManager.Singleton.IsClient)
        {
            pingText.text = "Ping: --";
            return;
        }

        int ping = GetPing(NetworkManager.ServerClientId);

        pingText.text = $"Ping: {ping}ms";

        if (ping < 50)
            pingText.color = Color.green;
        else if (ping < 100)
            pingText.color = Color.yellow;
        else
            pingText.color = Color.red;
    }

    private int GetPing(ulong clientId)
    {
        if (NetworkManager.Singleton == null) return 0;
        if (NetworkManager.Singleton.IsServer && clientId == NetworkManager.ServerClientId) return 0;

        try
        {
            var transport = NetworkManager.Singleton.NetworkConfig.NetworkTransport;
            ulong rtt = transport.GetCurrentRtt(clientId);

            return (int)(rtt / 2);
        }
        catch
        {
            return 0;
        }
    }
}