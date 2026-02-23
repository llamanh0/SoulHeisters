using UnityEngine;

public class SpellCastRigController : MonoBehaviour
{
    [Header("IK Settings")]
    [Tooltip("HandTarget")]
    [SerializeField] private Transform ikTarget;

    [Header("Recoil Settings")]
    [SerializeField] private Vector3 recoilLocalOffset = new Vector3(0, 0, -0.3f);
    [SerializeField] private float snapSpeed = 40f;
    [SerializeField] private float recoverSpeed = 8f;

    private Vector3 _defaultLocalPosition;
    private Vector3 _currentLocalPosition;
    private bool _isInitialized = false;

    private void Start()
    {
        if (ikTarget != null)
        {
            _defaultLocalPosition = ikTarget.localPosition;
            _currentLocalPosition = _defaultLocalPosition;
            _isInitialized = true;
        }
        else
        {
            Debug.LogError("SpellCastRigController: IK Target atanmamis!");
        }
    }

    private void Update()
    {
        if (!_isInitialized) return;

        _currentLocalPosition = Vector3.Lerp(_currentLocalPosition, _defaultLocalPosition, Time.deltaTime * recoverSpeed);

        ikTarget.localPosition = Vector3.Lerp(ikTarget.localPosition, _currentLocalPosition, Time.deltaTime * snapSpeed);
    }

    public void TriggerRecoil()
    {
        if (!_isInitialized) return;

        _currentLocalPosition += recoilLocalOffset;
    }
}