using Unity.Netcode;
using UnityEngine;
using UnityEngine.SceneManagement;

public class PlayerNetworkPersistence : NetworkBehaviour
{
    private NetworkObject _netObj;
    private bool _isApplicationQuitting = false;

    private void Awake()
    {
        _netObj = GetComponent<NetworkObject>();
    }

    public override void OnNetworkSpawn()
    {
        if (_netObj == null)
            _netObj = GetComponent<NetworkObject>();

        _netObj.DestroyWithScene = false;
        _netObj.DontDestroyWithOwner = false;

        DontDestroyOnLoad(gameObject);

        SceneManager.sceneLoaded += OnSceneLoaded;
    }

    public override void OnNetworkDespawn()
    {
        SceneManager.sceneLoaded -= OnSceneLoaded;
    }

    private void OnSceneLoaded(Scene scene, LoadSceneMode mode)
    {
        if (scene.name == "LobbyScene" || scene.name == "MenuScene")
        {
            if (_netObj != null && _netObj.IsSpawned && IsOwner)
            {
                _netObj.Despawn();
            }

            Destroy(gameObject);
        }
    }

    private void OnApplicationQuit()
    {
        _isApplicationQuitting = true;
    }

    public override void OnDestroy()
    {
        SceneManager.sceneLoaded -= OnSceneLoaded;

        if (!_isApplicationQuitting && _netObj != null && _netObj.IsSpawned && !IsServer)
        {
        }
    }
}