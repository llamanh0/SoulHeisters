using Unity.Netcode;
using UnityEngine;

/// <summary>
/// Player'in scene degisiminde korunmasini saglar
/// CLIENT TARAFINDAN DESTROY EDILMESINI ENGELLER
/// </summary>
[RequireComponent(typeof(NetworkObject))]
public class PlayerNetworkPersistence : NetworkBehaviour
{
    private NetworkObject _netObj;
    private bool _isApplicationQuitting = false;

    private void Awake()
    {
        _netObj = GetComponent<NetworkObject>();
        
        if (_netObj != null)
        {
            Debug.Log($"[PlayerNetworkPersistence] Initializing for NetworkObjectId: {_netObj.NetworkObjectId}");
        }
    }

    public override void OnNetworkSpawn()
    {
        if (_netObj == null)
            _netObj = GetComponent<NetworkObject>();

        Debug.Log($"[PlayerNetworkPersistence] OnNetworkSpawn - IsServer: {IsServer}, IsOwner: {IsOwner}, NetworkObjectId: {_netObj.NetworkObjectId}");

        // Scene ile destroy OLMASIN
        _netObj.DestroyWithScene = false;
        
        // Owner disconnect olunca da destroy OLMASIN (host transfer icin)
        _netObj.DontDestroyWithOwner = false;

        // DontDestroyOnLoad uygula
        DontDestroyOnLoad(gameObject);
        
        Debug.Log($"[PlayerNetworkPersistence] Protection applied - DestroyWithScene: {_netObj.DestroyWithScene}");
    }

    public override void OnNetworkDespawn()
    {
        Debug.Log($"[PlayerNetworkPersistence] OnNetworkDespawn - NetworkObjectId: {_netObj?.NetworkObjectId}");
    }

    private void OnApplicationQuit()
    {
        _isApplicationQuitting = true;
    }

    private void OnDestroy()
    {
        // Uygulama kapaniyorsa normal
        if (_isApplicationQuitting)
        {
            Debug.Log("[PlayerNetworkPersistence] Application quitting, allow destroy");
            return;
        }

        // NetworkObject kontrol
        if (_netObj == null || !_netObj.IsSpawned)
        {
            Debug.Log("[PlayerNetworkPersistence] NetworkObject null or not spawned, allow destroy");
            return;
        }

        // KRITIK KONTROL: Client destroy etmeye calisiyorsa ENGELLE!
        if (!IsServer)
        {
            Debug.LogError($"[PlayerNetworkPersistence] *** CLIENT TRIED TO DESTROY PLAYER (ID: {_netObj.NetworkObjectId})! ***");
            Debug.LogError($"[PlayerNetworkPersistence] IsOwner: {IsOwner}, OwnerClientId: {_netObj.OwnerClientId}");
            Debug.LogError($"[PlayerNetworkPersistence] StackTrace: {System.Environment.StackTrace}");
            
            // Stack trace ile hangi kod cagirdigini bul
        }
        else
        {
            Debug.Log($"[PlayerNetworkPersistence] Server destroying player {_netObj.NetworkObjectId} - OK");
        }
    }
}