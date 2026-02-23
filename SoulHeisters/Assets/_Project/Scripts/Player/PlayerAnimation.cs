using Unity.Netcode;
using UnityEngine;

public class PlayerAnimation : NetworkBehaviour
{
    [SerializeField] private Animator animator;
    [SerializeField] private PlayerLocomotion locomotion;

    private int _speedParamID;
    private int _isGroundedParamID;

    private void Awake()
    {
        _speedParamID = Animator.StringToHash("Speed");
        _isGroundedParamID = Animator.StringToHash("IsGrounded");
        if (locomotion == null) locomotion = GetComponent<PlayerLocomotion>();
    }

    private void Update()
    {
        if (!IsOwner) return;

        float speed = locomotion.CurrentMoveSpeed;

        animator.SetFloat(_speedParamID, speed, 0.1f, Time.deltaTime);

        animator.SetBool(_isGroundedParamID, GetComponent<CharacterController>().isGrounded);
    }
}