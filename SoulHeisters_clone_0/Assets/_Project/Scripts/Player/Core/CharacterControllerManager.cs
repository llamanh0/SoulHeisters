using System.Collections;
using Unity.Netcode;
using Unity.Netcode.Components;
using UnityEngine;

public class CharacterControllerManager : NetworkBehaviour
{
    private CharacterController _controller;
    private Coroutine _enableRoutine;

    private void Awake()
    {
        _controller = GetComponent<CharacterController>();
    }

    public void EnableController()
    {
        if (_enableRoutine != null)
        {
            StopCoroutine(_enableRoutine);
            _enableRoutine = null;
        }

        if (_controller != null)
            _controller.enabled = true;
    }

    public void DisableController()
    {
        if (_enableRoutine != null)
        {
            StopCoroutine(_enableRoutine);
            _enableRoutine = null;
        }

        if (_controller != null)
            _controller.enabled = false;
    }

    public void EnableAfterDelay(float delay)
    {
        if (_enableRoutine != null)
            StopCoroutine(_enableRoutine);

        _enableRoutine = StartCoroutine(EnableRoutine(delay));
    }

    private IEnumerator EnableRoutine(float delay)
    {
        if (_controller != null)
            _controller.enabled = false;

        yield return new WaitForSeconds(delay);

        if (_controller != null)
            _controller.enabled = true;

        _enableRoutine = null;
    }

    public void Teleport(Vector3 position, Quaternion rotation)
    {
        if (_controller == null) return;

        _controller.enabled = false;
        transform.SetPositionAndRotation(position, rotation);

        if (TryGetComponent<NetworkTransform>(out var networkTransform))
            networkTransform.Teleport(position, rotation, transform.localScale);

        EnableAfterDelay(0.1f);
    }

    public bool IsEnabled()
    {
        return _controller != null && _controller.enabled;
    }

    public CharacterController GetController()
    {
        return _controller;
    }
}