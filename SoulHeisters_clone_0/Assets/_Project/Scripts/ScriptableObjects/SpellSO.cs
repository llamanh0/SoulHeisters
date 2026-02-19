using UnityEngine;

[CreateAssetMenu(fileName = "NewSpell", menuName = "Soul Heisters/SpellSO")]
public class SpellSO : ScriptableObject
{
    public string spellName;
    public float damage;
    public float cooldown;
    public float manaCost;
    public Sprite icon;
    public GameObject spellPrefab;
}
