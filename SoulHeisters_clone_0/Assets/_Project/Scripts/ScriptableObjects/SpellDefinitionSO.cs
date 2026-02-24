using UnityEngine;

[CreateAssetMenu(menuName = "Spells/Spell Definition")]
public class SpellDefinitionSO : ScriptableObject
{
    public string spellName;
    public SpellType spellType;

    public GameObject serverPrefab;
    public GameObject visualPrefab;

    public float damage;
    public float manaCost;
    public float fireRate;
    public float projectileSpeed;
}