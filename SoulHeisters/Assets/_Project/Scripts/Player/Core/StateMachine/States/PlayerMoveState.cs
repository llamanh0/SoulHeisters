using UnityEngine;

/// <summary>
/// Oyuncu yerde ve hareket tuslarina basiliyorken icinde bulundugu state.
/// </summary>
public class PlayerMoveState : PlayerGroundedState
{
    public PlayerMoveState(PlayerStateMachine sm, PlayerReferences refs)
        : base(sm, refs) { }

    public override void Tick()
    {
        if (CheckGroundedTransitions()) return;

        Vector2 input = refs.Input.MoveInput;
        bool sprint = refs.Input.IsSprinting;

        // Yurumeyi Locomotion uzerinden uygula
        refs.Locomotion.Move(input, sprint);

        // Hareket input'u yoksa Idle'a geri don
        if (input == Vector2.zero)
        {
            stateMachine.ChangeState(stateMachine.IdleState);
        }
    }
}