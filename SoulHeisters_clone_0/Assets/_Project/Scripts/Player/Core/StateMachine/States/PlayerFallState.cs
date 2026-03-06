using UnityEngine;

/// <summary>
/// Oyuncu havadayken ve asagi dogru dusuyorken icinde bulundugu state.
/// </summary>
public class PlayerFallState : PlayerState
{
    public PlayerFallState(PlayerStateMachine sm, PlayerReferences refs)
        : base(sm, refs) { }

    public override void Tick()
    {
        // Havada hareket (sinirli hava kontrolu)
        Vector2 input = refs.Input.MoveInput;
        if (input != Vector2.zero)
        {
            refs.Locomotion.Move(input, false, isAirborne: true);
        }

        // Yere degdi → durumuna gore Idle veya Move'a don
        if (refs.Locomotion.IsGrounded())
        {
            if (refs.Input.MoveInput != Vector2.zero)
                stateMachine.ChangeState(stateMachine.MoveState);
            else
                stateMachine.ChangeState(stateMachine.IdleState);
        }
    }
}