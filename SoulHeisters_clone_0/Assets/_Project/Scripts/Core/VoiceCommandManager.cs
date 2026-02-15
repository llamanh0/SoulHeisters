using System;
using UnityEngine;
using Whisper;
using Whisper.Utils;

public class VoiceCommandManager : MonoBehaviour
{
    public static VoiceCommandManager Instance { get; private set; }

    [Header("Bileşenler")]
    [SerializeField] private WhisperManager whisperManager;
    [SerializeField] private MicrophoneRecord microphoneRecord;

    [Header("Mod Ayarları")]
    [Tooltip("İşaretli değilse 'Sürekli Dinleme' moduna geçer.")]
    public bool usePushToTalk = false;

    [Tooltip("Aynı komutun tekrar tetiklenmesi için kaç saniye geçmeli?")]
    public float commandCooldown = 1.2f;
    
    private readonly string[] _keywords = { "fireball", "fire", "heal", "shield" };

    private WhisperStream _stream;
    private float _lastCommandTime;
    private bool _isStreamReady = false;

    public event Action<string> OnCommandRecognized;

    private void Awake()
    {
        if (Instance != null && Instance != this) Destroy(gameObject);
        else Instance = this;
    }

    private async void Start()
    {
        if (whisperManager == null || microphoneRecord == null) return;

        if (Microphone.devices.Length > 0)
        {
            microphoneRecord.SelectedMicDevice = Microphone.devices[0];
        }

        _stream = await whisperManager.CreateStream(microphoneRecord);

        _stream.OnResultUpdated += OnPartialResult;
        _stream.OnSegmentFinished += OnFinalResult;

        _isStreamReady = true;

        if (usePushToTalk)
        {
            microphoneRecord.StopRecord();
            Debug.Log("[Voice] Mod: BAS-KONUŞ (Tuş Bekleniyor)");
        }
        else
        {
            StartStreamSession();
            Debug.Log("[Voice] Mod: SÜREKLİ DİNLEME (Mikrofon Açık)");
        }
    }

    public void StartListening()
    {
        if (usePushToTalk && _isStreamReady) StartStreamSession();
    }

    public void StopListening()
    {
        if (usePushToTalk && _isStreamReady) microphoneRecord.StopRecord();
    }

    private void StartStreamSession()
    {
        if (!microphoneRecord.IsRecording)
        {
            _stream.StartStream();
            microphoneRecord.StartRecord();
        }
    }

    private void OnPartialResult(string result)
    {
        ProcessText(result);
    }

    private void OnFinalResult(WhisperResult result)
    {
        ProcessText(result.Result);
    }

    private void ProcessText(string text)
    {
        if (string.IsNullOrEmpty(text)) return;

        if (Time.time - _lastCommandTime < commandCooldown) return;

        string cleanText = text.Trim().ToLowerInvariant();

        foreach (var keyword in _keywords)
        {
            if (cleanText.Contains(keyword))
            {
                Debug.Log($"[Voice Stream] TETİKLENDİ: {keyword}");
                OnCommandRecognized?.Invoke(keyword);

                _lastCommandTime = Time.time;
                return;
            }
        }
    }

    private void OnDestroy()
    {
        if (_isStreamReady && _stream != null)
        {
            // _stream.StopStream(); 
        }
    }
}