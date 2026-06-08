using Unity.Netcode;
using UnityEngine;
using Cinemachine;
using System.Collections;

public class PlayerDeathHandler : NetworkBehaviour
{
    [SerializeField] private CinemachineVirtualCamera deathCamera;
    [SerializeField] private CinemachineVirtualCamera normalCamera;
    [SerializeField] private MonoBehaviour[] scriptsToDisable;
    [SerializeField] private float respawnDelay = 15f;
    [SerializeField] private float soulIgnoreDuration = 2f;
    [SerializeField] private AudioClip deathSound;
    [SerializeField] private float deathSoundVolume = 0.7f;

    private PlayerReferences _refs;
    private Coroutine _respawnCoroutine;

    private void Awake()
    {
        _refs = GetComponent<PlayerReferences>();
    }

    public override void OnNetworkSpawn()
    {
        if (_refs.Health != null)
            _refs.Health.OnDeath += HandleDeath;

        if (IsOwner)
        {
            if (deathCamera)
            {
                deathCamera.gameObject.SetActive(true);
                deathCamera.Priority = 5;
            }
            if (normalCamera)
                normalCamera.Priority = 10;
        }
        else if (deathCamera)
        {
            deathCamera.gameObject.SetActive(false);
        }
    }

    public override void OnNetworkDespawn()
    {
        if (_refs.Health != null)
            _refs.Health.OnDeath -= HandleDeath;

        if (_respawnCoroutine != null)
            StopCoroutine(_respawnCoroutine);
    }

    private void HandleDeath()
    {
        if (_refs.Health == null || !_refs.Health.IsDead) return;

        var c = GetComponent<CharacterController>();
        if (c != null)
            c.enabled = false;

        _refs.Visual.HandleDeathVisual();

        foreach (var s in scriptsToDisable)
            if (s != null)
                s.enabled = false;

        if (IsOwner)
        {
            if (deathCamera)
                deathCamera.Priority = 20;
            if (normalCamera)
                normalCamera.Priority = 5;
        }

        PlayDeathSoundClientRpc(transform.position);

        if (IsServer)
        {
            if (_respawnCoroutine != null)
                StopCoroutine(_respawnCoroutine);
            _respawnCoroutine = StartCoroutine(RespawnRoutine());
        }
    }

    [ClientRpc]
    private void PlayDeathSoundClientRpc(Vector3 pos)
    {
        if (deathSound != null)
            AudioSource.PlayClipAtPoint(deathSound, pos, deathSoundVolume);
    }

    private IEnumerator RespawnRoutine()
    {
        yield return new WaitForSeconds(respawnDelay);

        if (GameStateManager.Instance != null && GameStateManager.Instance.CurrentState == GameState.Playing)
            Respawn();

        _respawnCoroutine = null;
    }

    private void Respawn()
    {
        if (!IsServer) return;

        var ss = FindObjectOfType<SpawnSystem>();
        if (ss == null) return;

        var pt = ss.GetNextSpawnPoint();
        if (pt == null) return;

        _refs.Health?.ResetHealth();

        SoulPickup.MarkPlayerAsRespawned(OwnerClientId, soulIgnoreDuration);
        Invoke(nameof(ClearRespawnFlag), soulIgnoreDuration);

        RespawnClientRpc(pt.position, pt.rotation);
    }

    private void ClearRespawnFlag()
    {
        SoulPickup.ClearRespawnedPlayer(OwnerClientId);
    }

    [ClientRpc]
    private void RespawnClientRpc(Vector3 pos, Quaternion rot)
    {
        StartCoroutine(RespawnVisualRoutine(pos, rot));
    }

    private IEnumerator RespawnVisualRoutine(Vector3 pos, Quaternion rot)
    {
        _refs.Visual.ResetVisual();

        yield return new WaitForSeconds(0.2f);

        var c = GetComponent<CharacterController>();
        if (c != null)
            c.enabled = false;

        yield return null;

        transform.position = pos;
        transform.rotation = rot;

        if (IsOwner)
            GetComponent<ClientNetworkTransform>()?.Teleport(pos, rot, transform.localScale);

        yield return null;

        if (c != null)
        {
            transform.position = pos;
            c.enabled = true;
        }

        foreach (var s in scriptsToDisable)
            if (s != null)
                s.enabled = true;

        _refs.Locomotion?.ResetVerticalVelocity();

        if (IsOwner)
        {
            if (deathCamera)
                deathCamera.Priority = 5;
            if (normalCamera)
                normalCamera.Priority = 10;

            GetComponent<PlayerSpectateController>()?.StopSpectating();
        }

        yield return new WaitForSeconds(0.3f);

        if (c != null && !c.enabled)
            c.enabled = true;
    }
}