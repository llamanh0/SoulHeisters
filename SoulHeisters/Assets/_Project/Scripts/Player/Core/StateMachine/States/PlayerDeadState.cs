/// <summary>
/// Oyuncu oldukten sonraki durum.
/// 
/// Not:
/// - Bu state'den cikis yoktur; respawn sistemi gerekirse
///   dogrudan baska bir state'e ChangeState cagirir.
/// </summary>
public class PlayerDeadState : PlayerState
{
    public PlayerDeadState(PlayerStateMachine sm, PlayerReferences refs)
        : base(sm, refs) { }

    public override void Enter()
    {
        // Olum aninda, dikey hiz sifirlanip gorsel olum islemleri tetiklenir
        refs.Locomotion.ResetVerticalVelocity();
        refs.Visual.HandleDeathVisual();
    }
}