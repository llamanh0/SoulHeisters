using UnityEngine;

public class BoltSpell : ISpell
{
    private PlayerReferences _refs;
    private SpellType _type;
    private float _manaCost;
    private float _cooldown;

    private float _nextCastTime;
    private float _lastCastTime;

    public float Cooldown => _cooldown;
    public float LastCastTime => _lastCastTime;

    public BoltSpell(SpellType type, float manaCost, float cooldown)
    {
        _type = type;
        _manaCost = manaCost;
        _cooldown = cooldown;
    }

    public void Initialize(PlayerReferences refs)
    {
        _refs = refs;
    }

    public SpellCastResult TryCast()
    {
        if (Time.time < _nextCastTime)
            return SpellCastResult.OnCooldown;

        if (_refs.Mana.CurrentMana.Value < _manaCost)
            return SpellCastResult.NotEnoughMana;

        _nextCastTime = Time.time + _cooldown;
        _lastCastTime = Time.time;

        _refs.Combat.ExecuteSpell(_type);

        return SpellCastResult.Success;
    }
}