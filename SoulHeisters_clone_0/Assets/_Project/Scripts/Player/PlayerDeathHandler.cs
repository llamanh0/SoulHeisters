using Unity.Netcode;
using UnityEngine;
using Cinemachine;

public class PlayerDeathHandler : NetworkBehaviour
{
    [Header("References")]
    [SerializeField] private HealthComponent healthComponent;
    [SerializeField] private RagdollController ragdollController;
    [SerializeField] private Collider mainCapsuleCollider;
    //[SerializeField] private Rigidbody mainRigidbody;

    [Header("Camera Settings")]
    [Tooltip("After Die Cam")]
    [SerializeField] private CinemachineVirtualCamera deathCamera;

    [Header("Scripts to Disable")]
    [SerializeField] private MonoBehaviour[] scriptsToDisable;

    public override void OnNetworkSpawn()
    {
        if (healthComponent != null)
        {
            healthComponent.OnDeath += HandleDeath;
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
        if (healthComponent != null)
        {
            healthComponent.OnDeath -= HandleDeath;
        }
    }

    private void HandleDeath()
    {
        if (mainCapsuleCollider != null) mainCapsuleCollider.enabled = false;

        //if (mainRigidbody != null)
        //{
        //    mainRigidbody.isKinematic = true;
        //    mainRigidbody.velocity = Vector3.zero;
        //}

        foreach (var script in scriptsToDisable)
        {
            if (script != null) script.enabled = false;
        }

        if (ragdollController != null) ragdollController.EnableRagdoll();

        if (IsOwner && deathCamera != null)
        {
            deathCamera.Priority = 20;
        }
    }
}