using Unity.Netcode;
using UnityEngine;
using TMPro;

public class PlayerNameDisplay : NetworkBehaviour
{
    [SerializeField] private Canvas nameCanvas;
    [SerializeField] private TextMeshProUGUI nameText;
    [SerializeField] private float heightOffset = 2.5f;

    private Transform _cameraTransform;

    private void Start()
    {
        if (nameCanvas == null)
        {
            var canvasGO = new GameObject("NameCanvas");
            canvasGO.transform.SetParent(transform);
            canvasGO.transform.localPosition = Vector3.up * heightOffset;

            nameCanvas = canvasGO.AddComponent<Canvas>();
            nameCanvas.renderMode = RenderMode.WorldSpace;
            nameCanvas.worldCamera = Camera.main;

            var scaler = canvasGO.AddComponent<UnityEngine.UI.CanvasScaler>();
            scaler.dynamicPixelsPerUnit = 10;

            var rect = nameCanvas.GetComponent<RectTransform>();
            rect.sizeDelta = new Vector2(3, 0.5f);
            rect.localScale = Vector3.one * 0.01f;

            var textGO = new GameObject("NameText");
            textGO.transform.SetParent(canvasGO.transform);
            textGO.transform.localPosition = Vector3.zero;

            nameText = textGO.AddComponent<TextMeshProUGUI>();
            nameText.fontSize = 36;
            nameText.alignment = TextAlignmentOptions.Center;
            nameText.color = Color.white;
            nameText.outlineWidth = 0.2f;
            nameText.outlineColor = Color.black;

            var textRect = nameText.GetComponent<RectTransform>();
            textRect.sizeDelta = new Vector2(300, 50);
            textRect.anchoredPosition = Vector3.zero;
        }

        if (IsOwner)
        {
            nameCanvas.gameObject.SetActive(false);
        }
    }

    public override void OnNetworkSpawn()
    {
        if (PlayerNameRegistry.Instance != null)
        {
            string playerName = PlayerNameRegistry.Instance.GetPlayerName(OwnerClientId);
            if (nameText != null)
                nameText.text = playerName;
        }
    }

    private void LateUpdate()
    {
        if (nameCanvas == null || IsOwner) return;

        if (_cameraTransform == null)
            _cameraTransform = Camera.main?.transform;

        if (_cameraTransform != null)
            nameCanvas.transform.LookAt(_cameraTransform);
    }
}