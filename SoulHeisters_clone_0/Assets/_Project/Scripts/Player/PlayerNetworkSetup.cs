using UnityEngine;
using Unity.Netcode;
using Cinemachine;

public class PlayerNetworkSetup : NetworkBehaviour
{
    [SerializeField] private Transform cameraRoot;

    public override void OnNetworkSpawn()
    {
        if (IsOwner)
        {
            var virtualCamera = FindObjectOfType<CinemachineVirtualCamera>();

            if (virtualCamera != null)
            {
                virtualCamera.Follow = cameraRoot;
                virtualCamera.LookAt = cameraRoot;

                SetLayerRecursively(gameObject, LayerMask.NameToLayer("Player"));
            }
            else
            {
                Debug.LogError("[Ref Error] CinemachineVirtualCamera can not found!");
            }
        }
    }
    private void SetLayerRecursively(GameObject obj, int newLayer)
    {
        obj.layer = newLayer;
        foreach (Transform child in obj.transform)
        {
            SetLayerRecursively(child.gameObject, newLayer);
        }
    }
}