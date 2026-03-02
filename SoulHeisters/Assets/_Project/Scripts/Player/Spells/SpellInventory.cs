using System.Collections.Generic;
using Unity.Netcode;
using UnityEngine;

public class SpellInventory : NetworkBehaviour
{
    [SerializeField] private List<SpellDefinitionSO> startingSpells;
    [SerializeField] private List<SpellDefinitionSO> allSpellDefinitions;
    [SerializeField] private SpellSlotUI[] spellSlots;

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

        RefreshUI();
    }
    public void AddSpell(SpellDefinitionSO def)
    {
        if (def == null && _refs == null) return;

        ISpell spell = SpellFactory.CreateSpell(def, _refs);

        if (spell == null) return;

        spell.Initialize(_refs);
        _runtimeSpells.Add(spell);

        RefreshUI();
    }

    [ClientRpc]
    public void UnlockSpellClientRpc(SpellType type, ulong targetClientId)
    {
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
    }

    public SpellDefinitionSO FindSpellDefinition(SpellType type)
    {
        var def = allSpellDefinitions.Find(x => x.spellType == type);

        return def;
    }

    private void RefreshUI()
    {
        for (int i = 0; i < spellSlots.Length; i++)
        {
            if (i < _runtimeSpells.Count)
            {
                spellSlots[i].gameObject.SetActive(true);
                spellSlots[i].Setup(_runtimeSpells[i]);
            }
            else
            {
                spellSlots[i].gameObject.SetActive(false);
            }
        }
    }

    public void HandleCastResult(SpellCastResult result)
    {
        if (!IsOwner) return;

        if (result == SpellCastResult.NotEnoughMana)
        {
            int index = _currentIndex;

            if (index < spellSlots.Length)
                spellSlots[index].PlayNotEnoughManaFeedback();
        }
    }
}