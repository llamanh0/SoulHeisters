using UnityEngine;

public class PlayerJumpState : PlayerState
{
    public PlayerJumpState(PlayerStateMachine sm, PlayerReferences refs)
        : base(sm, refs) { }

    public override void Enter()
    {
        refs.Locomotion.Jump();
    }

    public override void Tick()
    {
        Vector2 input = refs.Input.MoveInput;
        bool sprint = refs.Input.IsSprinting;

        refs.Locomotion.Move(input, sprint, isAirborne: true);

        if (refs.Locomotion.IsFalling())
        {
            stateMachine.ChangeState(stateMachine.FallState);
        }
    }
}