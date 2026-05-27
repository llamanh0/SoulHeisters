using Unity.Netcode;
using UnityEngine;
using UnityEngine.UI;

public class CrosshairController : MonoBehaviour
{
    [Header("Crosshair Parts")]
    [SerializeField] private Image topLine;
    [SerializeField] private Image bottomLine;
    [SerializeField] private Image leftLine;
    [SerializeField] private Image rightLine;

    [Header("Colors")]
    [SerializeField] private Color defaultColor = new Color(1f, 1f, 1f, 0.8f);
    [SerializeField] private Color enemyColor = new Color(1f, 0f, 0f, 1f);

    [Header("Settings")]
    [SerializeField] private float raycastDistance = 200f;

    private Camera _mainCamera;

    private void Update()
    {
        if (_mainCamera == null)
        {
            _mainCamera = Camera.main;
            if (_mainCamera == null) return;
        }

        CheckForEnemy();
    }

    private void CheckForEnemy()
    {
        Ray ray = _mainCamera.ViewportPointToRay(new Vector3(0.5f, 0.5f, 0f));
        RaycastHit[] hits = Physics.RaycastAll(ray, raycastDistance);

        foreach (var hit in hits)
        {
            if (hit.collider.GetComponentInParent<MobAIController>() != null)
            {
                var health = hit.collider.GetComponentInParent<HealthComponent>();
                if (health != null && !health.IsDead)
                {
                    SetCrosshairColor(enemyColor);
                    return;
                }
            }
        }

        SetCrosshairColor(defaultColor);
    }

    private void SetCrosshairColor(Color color)
    {
        if (topLine != null) topLine.color = color;
        if (bottomLine != null) bottomLine.color = color;
        if (leftLine != null) leftLine.color = color;
        if (rightLine != null) rightLine.color = color;
    }
}