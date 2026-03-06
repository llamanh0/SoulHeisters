using UnityEngine;

/// <summary>
/// Animator ile fiziksel ragdoll arasinda gecis yapan kontrol sinifi.
/// 
/// Sorumluluklar:
/// - Tum kemik rigidbody ve collider'larini bulmak
/// - Normal durumda animator aktif, rigidbody'ler kinematic
/// - Ragdoll durumunda animator kapali, rigidbody'ler fizik ile serbest
/// </summary>
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

    /// <summary>
    /// Ragdoll'u aktive eder: Animator'u kapatir, tum kemik rigidbody'leri
    /// fiziksel olarak serbest birakir.
    /// </summary>
    public void EnableRagdoll()
    {
        if (_animator != null)
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

    /// <summary>
    /// Ragdoll'u devre disi birakir: Animator'u acar, tum kemik rigidbody'leri
    /// kinematic moda alir.
    /// </summary>
    public void DisableRagdoll()
    {
        if (_animator != null)
            _animator.enabled = true;

        foreach (var rb in _boneRigidbodies)
        {
            rb.isKinematic = true;
        }

        // Not:
        // Burada collider'lari kapatmak istege bagli.
        // Eger kemikler mermi carpmasi icin hitbox olarak kullanilacaksa
        // collider'lari acik birakmak isteyebilirsin.
        // su an kapatmiyoruz.
        // foreach (var col in _boneColliders)
        // {
        //     col.enabled = false;
        // }
    }
}