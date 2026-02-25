using UnityEngine;

public class SoulGuardSpell : ISpell
{
    private PlayerReferences _refs;
    private PlayerCombat _combat;

    private float _duration;
    private float _damageReduction;
    private float _manaCost;
    private float _cooldown;

    private float _nextCastTime;

    public SoulGuardSpell(float duration, float damageReduction, float manaCost, float cooldown)
    {
        _duration = duration;
        _damageReduction = damageReduction;
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

        _combat.CastSoulGuardServerRpc(_duration, _damageReduction, _manaCost);
    }
}