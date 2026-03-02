public interface ISpell
{
    float Cooldown { get; }
    float LastCastTime { get; }
    void Initialize(PlayerReferences refs);
    SpellCastResult TryCast();
}