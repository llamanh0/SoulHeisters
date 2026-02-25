public static class SpellFactory
{
    public static ISpell CreateSpell(
        SpellDefinitionSO def,
        PlayerReferences refs)
    {
        switch (def.spellType)
        {
            case SpellType.Bolt:
                return new BoltSpell(
                    def.spellType,
                    refs.Combat.FirePoint,
                    def.serverPrefab,
                    def.visualPrefab,
                    def.projectileSpeed,
                    def.damage,
                    def.manaCost);

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