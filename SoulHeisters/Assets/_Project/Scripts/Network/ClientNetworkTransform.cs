using Unity.Netcode.Components;
using UnityEngine;

/// <summary>
/// Client-authoritative hareket icin kullanilan NetworkTransform.
/// 
/// Normalde NetworkTransform default olarak server authoritative'dir.
/// Bu sinif, hareket otoritesinin client'ta oldugunu belirtmek icin
/// OnIsServerAuthoritative metodunu override eder.
/// </summary>
public class ClientNetworkTransform : NetworkTransform
{
    /// <summary>
    /// False donerek bu transform'un server degil client tarafindan
    /// kontrol edildigini belirtir.
    /// </summary>
    protected override bool OnIsServerAuthoritative()
    {
        return false;
    }
}