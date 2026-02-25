using UnityEngine;

[CreateAssetMenu(menuName = "Spells/Spell Definition")]
public class SpellDefinitionSO : ScriptableObject
{
    public SpellType spellType;

    [Header("Common")]
    public float manaCost;
    public float cooldown;

    [Header("Projectile (Bolt)")]
    public GameObject serverPrefab;
    public GameObject visualPrefab;
    public float projectileSpeed;
    public float damage;
    public float fireRate;

    [Header("Blink")]
    public float range;

    [Header("ArcBurst")]
    public float radius;

    [Header("SoulGuard")]
    public float duration;
    public float damageReduction;
}