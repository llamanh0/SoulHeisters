using UnityEngine;

/// <summary>
/// Oyuncunun etrafinda dairesel bir alan hasari veren spell.
/// 
/// Mantik:
/// - Cooldown ve mana kontrolu
/// - ServerRpc ile server'da Physics.OverlapSphere ile hedefleri bulma
/// - IDamageable araciligi ile hasar dagitma (server tarafinda)
/// </summary>
public class ArcBurstSpell : ISpell
{
    private PlayerReferences _refs;
    private PlayerCombat _combat;

    private float _radius;
    private float _damage;
    private float _manaCost;
    private float _cooldown;

    private float _nextCastTime;
    private float _lastCastTime;

    public float Cooldown => _cooldown;
    public float LastCastTime => _lastCastTime;

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

    public SpellCastResult TryCast()
    {
        // Yalnizca owner cast istegi gonderebilir
        if (!_combat.IsOwner)
            return SpellCastResult.OnCooldown;

        if (Time.time < _nextCastTime)
            return SpellCastResult.OnCooldown;

        // Client tarafli mana kontrolu (dogrulama server'da)
        if (_refs.Mana.CurrentMana.Value < _manaCost)
            return SpellCastResult.NotEnoughMana;

        _nextCastTime = Time.time + _cooldown;
        _lastCastTime = Time.time;

        // Gercek hasar islemi server tarafinda yapilir
        _combat.CastArcBurstServerRpc(_radius, _damage, _manaCost);

        return SpellCastResult.Success;
    }
}