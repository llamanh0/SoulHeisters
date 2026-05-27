using UnityEngine;

public class PlayerFallState : PlayerState
{
    public PlayerFallState(PlayerStateMachine sm, PlayerReferences refs)
        : base(sm, refs) { }

    public override void Tick()
    {
        Vector2 input = refs.Input.MoveInput;
        bool sprint = refs.Input.IsSprinting;

        refs.Locomotion.Move(input, sprint, isAirborne: true);

        if (refs.Locomotion.IsGrounded())
        {
            if (refs.Input.MoveInput != Vector2.zero)
                stateMachine.ChangeState(stateMachine.MoveState);
            else
                stateMachine.ChangeState(stateMachine.IdleState);
        }
    }
}