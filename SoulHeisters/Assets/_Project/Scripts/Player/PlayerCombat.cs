using System.Collections.Generic;
using Unity.Netcode;
using UnityEngine;

public class PlayerCombat : NetworkBehaviour
{
    [Header("Configuration")]
    [SerializeField] private GrimoireSO currentGrimoire;
    [SerializeField] private Transform firePoint;
    [SerializeField] private LayerMask aimColliderMask = new LayerMask();

    [Header("Voice Settings")]
    [SerializeField] private bool enableVoiceCommands = true;

    private readonly Dictionary<string, string> _voiceKeywordMap = new Dictionary<string, string>
    {
        { "fireball", "Fireball" },
        { "fire", "Fireball" },
        { "burn", "Fireball" }, // Aliases
        // { "shield", "Shield" } // Future spells
    };

    [Header("Debug")]
    [SerializeField] private bool showDebugRay = true;

    private PlayerInputHandler _input;
    private Camera _mainCamera;
    private float _lastFireTime;



    private void Awake()
    {
        _input = GetComponent<PlayerInputHandler>();
    }

    public override void OnNetworkSpawn()
    {
        if (IsOwner)
        {
            _mainCamera = Camera.main;
            if (_mainCamera == null) Debug.LogError("[PlayerCombat] Main Camera not found!");

            VoiceCommandManager.Instance.OnCommandRecognized += ProcessVoiceCommand;
        }
    }

    public override void OnNetworkDespawn()
    {
        if (IsOwner && VoiceCommandManager.Instance != null)
        {
            VoiceCommandManager.Instance.OnCommandRecognized -= ProcessVoiceCommand;
        }
    }

    private void Update()
    {
        if (!IsOwner) return;

        if (_input.FireInput && Time.time >= _lastFireTime + currentGrimoire.cooldown)
        {
            HandleShooting();
        }
    }

    private void ProcessVoiceCommand(string rawText)
    {
        if (!enableVoiceCommands) return;

        string cleanText = rawText.ToLowerInvariant();

        foreach (var entry in _voiceKeywordMap)
        {
            if (cleanText.Contains(entry.Key))
            {
                Debug.Log($"[Combat] Voice Trigger: {entry.Value}");
                CastSpellByName(entry.Value);
                return;
            }
        }
    }

    private void CastSpellByName(string spellName)
    {
        if (currentGrimoire.spellName == spellName)
        {
            HandleShooting();
        }
        else
        {
            Debug.LogWarning("Spell switching not implemented yet, but command received!");
        }
    }

    private void HandleShooting()
    {
        _lastFireTime = Time.time;

        Vector3 targetPoint = GetCrosshairHitPoint();

        Vector3 aimDirection = (targetPoint - firePoint.position).normalized;

        Quaternion targetRotation = Quaternion.LookRotation(aimDirection);
        RequestFireServerRpc(firePoint.position, targetRotation);
    }

    private Vector3 GetCrosshairHitPoint()
    {
        Ray ray = _mainCamera.ViewportPointToRay(new Vector3(0.5f, 0.5f, 0f));
        RaycastHit hit;

        if (Physics.Raycast(ray, out hit, 1000f, aimColliderMask))
        {
            if (showDebugRay) Debug.DrawLine(ray.origin, hit.point, Color.green, 1f);
            return hit.point;
        }
        else
        {
            if (showDebugRay) Debug.DrawRay(ray.origin, ray.direction * 1000f, Color.red, 1f);
            return ray.GetPoint(100f); // 100 units forward
        }
    }

    [ServerRpc]
    private void RequestFireServerRpc(Vector3 position, Quaternion rotation, ServerRpcParams rpcParams = default)
    {
        GameObject projectileFn = Instantiate(currentGrimoire.projectilePrefab, position, rotation);

        if (projectileFn.TryGetComponent(out ProjectileController controller))
        {
            controller.Initialize(currentGrimoire.speed, currentGrimoire.damage, rpcParams.Receive.SenderClientId);
        }

        projectileFn.GetComponent<NetworkObject>().Spawn();

        Destroy(projectileFn, currentGrimoire.lifetime);
    }
}