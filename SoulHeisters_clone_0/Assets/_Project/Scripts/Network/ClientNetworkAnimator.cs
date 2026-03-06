using Unity.Netcode.Components;
using UnityEngine;

/// <summary>
/// Client-authoritative animasyon icin kullanilan NetworkAnimator.
/// 
/// Normalde NetworkAnimator server authoritative olarak calisir.
/// Bu sinif, animasyon parametrelerinin client tarafindan guncellendigini
/// belirtmek icin OnIsServerAuthoritative metodunu override eder.
/// </summary>
public class ClientNetworkAnimator : NetworkAnimator
{
    /// <summary>
    /// False donerek animasyon otoritesinin server degil client'ta oldugunu belirtir.
    /// </summary>
    protected override bool OnIsServerAuthoritative()
    {
        return false;
    }
}