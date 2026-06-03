using UnityEngine;

public class PlayerSoulAudio : MonoBehaviour
{
    [SerializeField] private AudioClip[] collectSounds;
    [SerializeField] private float volume = 0.7f;

    private AudioSource _audioSource;
    private SoulComponent _soul;

    private void Awake()
    {
        _audioSource = gameObject.AddComponent<AudioSource>();
        _audioSource.playOnAwake = false;
        _audioSource.spatialBlend = 0f;

        _soul = GetComponent<SoulComponent>();
    }

    private void Start()
    {
        if (_soul != null)
            _soul.OnSoulChanged += HandleSoulCollected;
    }

    private void OnDestroy()
    {
        if (_soul != null)
            _soul.OnSoulChanged -= HandleSoulCollected;
    }

    private void HandleSoulCollected(int newAmount)
    {
        if (collectSounds == null || collectSounds.Length == 0) return;

        AudioClip randomClip = collectSounds[Random.Range(0, collectSounds.Length)];
        _audioSource.PlayOneShot(randomClip, volume);
    }
}