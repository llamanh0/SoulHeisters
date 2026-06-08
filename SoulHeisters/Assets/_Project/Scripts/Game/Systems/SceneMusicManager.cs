using UnityEngine;
using UnityEngine.SceneManagement;

public class BackgroundMusicManager : MonoBehaviour
{
    public static BackgroundMusicManager Instance;

    [SerializeField] private AudioClip menuLobbyMusic;
    [SerializeField] private AudioClip gameMusic;
    [SerializeField] private float volume = 0.3f;

    private AudioSource audioSource;
    private string currentMusicType;

    private void Awake()
    {
        if (Instance != null && Instance != this)
        {
            Destroy(gameObject);
            return;
        }

        Instance = this;
        DontDestroyOnLoad(gameObject);

        audioSource = gameObject.AddComponent<AudioSource>();
        audioSource.loop = true;
        audioSource.playOnAwake = false;
        audioSource.volume = volume;
    }

    private void OnEnable()
    {
        SceneManager.sceneLoaded += OnSceneLoaded;
    }

    private void OnDisable()
    {
        SceneManager.sceneLoaded -= OnSceneLoaded;
    }

    private void Start()
    {
        PlayMusicForScene(SceneManager.GetActiveScene().name);
    }

    private void OnSceneLoaded(Scene scene, LoadSceneMode mode)
    {
        PlayMusicForScene(scene.name);
    }

    private void PlayMusicForScene(string sceneName)
    {
        string musicType = "";

        if (sceneName == "MenuScene" || sceneName == "LobbyScene")
            musicType = "MenuLobby";
        else if (sceneName == "GameScene2")
            musicType = "Game";

        if (currentMusicType == musicType) return;

        currentMusicType = musicType;

        if (musicType == "MenuLobby" && menuLobbyMusic != null)
        {
            audioSource.Stop();
            audioSource.clip = menuLobbyMusic;
            audioSource.Play();
        }
        else if (musicType == "Game")
        {
            if (gameMusic != null)
            {
                audioSource.Stop();
                audioSource.clip = gameMusic;
                audioSource.Play();
            }
            else
            {
                audioSource.Stop();
            }
        }
    }

    public void SetVolume(float vol)
    {
        volume = Mathf.Clamp01(vol);
        if (audioSource != null)
            audioSource.volume = volume;
    }

    public void Stop()
    {
        if (audioSource != null)
            audioSource.Stop();
    }
}