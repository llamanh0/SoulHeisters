using UnityEngine;
using DG.Tweening;

/// <summary>
/// Scene destroy olurken tum animasyon ve coroutine'leri temizler
/// Her scene'de olmali
/// </summary>
public class SceneCleanupManager : MonoBehaviour
{
    private void OnDestroy()
    {
        Debug.Log($"[SceneCleanupManager] Cleaning up scene: {gameObject.scene.name}");
        
        // TUM DOTWEEN ANIMASYONLARINI DURDUR
        DOTween.KillAll();
        
        // TUM COROUTINE'LERI DURDUR
        StopAllCoroutinesInScene();
    }

    private void StopAllCoroutinesInScene()
    {
        var allMonoBehaviours = FindObjectsOfType<MonoBehaviour>();
        
        foreach (var mb in allMonoBehaviours)
        {
            if (mb != null && mb != this)
            {
                mb.StopAllCoroutines();
            }
        }
        
        Debug.Log($"[SceneCleanupManager] Stopped all coroutines ({allMonoBehaviours.Length} objects)");
    }
}