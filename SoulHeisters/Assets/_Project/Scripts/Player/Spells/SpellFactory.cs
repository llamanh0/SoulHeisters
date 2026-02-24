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
                    refs.Combat.FirePoint,
                    def.serverPrefab,
                    def.visualPrefab,
                    def.projectileSpeed,
                    def.damage,
                    def.manaCost,
                    def.fireRate);

            default:
                return null;
        }
    }
}