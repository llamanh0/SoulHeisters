/// <summary>
/// Tum player state'leri icin ortak taban sinif.
/// 
/// Metodlar:
/// - Enter: State'e ilk kez girildiginde cagrilir.
/// - Exit: State'den cikarken cagrilir.
/// - Tick: Her frame cagrilir (Update).
/// - FixedTick: Fizik update'lerinde cagrilir (FixedUpdate).
/// </summary>
public abstract class PlayerState
{
    protected PlayerStateMachine stateMachine;
    protected PlayerReferences refs;

    protected PlayerState(PlayerStateMachine stateMachine, PlayerReferences refs)
    {
        this.stateMachine = stateMachine;
        this.refs = refs;
    }

    public virtual void Enter() { }
    public virtual void Exit() { }
    public virtual void Tick() { }
    public virtual void FixedTick() { }
}