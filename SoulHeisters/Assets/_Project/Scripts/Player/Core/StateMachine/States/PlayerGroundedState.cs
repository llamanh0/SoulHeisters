/// <summary>
/// Yerde bulunan state'ler (Idle, Move gibi) icin ortak davranis.
/// 
/// Sorumluluk:
/// - Yerden ayrilma ve ziplama gibi ortak gecis kontrollerini yapmak.
/// - Bu sayede Idle ve Move icinde ayri ayri yazmaya gerek kalmaz.
/// </summary>
public abstract class PlayerGroundedState : PlayerState
{
    protected PlayerGroundedState(PlayerStateMachine sm, PlayerReferences refs)
        : base(sm, refs) { }

    /// <summary>
    /// Ortak gecis kontrollerini yapar:
    /// - Yerden ayrildiysa Fall state'ine gec
    /// - Jump input geldiyse Jump state'ine gec
    /// 
    /// true donerse, state gecisi yapilmis demektir ve
    /// alt sinif kendi Tick mantigini atlamalidir.
    /// </summary>
    protected bool CheckGroundedTransitions()
    {
        // Yerden ayrildiysa → Fall
        if (!refs.Locomotion.IsGrounded())
        {
            stateMachine.ChangeState(stateMachine.FallState);
            return true;
        }

        // Ziplama tusu → Jump
        if (refs.Input.JumpInput)
        {
            stateMachine.ChangeState(stateMachine.JumpState);
            return true;
        }

        return false;
    }
}