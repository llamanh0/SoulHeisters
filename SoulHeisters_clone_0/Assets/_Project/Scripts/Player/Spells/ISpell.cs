/// <summary>
/// Tum spell tipleri icin ortak arayuz.
/// 
/// Gorevi:
/// - Spell'in cooldown ve son kullanilma zamanini raporlamak
/// - PlayerReferences ile baglantiyi kurmak (Initialize)
/// - TryCast ile spell mantigini denemek (mana, cooldown vs.)
/// </summary>
public interface ISpell
{
    /// <summary> Spell'in cooldown suresi (saniye). </summary>
    float Cooldown { get; }

    /// <summary> Spell'in en son ne zaman cast edildigi (Time.time). </summary>
    float LastCastTime { get; }

    /// <summary>
    /// Spell'i kullanacak oyuncunun referanslari ile initialize eder.
    /// </summary>
    void Initialize(PlayerReferences refs);

    /// <summary>
    /// Spell kullanmayi dener.
    /// - Basarili ise gerekli ServerRpc fonksiyonlarini cagirir.
    /// - Basarisiz ise nedenini SpellCastResult ile doner.
    /// </summary>
    SpellCastResult TryCast();
}