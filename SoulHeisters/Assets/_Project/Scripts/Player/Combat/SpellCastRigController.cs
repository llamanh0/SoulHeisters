using UnityEngine;
using UnityEngine.Animations.Rigging;
using Unity.Netcode;

public class SpellCastRigController : NetworkBehaviour
{
    [Header("Rig System")]
    [SerializeField] private Rig mainRig;
    [SerializeField] private Transform handIkTarget;
    [SerializeField] private Transform elbowHint;

    [Header("Aim Target Reference")]
    [SerializeField] private Transform globalAimTarget;

    [Header("Settings")]
    [SerializeField] private float aimSpeed = 15f;

    [Header("Idle Positions")]
    [SerializeField] private Vector3 idleHandOffset = new Vector3(0.3f, 1.2f, 0.4f);
    [SerializeField] private Vector3 idleElbowOffset = new Vector3(0.8f, 1.0f, -0.2f);

    private PlayerInputHandler _input;
    private float _currentWeight;
    private Transform _rootTransform;

    private void Awake()
    {
        _input = GetComponent<PlayerInputHandler>();
        _rootTransform = transform;
    }

    private void Start()
    {
        mainRig.weight = 0f;
    }

    private void LateUpdate()
    {
        if (!IsOwner) return;

        bool isAiming = _input.AimInput || _input.FireInput;

        HandleRigWeight(isAiming);

        if (isAiming)
        {
            UpdateAimPositions();
        }
        else
        {
            UpdateIdlePositions();
        }
    }

    private void HandleRigWeight(bool isAiming)
    {
        float targetW = isAiming ? 1f : 0f;
        mainRig.weight = Mathf.Lerp(mainRig.weight, targetW, Time.deltaTime * 10f);
        _currentWeight = mainRig.weight;
    }

    private void UpdateAimPositions()
    {
        if (_currentWeight < 0.01f) return;

        Vector3 targetPos = globalAimTarget.position;

        handIkTarget.position = Vector3.Lerp(handIkTarget.position, targetPos, Time.deltaTime * aimSpeed);

        Vector3 lookDir = (targetPos - _rootTransform.position).normalized;
        handIkTarget.rotation = Quaternion.LookRotation(lookDir);

        Vector3 elbowPos = _rootTransform.position + (_rootTransform.right * 0.8f) + (_rootTransform.up * 1.0f) - (_rootTransform.forward * 0.2f);
        elbowHint.position = Vector3.Lerp(elbowHint.position, elbowPos, Time.deltaTime * aimSpeed);
    }

    private void UpdateIdlePositions()
    {
        if (_currentWeight < 0.01f) return;

        Vector3 targetIdlePos = _rootTransform.position +
                              (_rootTransform.right * idleHandOffset.x) +
                              (_rootTransform.up * idleHandOffset.y) +
                              (_rootTransform.forward * idleHandOffset.z);

        handIkTarget.position = Vector3.Lerp(handIkTarget.position, targetIdlePos, Time.deltaTime * aimSpeed);
        handIkTarget.rotation = _rootTransform.rotation;

        Vector3 targetElbowPos = _rootTransform.position +
                               (_rootTransform.right * idleElbowOffset.x) +
                               (_rootTransform.up * idleElbowOffset.y);

        elbowHint.position = Vector3.Lerp(elbowHint.position, targetElbowPos, Time.deltaTime * aimSpeed);
    }
}