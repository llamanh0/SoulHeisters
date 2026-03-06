using UnityEngine;

/// <summary>
/// Belirli sure boyunca gelen hasari azaltan defensif spell.
/// 
/// Mantik:
/// - Cooldown ve mana kontrolu
/// - ServerRpc ile server tarafinda damage reduction uygular
/// - Tum client'larda belirli sure VFX gosterilir
/// </summary>
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
        // Yalnizca owner cast istegi gonderebilir
        if (!_combat.IsOwner)
            return SpellCastResult.OnCooldown;

        if (Time.time < _nextCastTime)
            return SpellCastResult.OnCooldown;

        if (_refs.Mana.CurrentMana.Value < _manaCost)
            return SpellCastResult.NotEnoughMana;

        _nextCastTime = Time.time + _cooldown;
        _lastCastTime = Time.time;

        // Server tarafinda damage reduction uygula
        _combat.CastSoulGuardServerRpc(_duration, _damageReduction, _manaCost);

        return SpellCastResult.Success;
    }
}