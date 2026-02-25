using System.Collections.Generic;
using Unity.Netcode;
using UnityEngine;

public class SpellInventory : NetworkBehaviour
{
    [SerializeField] private List<SpellDefinitionSO> startingSpells;
    [SerializeField] private List<SpellDefinitionSO> allSpellDefinitions;

    private List<ISpell> _runtimeSpells = new();
    private int _currentIndex;

    private PlayerReferences _refs;

    public ISpell CurrentSpell => _runtimeSpells.Count > 0 ? _runtimeSpells[_currentIndex] : null;

    public override void OnNetworkSpawn()
    {
        _refs = GetComponent<PlayerReferences>();

        if (!IsOwner) return;

        foreach (var def in startingSpells)
        {
            AddSpell(def);
        }
    }
    public void AddSpell(SpellDefinitionSO def)
    {
        if (def == null)
        {
            Debug.LogError("SpellDefinition NULL");
            return;
        }

        if (_refs == null)
        {
            Debug.LogError("_refs NULL");
            return;
        }

        ISpell spell = SpellFactory.CreateSpell(def, _refs);

        if (spell == null)
        {
            Debug.LogError($"SpellFactory returned NULL for {def.spellType}");
            return;
        }

        spell.Initialize(_refs);
        _runtimeSpells.Add(spell);

        Debug.Log($"Spell added: {def.spellType}");
    }

    [ClientRpc]
    public void UnlockSpellClientRpc(SpellType type, ulong targetClientId)
    {
        Debug.Log($"RPC received on client {NetworkManager.Singleton.LocalClientId}");
        if (NetworkManager.Singleton.LocalClientId != targetClientId)
            return;

        var def = FindSpellDefinition(type);

        AddSpell(def);
    }

    private void Update()
    {
        if (!IsOwner) return;

        if (Input.GetKeyDown(KeyCode.Alpha1)) SwitchSpell(0);
        if (Input.GetKeyDown(KeyCode.Alpha2)) SwitchSpell(1);
        if (Input.GetKeyDown(KeyCode.Alpha3)) SwitchSpell(2);
        if (Input.GetKeyDown(KeyCode.Alpha4)) SwitchSpell(3);
    }

    private void SwitchSpell(int index)
    {
        if (index >= _runtimeSpells.Count) return;

        _currentIndex = index;

        Debug.Log($"Switch requested: {index}");
    }

    public SpellDefinitionSO FindSpellDefinition(SpellType type)
    {
        var def = allSpellDefinitions.Find(x => x.spellType == type);

        if (def == null)
            Debug.LogError($"SpellDefinition not found for type {type}");

        return def;
    }
}