using UnityEngine;

/// <summary>
/// Objeyi her zaman kameraya dogru ceviren basit billboard scripti.
/// 
/// Genellikle dunya uzerindeki health bar veya isim etiketleri icin kullanilir.
/// </summary>
public class Billboard : MonoBehaviour
{
    private Camera _mainCamera;

    private void Start()
    {
        _mainCamera = Camera.main;
    }

    private void LateUpdate()
    {
        // Kamera referansi yoksa tekrar bulmayi dene
        if (_mainCamera == null) _mainCamera = Camera.main;
        if (_mainCamera == null) return;

        // Kamera hangi yone bakiyorsa o yonde yuz tut
        transform.LookAt(transform.position + _mainCamera.transform.forward);
    }
}