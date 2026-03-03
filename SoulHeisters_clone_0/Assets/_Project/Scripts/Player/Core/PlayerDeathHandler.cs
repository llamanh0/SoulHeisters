using Cinemachine;
using Unity.Netcode;
using UnityEngine;

public class PlayerDeathHandler : NetworkBehaviour
{
    [Header("Camera Settings")]
    [Tooltip("After Die Cam")]
    [SerializeField] private CinemachineVirtualCamera deathCamera;

    [Header("Scripts to Disable")]
    [SerializeField] private MonoBehaviour[] scriptsToDisable;

    private PlayerReferences _refs;

    private void Awake()
    {
        _refs = GetComponent<PlayerReferences>();
        if (_refs == null) Debug.LogError("[PlayerDeathHandler] PlayerReferences can not be find!");
    }

    public override void OnNetworkSpawn()
    {
        if (_refs.Health != null)
        {
            _refs.Health.OnDeath += HandleDeath;
        }

        if (deathCamera != null)
        {
            deathCamera.gameObject.SetActive(IsOwner);
            if (IsOwner)
            {
                deathCamera.Priority = 5;
            }
        }
    }

    public override void OnNetworkDespawn()
    {
        if (_refs.Health != null)
        {
            _refs.Health.OnDeath -= HandleDeath;
        }
    }

    private void HandleDeath()
    {
        // Visuals
        _refs.Visual.HandleDeathVisual();

        // Disable player scripts (movement, combat, etc.)
        foreach (var script in scriptsToDisable)
            if (script != null) script.enabled = false;

        // Camera switch
        if (IsOwner && deathCamera != null)
            deathCamera.Priority = 20;
    }
}