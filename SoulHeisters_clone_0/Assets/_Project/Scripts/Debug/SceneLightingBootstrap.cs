using UnityEngine;

public class SceneLightingBootstrap : MonoBehaviour
{
    [SerializeField] private Material skyboxMaterial;
    [SerializeField] private Light directionalSun;
    [SerializeField] private bool enableFog = false;
    [SerializeField] private float ambientIntensity = 1f;
    [SerializeField] private float reflectionIntensity = 1f;

    private void Start()
    {
        if (skyboxMaterial != null)
            RenderSettings.skybox = skyboxMaterial;

        RenderSettings.sun = directionalSun;
        RenderSettings.fog = enableFog;
        RenderSettings.ambientIntensity = ambientIntensity;
        RenderSettings.reflectionIntensity = reflectionIntensity;

        DynamicGI.UpdateEnvironment();

        Debug.Log("[SceneLightingBootstrap] Applied.");
    }
}