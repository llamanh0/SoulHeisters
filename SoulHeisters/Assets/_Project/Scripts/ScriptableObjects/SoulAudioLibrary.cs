using UnityEngine;

[CreateAssetMenu(menuName = "Soul/Audio Library")]
public class SoulAudioLibrary : ScriptableObject
{
    public AudioClip[] dropSounds;
    public AudioClip[] collectSounds;

    public AudioClip GetRandomDropSound()
    {
        if (dropSounds == null || dropSounds.Length == 0) return null;
        return dropSounds[Random.Range(0, dropSounds.Length)];
    }

    public AudioClip GetRandomCollectSound()
    {
        if (collectSounds == null || collectSounds.Length == 0) return null;
        return collectSounds[Random.Range(0, collectSounds.Length)];
    }
}