using UnityEngine;

namespace ToonScapes.tools
{
    [ExecuteAlways]
    public class SunFacingFX : MonoBehaviour
    {
        [Tooltip("Optional manual assignment of the directional light (sun)")]
        public Light sunLight;

        [Tooltip("If enabled, will automatically find the scene's main directional light")]
        public bool autoFindSun = true;

        [Tooltip("If true, will rotate opposite to the light direction")]
        public bool invertDirection = false;

        [Tooltip("How smoothly the object rotates toward the light direction (0 = instant)")]
        [Range(0f, 1f)]
        public float smoothFactor = 0.2f;

        private Quaternion targetRotation;

        private void Update()
        {
            UpdateSunReference();

            if (sunLight == null)
                return;

            RotateTowardsSun();
        }

        private void UpdateSunReference()
        {
            if (!autoFindSun)
                return;

            if (sunLight == null || sunLight.type != LightType.Directional)
            {
                // Try RenderSettings.sun first
                sunLight = RenderSettings.sun;

                // If none assigned, find the first directional light in the scene
                if (sunLight == null)
                {
                    foreach (var l in Object.FindObjectsByType<Light>(FindObjectsSortMode.None))
                    {
                        if (l.type == LightType.Directional)
                        {
                            sunLight = l;
                            break;
                        }
                    }
                }
            }
        }


        private void RotateTowardsSun()
        {
            Vector3 direction = invertDirection ? sunLight.transform.forward : -sunLight.transform.forward;

            // Compute target rotation
            targetRotation = Quaternion.LookRotation(direction, Vector3.up);

            // Apply smooth rotation
            if (smoothFactor > 0f)
            {
                float t = 1f - Mathf.Pow(1f - smoothFactor, Time.deltaTime * 60f);
                transform.rotation = Quaternion.Slerp(transform.rotation, targetRotation, t);
            }
            else
            {
                transform.rotation = targetRotation;
            }
        }
    }
}
