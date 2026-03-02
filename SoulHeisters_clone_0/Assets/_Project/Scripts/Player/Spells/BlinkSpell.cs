using DG.Tweening;
using UnityEngine;

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
        if (!_combat.IsOwner)
            return SpellCastResult.OnCooldown;

        if (Time.time < _nextCastTime)
            return SpellCastResult.OnCooldown;

        if (_refs.Mana.CurrentMana.Value < _manaCost)
            return SpellCastResult.NotEnoughMana;

        _nextCastTime = Time.time + _cooldown;
        _lastCastTime = Time.time;

        PlayBlinkCameraEffect();

        Vector3 targetPoint = GetBlinkPoint();
        _combat.CastBlinkServerRpc(targetPoint, _manaCost);

        return SpellCastResult.Success;
    }
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

    private Vector3 GetBlinkPoint()
    {
        Camera cam = Camera.main;
        Ray ray = cam.ViewportPointToRay(new Vector3(0.5f, 0.5f));
        
        Debug.DrawLine(ray.origin, ray.direction);

        if (Physics.Raycast(ray, out RaycastHit hit, _range))
            return hit.point;

        return ray.GetPoint(_range);
    }
}