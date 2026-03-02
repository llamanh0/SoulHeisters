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
    private float _lastCastTime;

    public float Cooldown => _cooldown;
    public float LastCastTime => _lastCastTime;

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

        _combat.CastSoulGuardServerRpc(_duration, _damageReduction, _manaCost);

        return SpellCastResult.Success;
    }
}