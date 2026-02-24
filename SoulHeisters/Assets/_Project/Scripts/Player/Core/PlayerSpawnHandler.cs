using Unity.Netcode;
using UnityEngine;

public class PlayerSpawnHandler : NetworkBehaviour
{
    public override void OnNetworkSpawn()
    {
        if (IsServer)
        {
            SetSpawnPosition();
        }
    }

    private void SetSpawnPosition()
    {
        SpawnPoint[] spawnPoints = FindObjectsOfType<SpawnPoint>();

        if (spawnPoints.Length == 0) return;

        int randomIndex = Random.Range(0, spawnPoints.Length);
        Transform selectedSpawn = spawnPoints[randomIndex].transform;

        ClientRpcParams clientRpcParams = new ClientRpcParams
        {
            Send = new ClientRpcSendParams
            {
                TargetClientIds = new ulong[] { OwnerClientId }
            }
        };

        TeleportClientRpc(selectedSpawn.position, selectedSpawn.rotation, clientRpcParams);
    }

    [ClientRpc]
    private void TeleportClientRpc(Vector3 targetPosition, Quaternion targetRotation, ClientRpcParams rpcParams = default)
    {
        transform.position = targetPosition;
        transform.rotation = targetRotation;
    }
}