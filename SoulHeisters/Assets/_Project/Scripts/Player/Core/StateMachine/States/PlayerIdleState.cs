using UnityEngine;

/// <summary>
/// Oyuncu yerde ve hic hareket tusuna basmiyorken icinde bulundugu state.
/// </summary>
public class PlayerIdleState : PlayerGroundedState
{
    public PlayerIdleState(PlayerStateMachine sm, PlayerReferences refs)
        : base(sm, refs) { }

    public override void Tick()
    {
        // Ortak gecis kontrolleri (dusme veya ziplama)
        if (CheckGroundedTransitions()) return;

        // Hareket tusuna basilmissa Move state'ine gec
        if (refs.Input.MoveInput != Vector2.zero)
        {
            stateMachine.ChangeState(stateMachine.MoveState);
        }
    }
}