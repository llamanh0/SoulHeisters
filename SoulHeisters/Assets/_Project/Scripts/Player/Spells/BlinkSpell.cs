using UnityEngine;

public class BlinkSpell : ISpell
{
    private PlayerReferences _refs;
    private PlayerCombat _combat;

    private float _range;
    private float _manaCost;
    private float _cooldown;

    private float _nextCastTime;

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

    public void TryCast()
    {
        if (!_combat.IsOwner) return;
        if (Time.time < _nextCastTime) return;
        if (_refs.Mana.CurrentMana.Value < _manaCost) return;

        _nextCastTime = Time.time + _cooldown;

        Vector3 targetPoint = GetBlinkPoint();

        _combat.CastBlinkServerRpc(targetPoint, _manaCost);
    }

    private Vector3 GetBlinkPoint()
    {
        Camera cam = Camera.main;
        Ray ray = cam.ViewportPointToRay(new Vector3(0.5f, 0.5f));

        if (Physics.Raycast(ray, out RaycastHit hit, _range))
            return hit.point;

        return ray.GetPoint(_range);
    }
}