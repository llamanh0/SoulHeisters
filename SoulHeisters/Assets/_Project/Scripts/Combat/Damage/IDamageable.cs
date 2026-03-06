/// <summary>
/// Hasar alabilen tum entity'ler icin ortak arayuz.
/// Ornek implementasyon: HealthComponent.
/// </summary>
public interface IDamageable
{
    /// <summary>
    /// Verilen miktarda hasar uygular.
    /// dealerClientId: Hasari veren oyuncunun client ID'si.
    /// </summary>
    void TakeDamage(float amount, ulong dealerClientId);

    /// <summary> Mevcut saglik degeri. </summary>
    float CurrentHealth { get; }

    /// <summary> Entity olduyse true. </summary>
    bool IsDead { get; }
}