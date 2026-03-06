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

    private void OnEnable()
    {
        if (GameStateManager.Instance != null)
        {
            GameStateManager.Instance.OnMatchEnded += HandleMatchEnded;
        }
    }

    private void OnDisable()
    {
        if (GameStateManager.Instance != null)
        {
            GameStateManager.Instance.OnMatchEnded -= HandleMatchEnded;
        }
    }

    /// <summary>
    /// Mac bittiginde cagrilir, oyuncunun state'ini sifirlar.
    /// </summary>
    private void HandleMatchEnded()
    {
        // Locomotion yoksa bir sey yapma
        if (refs == null || refs.Locomotion == null) return;

        // Dikey hizi sifirla ve hareketi durdur
        refs.Locomotion.ResetVerticalVelocity();
        refs.Locomotion.ForceStopMovement();

        // Mantiksal olarak Idle state'ine don
        ChangeState(IdleState);
    }

    private void Update()
    {
        if (refs == null || refs.Locomotion == null) return;

        // Sadece owner olan client state makinesini isletir
        if (!refs.Locomotion.IsSpawned || !refs.Locomotion.IsOwner) return;

        // Oyun Playing durumunda degilse hareket/state calismasin
        if (GameStateManager.Instance != null &&
            GameStateManager.Instance.CurrentState != GameState.Playing)
        {
            return;
        }

        // Gravity her state'de calisir
        refs.Locomotion.ApplyGravity();

        // Aktif state mantigi
        CurrentState?.Tick();
    }

    private void FixedUpdate()
    {
        if (refs == null || refs.Locomotion == null) return;
        if (!refs.Locomotion.IsSpawned || !refs.Locomotion.IsOwner) return;

        if (GameStateManager.Instance != null &&
            GameStateManager.Instance.CurrentState != GameState.Playing)
        {
            return;
        }

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
    }
}