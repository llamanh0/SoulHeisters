using UnityEngine;

[CreateAssetMenu(menuName = "Spells/Spell Definition")]
public class SpellDefinitionSO : ScriptableObject
{
    public SpellType spellType;

    [Header("Common")]
    public float manaCost;
    public float cooldown;

    [Header("Bolt")]
    public float damage;
    public float projectileSpeed;

    [Header("Blink")]
    public float range;

    [Header("ArcBurst")]
    public float radius;

    [Header("SoulGuard")]
    public float duration;
    public float damageReduction;
}