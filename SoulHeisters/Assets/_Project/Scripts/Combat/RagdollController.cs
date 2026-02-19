using UnityEngine;

public class RagdollController : MonoBehaviour
{
    private Rigidbody[] _boneRigidbodies;
    private Collider[] _boneColliders;
    private Animator _animator;

    private void Awake()
    {
        _animator = GetComponent<Animator>();

        // Hiyerarşinin altındaki tüm kemik fiziklerini bul
        _boneRigidbodies = GetComponentsInChildren<Rigidbody>();
        _boneColliders = GetComponentsInChildren<Collider>();

        DisableRagdoll(); // Oyun başlarken fizik kapalı, animasyon açık olsun
    }

    public void EnableRagdoll()
    {
        _animator.enabled = false; // Animasyonu kapat ki fizik devreye girsin

        foreach (var rb in _boneRigidbodies)
        {
            rb.isKinematic = false; // Fizik motoruna teslim et
            rb.useGravity = true;
        }

        foreach (var col in _boneColliders)
        {
            col.enabled = true; // Çarpışmaları aç
        }
    }

    public void DisableRagdoll()
    {
        _animator.enabled = true; // Animasyonu geri aç

        foreach (var rb in _boneRigidbodies)
        {
            rb.isKinematic = true; // Fiziği durdur, animasyonu takip et
        }

        foreach (var col in _boneColliders)
        {
            // İsteğe bağlı: Normalde kemik collider'ları mermi algılamak için açık kalabilir.
            // Eğer Hitbox sistemi kullanacaksan burayı silme, kalsın.
            // col.enabled = false; 
        }
    }
}