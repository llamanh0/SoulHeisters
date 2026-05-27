using UnityEngine;

public class RagdollController : MonoBehaviour
{
    private Rigidbody[] _boneRigidbodies;
    private Collider[] _boneColliders;
    private Animator _animator;
    private CharacterController _characterController;

    private void Awake()
    {
        _animator = GetComponent<Animator>();
        _characterController = GetComponentInParent<CharacterController>();

        _boneRigidbodies = GetComponentsInChildren<Rigidbody>();
        _boneColliders = GetComponentsInChildren<Collider>();

        Debug.Log($"[RagdollController] Found {_boneRigidbodies.Length} rigidbodies, {_boneColliders.Length} colliders");
        DisableRagdoll();
    }

    public void EnableRagdoll()
    {
        Debug.Log("[RagdollController] Enabling ragdoll");

        if (_animator != null)
        {
            _animator.enabled = false;
        }

        foreach (var rb in _boneRigidbodies)
        {
            if (rb == null) continue;
            rb.isKinematic = false;
            rb.useGravity = true;
            rb.linearVelocity = Vector3.zero;
            rb.angularVelocity = Vector3.zero;
        }

        foreach (var col in _boneColliders)
        {
            if (col == null) continue;

            if (col is CharacterController) continue;
            if (col == _characterController) continue;

            col.enabled = true;
        }

        Debug.Log("[RagdollController] Ragdoll enabled");
    }

    public void DisableRagdoll()
    {
        Debug.Log("[RagdollController] Disabling ragdoll");

        foreach (var rb in _boneRigidbodies)
        {
            if (rb == null) continue;
            rb.linearVelocity = Vector3.zero;
            rb.angularVelocity = Vector3.zero;
            rb.isKinematic = true;
            rb.useGravity = false;
        }

        foreach (var col in _boneColliders)
        {
            if (col == null) continue;

            if (col is CharacterController) continue;
            if (col == _characterController) continue;

            col.enabled = false;
        }

        if (_animator != null)
        {
            _animator.enabled = true;
        }

        Debug.Log("[RagdollController] Ragdoll disabled");
    }
}