using System;
using System.Threading.Tasks;
using Unity.Netcode;
using Unity.Netcode.Transports.UTP;
using Unity.Services.Authentication;
using Unity.Services.Core;
using Unity.Services.Relay;
using Unity.Services.Relay.Models;
using UnityEngine;

public class RelayManager : MonoBehaviour
{
    public static RelayManager Instance { get; private set; }

    [Header("Settings")]
    [SerializeField] private int maxConnections = 4;

    public bool IsInitialized { get; private set; }
    public string CurrentJoinCode { get; private set; }

    private void Awake()
    {
        if (Instance != null && Instance != this)
        {
            Destroy(gameObject);
            return;
        }
        Instance = this;
        DontDestroyOnLoad(gameObject);
    }

    public async Task InitializeAsync()
    {
        if (IsInitialized) return;

        try
        {
            await UnityServices.InitializeAsync();

            if (!AuthenticationService.Instance.IsSignedIn)
            {
                await AuthenticationService.Instance.SignInAnonymouslyAsync();
                Debug.Log($"[RelayManager] Signed in: {AuthenticationService.Instance.PlayerId}");
            }

            IsInitialized = true;
            Debug.Log("[RelayManager] Initialized successfully");
        }
        catch (Exception e)
        {
            Debug.LogError($"[RelayManager] Init failed: {e.Message}");
            throw;
        }
    }

    public async Task<string> CreateRelayAndGetJoinCode()
    {
        try
        {
            Debug.Log("[Relay] Creating allocation...");
            Allocation allocation = await RelayService.Instance.CreateAllocationAsync(maxConnections);

            Debug.Log($"[Relay] Allocation created - Region: {allocation.Region}");

            string joinCode = await RelayService.Instance.GetJoinCodeAsync(allocation.AllocationId);
            Debug.Log($"[Relay] Join Code: {joinCode}");

            var transport = NetworkManager.Singleton.GetComponent<UnityTransport>();
            transport.SetHostRelayData(
                allocation.RelayServer.IpV4,
                (ushort)allocation.RelayServer.Port,
                allocation.AllocationIdBytes,
                allocation.Key,
                allocation.ConnectionData
            );

            Debug.Log("[Relay] Host transport configured");

            CurrentJoinCode = joinCode;
            return joinCode;
        }
        catch (RelayServiceException e)
        {
            Debug.LogError($"[Relay] Service error: {e.Message} (Code: {e.ErrorCode})");
            throw;
        }
        catch (Exception e)
        {
            Debug.LogError($"[Relay] Error: {e.Message}\n{e.StackTrace}");
            throw;
        }
    }

    public async Task JoinRelayWithCode(string joinCode)
    {
        try
        {
            Debug.Log($"[Relay] Joining with code: {joinCode}");

            JoinAllocation joinAllocation = await RelayService.Instance.JoinAllocationAsync(joinCode.Trim().ToUpper());

            Debug.Log("[Relay] Join allocation received");

            var transport = NetworkManager.Singleton.GetComponent<UnityTransport>();
            transport.SetClientRelayData(
                joinAllocation.RelayServer.IpV4,
                (ushort)joinAllocation.RelayServer.Port,
                joinAllocation.AllocationIdBytes,
                joinAllocation.Key,
                joinAllocation.ConnectionData,
                joinAllocation.HostConnectionData
            );

            Debug.Log("[Relay] Client transport configured");
        }
        catch (RelayServiceException e)
        {
            Debug.LogError($"[Relay] Join failed: {e.Message} (Code: {e.ErrorCode})");
            throw;
        }
        catch (Exception e)
        {
            Debug.LogError($"[Relay] Error: {e.Message}\n{e.StackTrace}");
            throw;
        }
    }
}