using UnityEngine;

/// <summary>
/// Basit mermi atan spell (Bolt).
/// 
/// Mantik:
/// - Cooldown ve mana kontrolu yapar
/// - ServerRpc cagirip gercek mermiyi server'da olusturur
/// - Gorsel taraf PlayerCombat icindeki RPC ile dagitilir
/// </summary>
public class BoltSpell : ISpell
{
    private PlayerReferences _refs;

    private float _manaCost;
    private float _cooldown;

    private float _nextCastTime;
    private float _lastCastTime;

    public float Cooldown => _cooldown;
    public float LastCastTime => _lastCastTime;

    public BoltSpell(float manaCost, float cooldown)
    {
        _manaCost = manaCost;
        _cooldown = cooldown;
    }

    public void Initialize(PlayerReferences refs)
    {
        _refs = refs;
    }

    public SpellCastResult TryCast()
    {
        // Cooldown kontrolu
        if (Time.time < _nextCastTime)
            return SpellCastResult.OnCooldown;

        // Mana yeterli mi?
        if (_refs.Mana.CurrentMana.Value < _manaCost)
            return SpellCastResult.NotEnoughMana;

        // Cooldown zamanlarini guncelle
        _nextCastTime = Time.time + _cooldown;
        _lastCastTime = Time.time;

        // Gercek cast islemi PlayerCombat uzerinden server'a gider
        _refs.Combat.ExecuteBolt();

        return SpellCastResult.Success;
    }
}