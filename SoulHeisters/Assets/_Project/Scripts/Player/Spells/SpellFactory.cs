/// <summary>
/// SpellDefinitionSO verisinden uygun ISpell implementasyonunu olusturan
/// basit factory sinifi.
/// </summary>
public static class SpellFactory
{
    /// <summary>
    /// Verilen tanima gore uygun ISpell instance'i olusturur.
    /// Initialize cagrisini SpellInventory'de yapariz.
    /// </summary>
    public static ISpell CreateSpell(
        SpellDefinitionSO def,
        PlayerReferences refs)
    {
        if (def == null) return null;

        switch (def.spellType)
        {
            case SpellType.Bolt:
                return new BoltSpell(
                    def.manaCost,
                    def.cooldown);

            case SpellType.Blink:
                return new BlinkSpell(
                    def.range,
                    def.manaCost,
                    def.cooldown);

            case SpellType.ArcBurst:
                return new ArcBurstSpell(
                    def.radius,
                    def.damage,
                    def.manaCost,
                    def.cooldown);

            case SpellType.SoulGuard:
                return new SoulGuardSpell(
                    def.duration,
                    def.damageReduction,
                    def.manaCost,
                    def.cooldown);

            default:
                return null;
        }
    }
}