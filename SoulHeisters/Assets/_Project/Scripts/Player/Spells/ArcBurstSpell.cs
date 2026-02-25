using UnityEngine;

public class ArcBurstSpell : ISpell
{
    private PlayerReferences _refs;
    private PlayerCombat _combat;

    private float _radius;
    private float _damage;
    private float _manaCost;
    private float _cooldown;

    private float _nextCastTime;

    public ArcBurstSpell(float radius, float damage, float manaCost, float cooldown)
    {
        _radius = radius;
        _damage = damage;
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

        _combat.CastArcBurstServerRpc(_radius, _damage, _manaCost);
    }
}