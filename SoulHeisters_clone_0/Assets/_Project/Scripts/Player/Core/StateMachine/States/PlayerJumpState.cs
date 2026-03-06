using UnityEngine;

/// <summary>
/// Ziplama hareketinin ilk yukselis fazi.
/// </summary>
public class PlayerJumpState : PlayerState
{
    public PlayerJumpState(PlayerStateMachine sm, PlayerReferences refs)
        : base(sm, refs) { }

    public override void Enter()
    {
        // Ziplama komutu burada verilir (tek seferlik)
        refs.Locomotion.Jump();
    }

    public override void Tick()
    {
        // Havada hareket (air control)
        Vector2 input = refs.Input.MoveInput;
        if (input != Vector2.zero)
        {
            refs.Locomotion.Move(input, false, isAirborne: true);
        }

        // Yukselis bitip asagi dogru hareket basladiginda Fall state'ine gec
        if (refs.Locomotion.IsFalling())
        {
            stateMachine.ChangeState(stateMachine.FallState);
        }
    }
}