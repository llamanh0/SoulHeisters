using System.Collections.Generic;
using Unity.Netcode;
using UnityEngine;

/// <summary>
/// Oyuncunun sahip oldugu spell'leri ve aktif spell secimini yonetir.
/// 
/// Sorumluluklar:
/// - Baslangic spell'lerini (startingSpells) olusturmak
/// - SpellDefinitionSO'dan runtime ISpell objeleri olusturmak
/// - Klavye (1-4) ile spell slot degistirmek
/// - Spell cast sonuclarini UI'ya iletmek
/// - Pickup vb. ile yeni spell acilimini ClientRpc ile almak
/// </summary>
public class SpellInventory : NetworkBehaviour
{
    [SerializeField] private List<SpellDefinitionSO> startingSpells;
    [SerializeField] private List<SpellDefinitionSO> allSpellDefinitions;
    [SerializeField] private SpellSlotUI[] spellSlots;

    private List<ISpell> _runtimeSpells = new();
    private int _currentIndex;

    private PlayerReferences _refs;

    /// <summary> Su an secili olan spell. Yoksa null. </summary>
    public ISpell CurrentSpell => _runtimeSpells.Count > 0 ? _runtimeSpells[_currentIndex] : null;

    public override void OnNetworkSpawn()
    {
        _refs = GetComponent<PlayerReferences>();

        // Yalnizca owner kendi spell envanterini yonetir ve UI gunceller
        if (!IsOwner) return;

        // Baslangic spell'lerini ekle
        foreach (var def in startingSpells)
        {
            AddSpell(def);
        }

        RefreshUI();
    }

    /// <summary>
    /// Verilen spell tanimini kullanarak yeni bir runtime ISpell olusturur ve ekler.
    /// </summary>
    public void AddSpell(SpellDefinitionSO def)
    {
        if (def == null || _refs == null) return;

        ISpell spell = SpellFactory.CreateSpell(def, _refs);
        if (spell == null) return;

        spell.Initialize(_refs);
        _runtimeSpells.Add(spell);

        RefreshUI();
    }

    /// <summary>
    /// Server tarafindan cagirilip, ilgili client'a yeni bir spell acmasini soyleyen RPC.
    /// </summary>
    [ClientRpc]
    public void UnlockSpellClientRpc(SpellType type, ulong targetClientId)
    {
        // Sadece hedef client bu RPC'ye cevap verecek
        if (NetworkManager.Singleton.LocalClientId != targetClientId)
            return;

        var def = FindSpellDefinition(type);
        AddSpell(def);
    }

    private void Update()
    {
        if (!IsOwner) return;

        // Klavye ile spell slot degistirme
        if (Input.GetKeyDown(KeyCode.Alpha1)) SwitchSpell(0);
        if (Input.GetKeyDown(KeyCode.Alpha2)) SwitchSpell(1);
        if (Input.GetKeyDown(KeyCode.Alpha3)) SwitchSpell(2);
        if (Input.GetKeyDown(KeyCode.Alpha4)) SwitchSpell(3);
    }

    /// <summary>
    /// Verilen index'teki spell slotuna gecis yapar (varsa).
    /// </summary>
    private void SwitchSpell(int index)
    {
        if (index >= _runtimeSpells.Count) return;

        _currentIndex = index;
    }

    /// <summary>
    /// Tanimli tum spell definition listesi icinden ilgili spell tipini bulur.
    /// Genellikle pickup veya client unlock icin kullanilir.
    /// </summary>
    public SpellDefinitionSO FindSpellDefinition(SpellType type)
    {
        var def = allSpellDefinitions.Find(x => x.spellType == type);
        return def;
    }

    /// <summary>
    /// Spell slot UI ogelerini runtime spell listesine gore gunceller.
    /// </summary>
    private void RefreshUI()
    {
        if (spellSlots == null) return;

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

    /// <summary>
    /// Spell cast girisiminin sonuclarina gore UI feedback verir.
    /// Ornek: yetersiz mana ise slot kirmizi flash yapar.
    /// </summary>
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