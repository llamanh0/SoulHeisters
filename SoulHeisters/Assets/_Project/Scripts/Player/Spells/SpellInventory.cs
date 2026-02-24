using System.Collections.Generic;
using Unity.Netcode;
using UnityEngine;

public class SpellInventory : NetworkBehaviour
{
    [SerializeField] private List<SpellDefinitionSO> startingSpells;

    private List<ISpell> _runtimeSpells = new();
    private int _currentIndex;

    private PlayerReferences _refs;

    public ISpell CurrentSpell => _runtimeSpells.Count > 0 ? _runtimeSpells[_currentIndex] : null;

    private void Awake()
    {
        _refs = GetComponent<PlayerReferences>();
    }

    public override void OnNetworkSpawn()
    {
        if (!IsOwner) return;

        foreach (var def in startingSpells)
        {
            AddSpell(def);
        }
    }

    public void AddSpell(SpellDefinitionSO def)
    {
        ISpell spell = SpellFactory.CreateSpell(def, _refs);
        spell.Initialize(_refs);

        _runtimeSpells.Add(spell);
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
}