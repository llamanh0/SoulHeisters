using DG.Tweening;
using UnityEngine;

/// <summary>
/// Oyuncuyu ileri dogru belirli bir mesafeye teleport eden spell.
/// 
/// Mantik:
/// - Crosshair dogrultusunda raycast yapar, hit noktasini veya max mesafeyi hedef alir
/// - Cooldown ve mana kontrolu yapar
/// - ServerRpc ile server'a cast bildirir
/// - Local olarak kucuk bir kamera shake ve FOV efekti oynatir
/// </summary>
public class BlinkSpell : ISpell
{
    private PlayerReferences _refs;
    private PlayerCombat _combat;

    private float _range;
    private float _manaCost;
    private float _cooldown;

    private float _lastCastTime;
    private float _nextCastTime;

    public float Cooldown => _cooldown;
    public float LastCastTime => _lastCastTime;

    public BlinkSpell(float range, float manaCost, float cooldown)
    {
        _range = range;
        _manaCost = manaCost;
        _cooldown = cooldown;
    }

    public void Initialize(PlayerReferences refs)
    {
        _refs = refs;
        _combat = refs.Combat;
    }

    public SpellCastResult TryCast()
    {
        // Yalnizca owner spell cast istegi gonderebilir
        if (!_combat.IsOwner)
            return SpellCastResult.OnCooldown;

        // Cooldown kontrolu
        if (Time.time < _nextCastTime)
            return SpellCastResult.OnCooldown;

        // Mana kontrolu (client tarafli; gercek kontrol server'da)
        if (_refs.Mana.CurrentMana.Value < _manaCost)
            return SpellCastResult.NotEnoughMana;

        _nextCastTime = Time.time + _cooldown;
        _lastCastTime = Time.time;

        // Kamera shake / FOV efekti
        PlayBlinkCameraEffect();

        // Hedef noktayi hesapla ve server'a bildir
        Vector3 targetPoint = GetBlinkPoint();
        _combat.CastBlinkServerRpc(targetPoint, _manaCost);

        return SpellCastResult.Success;
    }

    /// <summary>
    /// Local kamerada kucuk bir efekt (shake + FOV pump) oynatir.
    /// </summary>
    private void PlayBlinkCameraEffect()
    {
        if (Camera.main == null) return;

        var cam = Camera.main;

        cam.transform.DOShakePosition(0.15f, 0.2f, 20, 90, false, true);

        float originalFov = cam.fieldOfView;

        cam.DOFieldOfView(originalFov + 10f, 0.05f)
           .OnComplete(() =>
                cam.DOFieldOfView(originalFov, 0.1f));
    }

    /// <summary>
    /// Ekranin ortasindan bir ray atarak blink hedef noktasini belirler.
    /// Max range dahilinde bir hit varsa onu, yoksa ray uzerinde sabit mesafeyi kullanir.
    /// </summary>
    private Vector3 GetBlinkPoint()
    {
        Camera cam = Camera.main;
        Ray ray = cam.ViewportPointToRay(new Vector3(0.5f, 0.5f));

        Debug.DrawLine(ray.origin, ray.origin + ray.direction * _range, Color.cyan, 0.2f);

        if (Physics.Raycast(ray, out RaycastHit hit, _range))
            return hit.point;

        return ray.GetPoint(_range);
    }
}