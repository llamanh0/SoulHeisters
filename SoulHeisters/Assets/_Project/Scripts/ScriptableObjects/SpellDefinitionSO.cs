using UnityEngine;

/// <summary>
/// Bir spell tipine ait static verileri tutan ScriptableObject.
/// 
/// Kullanimi:
/// - Inspector uzerinden bir SpellDefinition olusturulur.
/// - SpellFactory bu verilerden uygun ISpell instance'i cikarir.
/// </summary>
[CreateAssetMenu(menuName = "Spells/Spell Definition")]
public class SpellDefinitionSO : ScriptableObject
{
    public SpellType spellType;

    [Header("Common")]
    public float manaCost;
    public float cooldown;

    [Header("Damage")]
    public float damage;

    [Header("Bolt")]
    public float projectileSpeed;

    [Header("Blink")]
    public float range;

    [Header("ArcBurst")]
    public float radius;

    [Header("SoulGuard")]
    public float duration;
    public float damageReduction;
}