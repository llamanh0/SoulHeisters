using UnityEngine;
using System.Collections.Generic;

[CreateAssetMenu(menuName = "Mob/Mob Type")]
public class MobTypeSO : ScriptableObject
{
    public string mobName;
    public GameObject prefab;
    public RuntimeAnimatorController animatorController;
    public float maxHealth = 100f;
    public float moveSpeed = 3f;
    public float attackDamage = 15f;
    public float attackRange = 2f;
    public float attackCooldown = 1.5f;
    public float aggroRange = 10f;
    public int soulReward = 1;
    public List<GameObject> soulPrefabs = new();
}