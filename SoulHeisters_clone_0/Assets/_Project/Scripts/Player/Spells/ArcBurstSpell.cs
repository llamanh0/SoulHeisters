using UnityEngine;

public class ArcBurstSpell : ISpell
{
    private PlayerReferences _refs;
    private PlayerCombat _combat;

    private GameObject _visualPrefab;

    private float _radius;
    private float _damage;
    private float _manaCost;
    private float _cooldown;

    private float _nextCastTime;
    private float _lastCastTime;

    public float Cooldown => _cooldown;
    public float LastCastTime => _lastCastTime;

    public ArcBurstSpell(float radius, float damage, float manaCost, float cooldown, GameObject visualPrefab)
    {
        _radius = radius;
        _damage = damage;
        _manaCost = manaCost;
        _cooldown = cooldown;
        _visualPrefab = visualPrefab;
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

        SpawnLocalVisual(_combat.FirePoint.position);

        _combat.CastArcBurstServerRpc(_radius, _damage, _manaCost);

        return SpellCastResult.Success;
    }
    private void SpawnLocalVisual(Vector3 position)
    {
        GameObject visualObj =
            Object.Instantiate(_visualPrefab, position, Quaternion.identity);

        Object.Destroy(visualObj, 5f);
    }
}