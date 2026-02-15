public interface IDamageable
{
    void TakeDamage(float amount, ulong dealerClientId);

    float CurrentHealth { get; }

    bool IsDead { get; }
}