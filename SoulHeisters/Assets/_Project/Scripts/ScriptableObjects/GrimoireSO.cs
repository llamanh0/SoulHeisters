using UnityEngine;

[CreateAssetMenu(fileName = "New Grimoire", menuName = "SoulHeisters/Grimoire")]
public class GrimoireSO : ScriptableObject
{
    [Header("Identity")]
    public string spellName;
    public Sprite icon;

    [Header("Stats")]
    public float cooldown = 0.5f;
    public float damage = 10f;
    public float lifetime = 3f;

    [Header("Physics")]
    public GameObject projectilePrefab;
    public float speed = 20f;
}