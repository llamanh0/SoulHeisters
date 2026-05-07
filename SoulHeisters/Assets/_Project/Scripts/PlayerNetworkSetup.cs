using Unity.Netcode;
using UnityEngine;

public class PlayerNetworkSetup : MonoBehaviour
{
    private void Awake()
    {
        var netObj = GetComponent<NetworkObject>();
        if (netObj != null)
        {
            // Scene degisiminde destroy olmasin
            netObj.DestroyWithScene = false;
        }
    }
}