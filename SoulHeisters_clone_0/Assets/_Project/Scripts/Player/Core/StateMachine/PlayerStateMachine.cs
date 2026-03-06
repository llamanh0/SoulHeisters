using UnityEngine;

/// <summary>
/// Oyuncunun hareket/yer cekimi durumlarini yoneten state makinesi.
/// 
/// State'ler:
/// - Idle: Yerde, hareketsiz
/// - Move: Yerde, hareket halinde
/// - Jump: Ziplama yukselis fazi
/// - Fall: Havada dusus fazi
/// - Dead: Oldukten sonraki durum (disaridan respawn vs. ile degistirilir)
/// 
/// Not:
/// - Update / FixedUpdate sadece owner icin calisir.
/// - Gravity her state'de ortak olarak Locomotion uzerinden uygulanir.
/// </summary>
public class PlayerStateMachine : MonoBehaviour
{
    public PlayerState CurrentState { get; private set; }

    // ─── Concrete state instance'lari ───
    public PlayerIdleState IdleState { get; private set; }
    public PlayerMoveState MoveState { get; private set; }
    public PlayerJumpState JumpState { get; private set; }
    public PlayerFallState FallState { get; private set; }
    public PlayerDeadState DeadState { get; private set; }

    private PlayerReferences refs;

    private void Awake()
    {
        refs = GetComponent<PlayerReferences>();

        IdleState = new PlayerIdleState(this, refs);
        MoveState = new PlayerMoveState(this, refs);
        JumpState = new PlayerJumpState(this, refs);
        FallState = new PlayerFallState(this, refs);
        DeadState = new PlayerDeadState(this, refs);
    }

    private void Start()
    {
        ChangeState(IdleState);
    }

    private void Update()
    {
        // Network kontrolu: sadece owner olan client state makinesini isletir
        if (refs == null || refs.Locomotion == null) return;
        if (!refs.Locomotion.IsSpawned || !refs.Locomotion.IsOwner) return;

        // Gravity her state'de calisir
        refs.Locomotion.ApplyGravity();

        // Aktif state mantigi
        CurrentState?.Tick();
    }

    private void FixedUpdate()
    {
        if (refs == null || refs.Locomotion == null) return;
        if (!refs.Locomotion.IsSpawned || !refs.Locomotion.IsOwner) return;

        CurrentState?.FixedTick();
    }

    /// <summary>
    /// Yeni bir state'e gecis yapar.
    /// Onceki state'in Exit, yeni state'in Enter metodlarini cagirir.
    /// </summary>
    public void ChangeState(PlayerState newState)
    {
        if (newState == null) return;

        CurrentState?.Exit();
        CurrentState = newState;
        CurrentState?.Enter();

#if UNITY_EDITOR
        Debug.Log($"[PlayerStateMachine] State -> {newState.GetType().Name}");
#endif
    }
}