using System;
using System.Collections;
using System.Text.RegularExpressions;
using UnityEngine;
using Whisper;

public class VoiceCommandManager : MonoBehaviour
{
    public static VoiceCommandManager Instance { get; private set; }

    [Header("Bileşenler")]
    [SerializeField] private WhisperManager whisperManager;

    [Header("Ayarlar")]
    [Tooltip("En fazla kaç saniye kayıt alınsın?")]
    public int maxRecordingLength = 5; // Komut için 5 saniye yeter de artar

    [Tooltip("Mikrofon frekansı")]
    public int recordingFrequency = 16000;

    [Tooltip("Tuşa çok kısa basılsa bile en az bu kadar süre kayıt al.")]
    public float minRecordingTime = 0.6f;

    [Header("Ses İşleme")]
    [Tooltip("Sesi yapay olarak yükseltir (Boost). BLANK_AUDIO hatasını çözer.")]
    public bool boostVolume = true;
    [Range(1f, 10f)] public float volumeMultiplier = 3.0f; // Sesi 3 katına çıkarır

    private AudioClip _recordingClip;
    private string _micDevice;
    private bool _isRecording = false;
    private float _startRecordingTime;

    // Komutlar
    private readonly string[] _keywords = { "fireball", "fire", "heal", "shield" };
    public event Action<string> OnCommandRecognized;

    private void Awake()
    {
        if (Instance != null && Instance != this) Destroy(gameObject);
        else Instance = this;
    }

    private void Start()
    {
        if (Microphone.devices.Length > 0)
        {
            _micDevice = Microphone.devices[0];
        }
        else
        {
            Debug.LogError("[Voice] Mikrofon bulunamadı!");
        }
    }

    public void StartListening()
    {
        if (_isRecording) return;
        StartCoroutine(RecordRoutine());
    }

    public void StopListening()
    {
        _isRecording = false;
    }

    private IEnumerator RecordRoutine()
    {
        _isRecording = true;
        _startRecordingTime = Time.time;

        // 1. Kaydı Başlat
        _recordingClip = Microphone.Start(_micDevice, false, maxRecordingLength, recordingFrequency);
        // Debug.Log("[Voice] Kayıt başladı...");

        // 2. Bekleme Döngüsü
        while (_isRecording || (Time.time - _startRecordingTime < minRecordingTime))
        {
            if (Time.time - _startRecordingTime >= maxRecordingLength) break;
            yield return null;
        }

        // 3. Kaydı Bitir
        int lastPos = Microphone.GetPosition(_micDevice);
        Microphone.End(_micDevice);

        // Debug.Log($"[Voice] Kayıt bitti. Süre: {Time.time - _startRecordingTime:F2}s");

        if (lastPos <= 0) yield break;

        // 4. Sesi Kırp ve Yükselt (Boost)
        float[] samples = new float[lastPos * _recordingClip.channels];
        _recordingClip.GetData(samples, 0);

        if (boostVolume)
        {
            BoostAudio(ref samples);
        }

        AudioClip trimmedClip = AudioClip.Create("Command", lastPos, _recordingClip.channels, recordingFrequency, false);
        trimmedClip.SetData(samples, 0);

        // 5. Whisper'a Gönder
        TranscribeAudio(trimmedClip);
    }

    // --- SES YÜKSELTME FONKSİYONU ---
    private void BoostAudio(ref float[] samples)
    {
        float maxVal = 0f;

        // En yüksek ses seviyesini bul
        for (int i = 0; i < samples.Length; i++)
        {
            if (Mathf.Abs(samples[i]) > maxVal) maxVal = Mathf.Abs(samples[i]);
        }

        // Eğer ses çok kısıksa işlem yapma (0'a bölme hatası olmasın)
        if (maxVal < 0.001f) return;

        // Normalizasyon Çarpanı: Sesi patlatmadan yükselt
        // Hedef seviye 0.8f (maksimum 1.0f üzerinden)
        float multiplier = Mathf.Min(volumeMultiplier, 0.8f / maxVal);

        for (int i = 0; i < samples.Length; i++)
        {
            samples[i] *= multiplier;
        }
        // Debug.Log($"[Voice] Ses seviyesi {multiplier:F2} kat yükseltildi.");
    }

    private async void TranscribeAudio(AudioClip clip)
    {
        try
        {
            var result = await whisperManager.GetTextAsync(clip);
            ProcessText(result.Result);
        }
        catch (Exception e)
        {
            Debug.LogError($"[Voice] Hata: {e.Message}");
        }
    }

    private void ProcessText(string text)
    {
        if (string.IsNullOrWhiteSpace(text) || text.Contains("BLANK_AUDIO"))
        {
            Debug.LogWarning($"[Voice] Anlaşılamadı: {text}");
            return;
        }

        string cleanText = Regex.Replace(text.Trim().ToLowerInvariant(), @"[^\w\s]", "");
        Debug.Log($"<color=cyan>[Voice] Algılanan: {cleanText}</color>");

        foreach (var keyword in _keywords)
        {
            // Contains yerine tam kelime kontrolü daha güvenli olabilir ama şimdilik böyle kalsın
            if (cleanText.Contains(keyword))
            {
                Debug.Log($"<color=green><b>[Voice] KOMUT: {keyword.ToUpper()}</b></color>");
                OnCommandRecognized?.Invoke(keyword);
                return;
            }
        }
    }
}