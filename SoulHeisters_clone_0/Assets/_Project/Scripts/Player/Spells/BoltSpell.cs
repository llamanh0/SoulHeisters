using UnityEngine;

public class BoltSpell : ISpell
{
    private PlayerReferences _refs;
    private PlayerCombat _combat;

    private Transform _firePoint;
    private GameObject _serverPrefab;
    private GameObject _visualPrefab;

    private SpellType _spellType;

    private float _projectileSpeed;
    private float _damage;
    private float _manaCost;
    private float _fireRate = .33f;

    private float _nextFireTime;

    public BoltSpell(
        SpellType spellType,
        Transform firePoint,
        GameObject serverPrefab,
        GameObject visualPrefab,
        float projectileSpeed,
        float damage,
        float manaCost)
    {
        _spellType = spellType;
        _firePoint = firePoint;
        _serverPrefab = serverPrefab;
        _visualPrefab = visualPrefab;
        _projectileSpeed = projectileSpeed;
        _damage = damage;
        _manaCost = manaCost;;
    }

    public void Initialize(PlayerReferences refs)
    {
        _refs = refs;
        _combat = refs.Combat;
    }

    public void TryCast()
    {
        Debug.Log($"[BoltSpell//Try Cast]: {_spellType}");
        if (!_combat.IsOwner) return;

        if (Time.time < _nextFireTime) return;

        if (_refs.Mana.CurrentMana.Value < _manaCost)
            return;

        _nextFireTime = Time.time + _fireRate;

        Vector3 targetPoint = GetCrosshairHitPoint();
        Vector3 direction = (targetPoint - _firePoint.position).normalized;
        Quaternion rotation = Quaternion.LookRotation(direction);

        SpawnLocalVisual(direction, rotation);

        _refs.Combat.CastSpellServerRpc(
            _spellType,
            targetPoint,
            _manaCost,
            _damage,
            _projectileSpeed);
    }

    private void SpawnLocalVisual(Vector3 direction, Quaternion rotation)
    {
        GameObject visualObj =
            Object.Instantiate(_visualPrefab, _firePoint.position, rotation);

        if (visualObj.TryGetComponent<Rigidbody>(out var rb))
            rb.velocity = direction * _projectileSpeed;

        Object.Destroy(visualObj, 5f);
    }

    private Vector3 GetCrosshairHitPoint()
    {
        Camera cam = Camera.main;
        Ray ray = cam.ViewportPointToRay(new Vector3(0.5f, 0.5f));
        if (Physics.Raycast(ray, out RaycastHit hit, 1000f))
            return hit.point;

        return ray.GetPoint(100f);
    }
}