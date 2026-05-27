using Cinemachine;
using System.Collections;
using Unity.Netcode;
using UnityEngine;

public class PlayerDeathHandler : NetworkBehaviour
{
    [Header("Camera Settings")]
    [SerializeField] private CinemachineVirtualCamera deathCamera;
    [SerializeField] private CinemachineVirtualCamera normalCamera;

    [Header("Scripts to Disable")]
    [SerializeField] private MonoBehaviour[] scriptsToDisable;

    [Header("Respawn Settings")]
    [SerializeField] private float respawnDelay = 15f;

    private PlayerReferences _refs;
    private Coroutine _respawnCoroutine;

    private void Awake()
    {
        _refs = GetComponent<PlayerReferences>();
    }

    public override void OnNetworkSpawn()
    {
        if (_refs.Health != null)
        {
            _refs.Health.OnDeath += HandleDeath;
        }

        if (IsOwner)
        {
            if (deathCamera != null)
            {
                deathCamera.gameObject.SetActive(true);
                deathCamera.Priority = 5;
            }

            if (normalCamera != null)
            {
                normalCamera.Priority = 10;
            }
        }
        else
        {
            if (deathCamera != null)
                deathCamera.gameObject.SetActive(false);
        }
    }

    public override void OnNetworkDespawn()
    {
        if (_refs.Health != null)
        {
            _refs.Health.OnDeath -= HandleDeath;
        }

        if (_respawnCoroutine != null)
        {
            StopCoroutine(_respawnCoroutine);
        }
    }

    private void HandleDeath()
    {
        if (_refs.Health == null || !_refs.Health.IsDead)
        {
            Debug.LogWarning($"[PlayerDeathHandler] HandleDeath called but player not dead!");
            return;
        }

        Debug.Log($"[PlayerDeathHandler] Player {OwnerClientId} died");

        var controller = GetComponent<CharacterController>();
        if (controller != null)
        {
            controller.enabled = false;
            Debug.Log("[PlayerDeathHandler] CharacterController disabled");
        }

        _refs.Visual.HandleDeathVisual();

        foreach (var script in scriptsToDisable)
        {
            if (script != null)
                script.enabled = false;
        }

        if (IsOwner)
        {
            if (deathCamera != null)
            {
                deathCamera.Priority = 20;
                Debug.Log("[PlayerDeathHandler] Death camera activated");
            }

            if (normalCamera != null)
            {
                normalCamera.Priority = 5;
            }
        }

        if (IsServer)
        {
            if (_respawnCoroutine != null)
            {
                StopCoroutine(_respawnCoroutine);
            }
            _respawnCoroutine = StartCoroutine(RespawnRoutine());
        }
    }

    private IEnumerator RespawnRoutine()
    {
        Debug.Log($"[PlayerDeathHandler] Respawn in {respawnDelay}s for client {OwnerClientId}");
        yield return new WaitForSeconds(respawnDelay);

        if (GameStateManager.Instance == null || GameStateManager.Instance.CurrentState != GameState.Playing)
        {
            Debug.Log("[PlayerDeathHandler] Match ended, no respawn");
            _respawnCoroutine = null;
            yield break;
        }

        Respawn();
        _respawnCoroutine = null;
    }

    private void Respawn()
    {
        if (!IsServer) return;

        Debug.Log($"[PlayerDeathHandler] Respawning player {OwnerClientId}");

        var spawnSystem = FindObjectOfType<SpawnSystem>();
        if (spawnSystem == null)
        {
            Debug.LogError("[PlayerDeathHandler] SpawnSystem not found!");
            return;
        }

        Transform spawnPoint = spawnSystem.GetNextSpawnPoint();
        if (spawnPoint == null)
        {
            Debug.LogError("[PlayerDeathHandler] No spawn point available!");
            return;
        }

        if (_refs.Health != null)
        {
            _refs.Health.ResetHealth();
        }

        RespawnClientRpc(spawnPoint.position, spawnPoint.rotation);
    }

    [ClientRpc]
    private void RespawnClientRpc(Vector3 position, Quaternion rotation)
    {
        Debug.Log($"[PlayerDeathHandler] RespawnClientRpc received - Position: {position}");
        StartCoroutine(RespawnVisualRoutine(position, rotation));
    }

    private IEnumerator RespawnVisualRoutine(Vector3 position, Quaternion rotation)
    {
        Debug.Log("[PlayerDeathHandler] Starting respawn visual routine");

        _refs.Visual.ResetVisual();
        Debug.Log("[PlayerDeathHandler] Visual reset complete");

        yield return new WaitForSeconds(0.2f);

        var controller = GetComponent<CharacterController>();
        if (controller != null)
        {
            controller.enabled = false;
            Debug.Log($"[PlayerDeathHandler] Controller disabled before teleport");
        }

        yield return null;

        transform.position = position;
        transform.rotation = rotation;
        Debug.Log($"[PlayerDeathHandler] Transform set to: {position}");

        var networkTransform = GetComponent<ClientNetworkTransform>();
        if (networkTransform != null && IsOwner)
        {
            networkTransform.Teleport(position, rotation, transform.localScale);
            Debug.Log("[PlayerDeathHandler] NetworkTransform teleported");
        }

        yield return null;

        if (controller != null)
        {
            transform.position = position;
            controller.enabled = true;
            Debug.Log($"[PlayerDeathHandler] Controller enabled. State: {controller.enabled}");
        }

        foreach (var script in scriptsToDisable)
        {
            if (script != null)
                script.enabled = true;
        }
        Debug.Log("[PlayerDeathHandler] Scripts re-enabled");

        if (_refs.Locomotion != null)
        {
            _refs.Locomotion.ResetVerticalVelocity();
        }

        if (IsOwner)
        {
            if (deathCamera != null)
            {
                deathCamera.Priority = 5;
                Debug.Log("[PlayerDeathHandler] Death camera deactivated");
            }

            if (normalCamera != null)
            {
                normalCamera.Priority = 10;
                Debug.Log("[PlayerDeathHandler] Normal camera activated");
            }

            var spectateController = GetComponent<PlayerSpectateController>();
            if (spectateController != null)
            {
                spectateController.StopSpectating();
                Debug.Log("[PlayerDeathHandler] Spectate stopped");
            }
        }

        yield return new WaitForSeconds(0.3f);

        if (controller != null && !controller.enabled)
        {
            Debug.LogError($"[PlayerDeathHandler] CRITICAL: Controller still disabled! Force enabling...");
            controller.enabled = true;
        }

        Debug.Log($"[PlayerDeathHandler] Respawn complete. Controller: {controller != null && controller.enabled}");
    }
}