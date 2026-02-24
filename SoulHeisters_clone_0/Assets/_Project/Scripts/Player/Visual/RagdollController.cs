using UnityEngine;

public class RagdollController : MonoBehaviour
{
    private Rigidbody[] _boneRigidbodies;
    private Collider[] _boneColliders;
    private Animator _animator;

    private void Awake()
    {
        _animator = GetComponent<Animator>();

        _boneRigidbodies = GetComponentsInChildren<Rigidbody>();
        _boneColliders = GetComponentsInChildren<Collider>();

        DisableRagdoll();
    }

    public void EnableRagdoll()
    {
        _animator.enabled = false;

        foreach (var rb in _boneRigidbodies)
        {
            rb.isKinematic = false;
            rb.useGravity = true;
        }

        foreach (var col in _boneColliders)
        {
            col.enabled = true;
        }
    }

    public void DisableRagdoll()
    {
        _animator.enabled = true;

        foreach (var rb in _boneRigidbodies)
        {
            rb.isKinematic = true;
        }

        foreach (var col in _boneColliders)
        {
            // İsteğe bağlı: Normalde kemik collider'ları mermi algılamak için açık kalabilir.
            // Eğer Hitbox sistemi kullanacaksan burayı silme, kalsın.
            // col.enabled = false; 
        }
    }
}