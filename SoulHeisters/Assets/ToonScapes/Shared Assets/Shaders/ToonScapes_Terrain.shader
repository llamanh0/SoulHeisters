// Made with Amplify Shader Editor v1.9.9.8
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ToonScapes/URP/Terrain"
{
	Properties
	{
		[HideInInspector] _EmissionColor("Emission Color", Color) = (1,1,1,1)
		[HideInInspector] _TerrainHolesTexture( "_TerrainHolesTexture", 2D ) = "white" {}
		[HideInInspector] _Splat3( "Splat3", 2D ) = "white" {}
		[HideInInspector] _Control( "Control", 2D ) = "white" {}
		[HideInInspector] _Splat2( "Splat2", 2D ) = "white" {}
		[HideInInspector] _Splat1( "Splat1", 2D ) = "white" {}
		[HideInInspector] _Splat0( "Splat0", 2D ) = "white" {}
		[HideInInspector] _Normal0( "Normal0", 2D ) = "white" {}
		[HideInInspector] _Normal1( "Normal1", 2D ) = "white" {}
		[HideInInspector] _Normal2( "Normal2", 2D ) = "white" {}
		[HideInInspector] _Normal3( "Normal3", 2D ) = "white" {}
		[Header(Color)][Space(8)][Toggle( _ENABLECOLORTINT_ON )] _EnableColorTint( "Enable Color Tint", Float ) = 1
		[Space(8)] _BaseTint( "Base Tint", Color ) = ( 1, 1, 1, 1 )
		[Header(Textures)][NoScaleOffset][SingleLineTexture][Space (8)] _TextureRamp3( "Texture Ramp", 2D ) = "white" {}
		_RampScale( "Ramp Scale", Range( 0, 1 ) ) = 0.5
		_RampOffset( "Ramp Offset", Range( 0, 1 ) ) = 0.5
		_NormalScale( "Normal Scale", Range( 0, 5 ) ) = 1
		[Header(Highlights)][Space(8)][Toggle( _ENABLESPECULARHIGHLIGHTS_ON )] _EnableSpecularHighlights( "Enable Specular Highlights", Float ) = 1
		[Space(8)] _SpecularTint1( "Specular Tint", Color ) = ( 1, 1, 1, 1 )
		[Space (8)] _SpecularSize1( "Specular Size", Range( 0, 1 ) ) = 0
		_SpecularIntensity( "Specular Intensity", Range( 0, 1 ) ) = 0.5
		_SpecularSmoothness1( "Specular Smoothness", Range( 0.001, 1 ) ) = 0.01
		_SpecularOcclusion( "Specular Occlusion", Range( 0, 12 ) ) = 1
		_IndirectSpecularContribution1( "Indirect Specular Contribution", Range( 0, 1 ) ) = 1
		[Header(Surface Options)][Space (8)] _Occlusion1( "Occlusion", Range( 0, 1 ) ) = 1


		//_TransmissionShadow( "Transmission Shadow", Range( 0, 1 ) ) = 0.5
		//_TransStrength( "Trans Strength", Range( 0, 50 ) ) = 1
		//_TransNormal( "Trans Normal Distortion", Range( 0, 1 ) ) = 0.5
		//_TransScattering( "Trans Scattering", Range( 1, 50 ) ) = 2
		//_TransDirect( "Trans Direct", Range( 0, 1 ) ) = 0.9
		//_TransAmbient( "Trans Ambient", Range( 0, 1 ) ) = 0.1
		//_TransShadow( "Trans Shadow", Range( 0, 1 ) ) = 0.5

		//_TessPhongStrength( "Tess Phong Strength", Range( 0, 1 ) ) = 0.5
		//_TessValue( "Tess Max Tessellation", Range( 1, 32 ) ) = 16
		//_TessMin( "Tess Min Distance", Float ) = 10
		//_TessMax( "Tess Max Distance", Float ) = 25
		//_TessEdgeLength ( "Tess Edge length", Range( 2, 50 ) ) = 16
		//_TessMaxDisp( "Tess Max Displacement", Float ) = 25

		[KeywordEnum(Vertex, Pixel)] _InstancedTerrainNormals("Instanced Terrain Normals", Float) = 1.0

		//[ToggleOff(_SPECULARHIGHLIGHTS_OFF)] _SpecularHighlights("Specular Highlights", Float) = 1.0
		//[ToggleOff] _EnvironmentReflections("Environment Reflections", Float) = 1.0
		[HideInInspector][ToggleUI] _ReceiveShadows("Receive Shadows", Float) = 1.0

		[HideInInspector] _QueueOffset("_QueueOffset", Float) = 0
        [HideInInspector] _QueueControl("_QueueControl", Float) = -1

        [HideInInspector][NoScaleOffset] unity_Lightmaps("unity_Lightmaps", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset] unity_LightmapsInd("unity_LightmapsInd", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset] unity_ShadowMasks("unity_ShadowMasks", 2DArray) = "" {}

		//[HideInInspector][ToggleUI] _AddPrecomputedVelocity("Add Precomputed Velocity", Float) = 1

		//[HideInInspector] _XRMotionVectorsPass("_XRMotionVectorsPass", Float) = 1

		//[HideInInspector] _AlphaClip("__clip", Float) = 0.0
	}

	SubShader
	{
		LOD 0

		

		

		Tags { "RenderPipeline"="UniversalPipeline" "RenderType"="Opaque" "Queue"="Geometry-100" "UniversalMaterialType"="SimpleLit" "DisableBatching"="False" "IgnoreProjector"="True" "TerrainCompatible"="True" "AlwaysRenderMotionVectors"="false" }

		Cull Back
		ZWrite On
		ZTest LEqual
		Offset 0 , 0
		AlphaToMask Off

		

		HLSLINCLUDE
		#pragma target 4.5
		#pragma prefer_hlslcc gles
		// ensure rendering platforms toggle list is visible

		#if ( SHADER_TARGET > 35 ) && defined( SHADER_API_GLES3 )
			#error For WebGL2/GLES3, please set your shader target to 3.5 via SubShader options. URP shaders in ASE use target 4.5 by default.
		#endif

		#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
		#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Filtering.hlsl"

		#ifndef ASE_TESS_FUNCS
		#define ASE_TESS_FUNCS
		float4 FixedTess( float tessValue )
		{
			return tessValue;
		}

		float CalcDistanceTessFactor (float4 vertex, float minDist, float maxDist, float tess, float4x4 o2w, float3 cameraPos )
		{
			float3 wpos = mul(o2w,vertex).xyz;
			float dist = distance (wpos, cameraPos);
			float f = clamp(1.0 - (dist - minDist) / (maxDist - minDist), 0.01, 1.0) * tess;
			return f;
		}

		float4 CalcTriEdgeTessFactors (float3 triVertexFactors)
		{
			float4 tess;
			tess.x = 0.5 * (triVertexFactors.y + triVertexFactors.z);
			tess.y = 0.5 * (triVertexFactors.x + triVertexFactors.z);
			tess.z = 0.5 * (triVertexFactors.x + triVertexFactors.y);
			tess.w = (triVertexFactors.x + triVertexFactors.y + triVertexFactors.z) / 3.0f;
			return tess;
		}

		float CalcEdgeTessFactor (float3 wpos0, float3 wpos1, float edgeLen, float3 cameraPos, float4 scParams )
		{
			float dist = distance (0.5 * (wpos0+wpos1), cameraPos);
			float len = distance(wpos0, wpos1);
			float f = max(len * scParams.y / (edgeLen * dist), 1.0);
			return f;
		}

		float DistanceFromPlane (float3 pos, float4 plane)
		{
			float d = dot (float4(pos,1.0f), plane);
			return d;
		}

		bool WorldViewFrustumCull (float3 wpos0, float3 wpos1, float3 wpos2, float cullEps, float4 planes[6] )
		{
			float4 planeTest;
			planeTest.x = (( DistanceFromPlane(wpos0, planes[0]) > -cullEps) ? 1.0f : 0.0f ) +
							(( DistanceFromPlane(wpos1, planes[0]) > -cullEps) ? 1.0f : 0.0f ) +
							(( DistanceFromPlane(wpos2, planes[0]) > -cullEps) ? 1.0f : 0.0f );
			planeTest.y = (( DistanceFromPlane(wpos0, planes[1]) > -cullEps) ? 1.0f : 0.0f ) +
							(( DistanceFromPlane(wpos1, planes[1]) > -cullEps) ? 1.0f : 0.0f ) +
							(( DistanceFromPlane(wpos2, planes[1]) > -cullEps) ? 1.0f : 0.0f );
			planeTest.z = (( DistanceFromPlane(wpos0, planes[2]) > -cullEps) ? 1.0f : 0.0f ) +
							(( DistanceFromPlane(wpos1, planes[2]) > -cullEps) ? 1.0f : 0.0f ) +
							(( DistanceFromPlane(wpos2, planes[2]) > -cullEps) ? 1.0f : 0.0f );
			planeTest.w = (( DistanceFromPlane(wpos0, planes[3]) > -cullEps) ? 1.0f : 0.0f ) +
							(( DistanceFromPlane(wpos1, planes[3]) > -cullEps) ? 1.0f : 0.0f ) +
							(( DistanceFromPlane(wpos2, planes[3]) > -cullEps) ? 1.0f : 0.0f );
			return !all (planeTest);
		}

		float4 DistanceBasedTess( float4 v0, float4 v1, float4 v2, float tess, float minDist, float maxDist, float4x4 o2w, float3 cameraPos )
		{
			float3 f;
			f.x = CalcDistanceTessFactor (v0,minDist,maxDist,tess,o2w,cameraPos);
			f.y = CalcDistanceTessFactor (v1,minDist,maxDist,tess,o2w,cameraPos);
			f.z = CalcDistanceTessFactor (v2,minDist,maxDist,tess,o2w,cameraPos);

			return CalcTriEdgeTessFactors (f);
		}

		float4 EdgeLengthBasedTess( float4 v0, float4 v1, float4 v2, float edgeLength, float4x4 o2w, float3 cameraPos, float4 scParams )
		{
			float3 pos0 = mul(o2w,v0).xyz;
			float3 pos1 = mul(o2w,v1).xyz;
			float3 pos2 = mul(o2w,v2).xyz;
			float4 tess;
			tess.x = CalcEdgeTessFactor (pos1, pos2, edgeLength, cameraPos, scParams);
			tess.y = CalcEdgeTessFactor (pos2, pos0, edgeLength, cameraPos, scParams);
			tess.z = CalcEdgeTessFactor (pos0, pos1, edgeLength, cameraPos, scParams);
			tess.w = (tess.x + tess.y + tess.z) / 3.0f;
			return tess;
		}

		float4 EdgeLengthBasedTessCull( float4 v0, float4 v1, float4 v2, float edgeLength, float maxDisplacement, float4x4 o2w, float3 cameraPos, float4 scParams, float4 planes[6] )
		{
			float3 pos0 = mul(o2w,v0).xyz;
			float3 pos1 = mul(o2w,v1).xyz;
			float3 pos2 = mul(o2w,v2).xyz;
			float4 tess;

			if (WorldViewFrustumCull(pos0, pos1, pos2, maxDisplacement, planes))
			{
				tess = 0.0f;
			}
			else
			{
				tess.x = CalcEdgeTessFactor (pos1, pos2, edgeLength, cameraPos, scParams);
				tess.y = CalcEdgeTessFactor (pos2, pos0, edgeLength, cameraPos, scParams);
				tess.z = CalcEdgeTessFactor (pos0, pos1, edgeLength, cameraPos, scParams);
				tess.w = (tess.x + tess.y + tess.z) / 3.0f;
			}
			return tess;
		}
		#endif //ASE_TESS_FUNCS
		ENDHLSL

		
		Pass
		{
			
			Name "Forward"
			Tags { "LightMode"="UniversalForward" "DisableBatching"="False" "TerrainCompatible"="True" "IgnoreProjector"="True" "AlwaysRenderMotionVectors"="false" }

			Blend One Zero
			ZWrite On
			ZTest LEqual
			Offset 0 , 0
			ColorMask RGBA

			

			HLSLPROGRAM

			#define _SPECULAR_SETUP 1
			#define _NORMAL_DROPOFF_TS 1
			#pragma shader_feature_local_fragment _RECEIVE_SHADOWS_OFF
			#pragma shader_feature_local_fragment _ENVIRONMENTREFLECTIONS_OFF
			#pragma multi_compile_fragment _ _SCREEN_SPACE_OCCLUSION
			#pragma instancing_options renderinglayer
			#define ASE_FOG 1
			#pragma multi_compile_fragment _ DEBUG_DISPLAY
			#define _SPECULARHIGHLIGHTS_OFF
			#define ASE_LIGHTING_SIMPLE
			#define ASE_TERRAIN
			#pragma shader_feature _INSTANCEDTERRAINNORMALS_PIXEL
			#define ASE_VERSION 19908
			#define ASE_SRP_VERSION 170100


			#pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
			#pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
            #pragma multi_compile _ EVALUATE_SH_MIXED EVALUATE_SH_VERTEX
			#pragma multi_compile_fragment _ _ADDITIONAL_LIGHT_SHADOWS
			#pragma multi_compile_fragment _ _REFLECTION_PROBE_BLENDING
			#pragma multi_compile_fragment _ _REFLECTION_PROBE_BOX_PROJECTION
			#pragma multi_compile_fragment _ _REFLECTION_PROBE_ATLAS
			#pragma multi_compile_fragment _ _SHADOWS_SOFT _SHADOWS_SOFT_LOW _SHADOWS_SOFT_MEDIUM _SHADOWS_SOFT_HIGH
			#pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
			#pragma multi_compile _ _LIGHT_LAYERS
			#pragma multi_compile_fragment _ _LIGHT_COOKIES
			#pragma multi_compile _ _CLUSTER_LIGHT_LOOP

			#pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
			#pragma multi_compile _ SHADOWS_SHADOWMASK
			#pragma multi_compile _ DIRLIGHTMAP_COMBINED
			#pragma multi_compile _ LIGHTMAP_ON
			#pragma multi_compile _ LIGHTMAP_BICUBIC_SAMPLING
			#pragma multi_compile _ DYNAMICLIGHTMAP_ON
			#pragma multi_compile _ USE_LEGACY_LIGHTMAPS

			#pragma vertex vert
			#pragma fragment frag

			#if defined( _SPECULAR_SETUP ) && defined( ASE_LIGHTING_SIMPLE )
				#if defined( _SPECULARHIGHLIGHTS_OFF )
					#undef _SPECULAR_COLOR
				#else
					#define _SPECULAR_COLOR
				#endif
			#endif

			#define SHADERPASS SHADERPASS_FORWARD

			#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
			#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
			#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Fog.hlsl"
			#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ProbeVolumeVariants.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
            #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			#if defined(LOD_FADE_CROSSFADE)
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/LODCrossFade.hlsl"
            #endif

			#if defined( UNITY_INSTANCING_ENABLED ) && defined( ASE_INSTANCED_TERRAIN ) && ( defined(_TERRAIN_INSTANCED_PERPIXEL_NORMAL) || defined(_INSTANCEDTERRAINNORMALS_PIXEL) )
				#define ENABLE_TERRAIN_PERPIXEL_NORMAL
			#endif

			#define ASE_NEEDS_FRAG_WORLD_VIEW_DIR
			#define ASE_NEEDS_TEXTURE_COORDINATES0
			#define ASE_NEEDS_VERT_TEXTURE_COORDINATES0
			#define ASE_NEEDS_FRAG_TEXTURE_COORDINATES0
			#define ASE_NEEDS_WORLD_TANGENT
			#define ASE_NEEDS_FRAG_WORLD_TANGENT
			#define ASE_NEEDS_WORLD_NORMAL
			#define ASE_NEEDS_FRAG_WORLD_NORMAL
			#define ASE_NEEDS_FRAG_WORLD_BITANGENT
			#define ASE_NEEDS_WORLD_POSITION
			#define ASE_NEEDS_FRAG_WORLD_POSITION
			#define ASE_NEEDS_FRAG_SCREEN_POSITION_NORMALIZED
			#define ASE_NEEDS_FRAG_SHADOWCOORDS
			#define ASE_NEEDS_VERT_TEXTURE_COORDINATES1
			#define ASE_INSTANCED_TERRAIN
			#define ASE_NEEDS_VERT_POSITION
			#define ASE_NEEDS_VERT_NORMAL
			#pragma shader_feature_local _ENABLESPECULARHIGHLIGHTS_ON
			#pragma shader_feature_local _ENABLECOLORTINT_ON
			#pragma multi_compile_instancing
			#pragma instancing_options assumeuniformscaling nomatrices nolightprobe nolightmap
			#define TERRAIN_SPLAT_FIRSTPASS 1
			#pragma editor_sync_compilation
			#pragma multi_compile_local __ _ALPHATEST_ON
			#pragma shader_feature_local _MASKMAP


			#if defined(ASE_EARLY_Z_DEPTH_OPTIMIZE) && (SHADER_TARGET >= 45)
				#define ASE_SV_DEPTH SV_DepthLessEqual
				#define ASE_SV_POSITION_QUALIFIERS linear noperspective centroid
			#else
				#define ASE_SV_DEPTH SV_Depth
				#define ASE_SV_POSITION_QUALIFIERS
			#endif

			struct Attributes
			{
				float4 positionOS : POSITION;
				half3 normalOS : NORMAL;
				half4 tangentOS : TANGENT;
				float4 texcoord : TEXCOORD0;
				#if defined(LIGHTMAP_ON) || defined(ASE_NEEDS_TEXTURE_COORDINATES1)
					float4 texcoord1 : TEXCOORD1;
				#endif
				#if defined(DYNAMICLIGHTMAP_ON) || defined(ASE_NEEDS_TEXTURE_COORDINATES2)
					float4 texcoord2 : TEXCOORD2;
				#endif
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct PackedVaryings
			{
				ASE_SV_POSITION_QUALIFIERS float4 positionCS : SV_POSITION;
				float3 positionWS : TEXCOORD0;
				half3 normalWS : TEXCOORD1;
				float4 tangentWS : TEXCOORD2; // holds terrainUV ifdef ENABLE_TERRAIN_PERPIXEL_NORMAL
				float4 lightmapUVOrVertexSH : TEXCOORD3;
				#if defined(ASE_FOG) || defined(_ADDITIONAL_LIGHTS_VERTEX)
					half4 fogFactorAndVertexLight : TEXCOORD4;
				#endif
				#if defined(DYNAMICLIGHTMAP_ON)
					float2 dynamicLightmapUV : TEXCOORD5;
				#endif
				#if defined(USE_APV_PROBE_OCCLUSION)
					float4 probeOcclusion : TEXCOORD6;
				#endif
				float4 ase_texcoord7 : TEXCOORD7;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _Splat0_ST;
			float4 _TerrainHolesTexture_ST;
			float4 _BaseTint;
			float4 _Splat3_ST;
			float4 _SpecularTint1;
			float4 _Splat1_ST;
			float4 _Control_ST;
			float4 _Splat2_ST;
			float _NormalScale;
			float _SpecularOcclusion;
			float _IndirectSpecularContribution1;
			float _RampOffset;
			float _SpecularIntensity;
			float _SpecularSize1;
			float _SpecularSmoothness1;
			float _RampScale;
			float _Occlusion1;
			float _AlphaClip;
			float _Cutoff;
			#ifdef ASE_TRANSMISSION
				float _TransmissionShadow;
			#endif
			#ifdef ASE_TRANSLUCENCY
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
			#ifdef ASE_TESSELLATION
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END

			#ifdef SCENEPICKINGPASS
				float4 _SelectionID;
			#endif

			#ifdef SCENESELECTIONPASS
				int _ObjectId;
				int _PassValue;
			#endif

			sampler2D _Normal0;
			sampler2D _Splat0;
			sampler2D _Control;
			sampler2D _Normal1;
			sampler2D _Splat1;
			sampler2D _Normal2;
			sampler2D _Splat2;
			sampler2D _Normal3;
			sampler2D _Splat3;
			sampler2D _TerrainHolesTexture;
			sampler2D _TextureRamp3;
			#ifdef UNITY_INSTANCING_ENABLED//ASE Terrain Instancing
				TEXTURE2D(_TerrainHeightmapTexture);//ASE Terrain Instancing
				TEXTURE2D( _TerrainNormalmapTexture);//ASE Terrain Instancing
				SAMPLER(sampler_TerrainNormalmapTexture);//ASE Terrain Instancing
			#endif//ASE Terrain Instancing
			UNITY_INSTANCING_BUFFER_START( Terrain )//ASE Terrain Instancing
				UNITY_DEFINE_INSTANCED_PROP( float4, _TerrainPatchInstanceData )//ASE Terrain Instancing
			UNITY_INSTANCING_BUFFER_END( Terrain)//ASE Terrain Instancing
			CBUFFER_START( UnityTerrain)//ASE Terrain Instancing
				#ifdef UNITY_INSTANCING_ENABLED//ASE Terrain Instancing
					float4 _TerrainHeightmapRecipSize;//ASE Terrain Instancing
					float4 _TerrainHeightmapScale;//ASE Terrain Instancing
				#endif//ASE Terrain Instancing
			CBUFFER_END//ASE Terrain Instancing


			half4 CalculateShadowMask343_g61170(  )
			{
				#if defined(SHADOWS_SHADOWMASK) && defined(LIGHTMAP_ON)
				half4 shadowMask = inputData.shadowMask;
				#elif !defined (LIGHTMAP_ON)
				half4 shadowMask = unity_ProbesOcclusion;
				#else
				half4 shadowMask = half4(1, 1, 1, 1);
				#endif
				return shadowMask;
			}
			
			float3 AdditionalLightsLambertMask171x( float3 WorldPosition, float2 ScreenUV, float3 WorldNormal, float4 ShadowMask )
			{
				float3 Color = 0;
				#if defined(_ADDITIONAL_LIGHTS)
					#define SUM_LIGHTLAMBERT(Light)\
						half3 AttLightColor = Light.color * ( Light.distanceAttenuation * Light.shadowAttenuation );\
						Color += LightingLambert( AttLightColor, Light.direction, WorldNormal );
					InputData inputData = (InputData)0;
					inputData.normalizedScreenSpaceUV = ScreenUV;
					inputData.positionWS = WorldPosition;
					uint meshRenderingLayers = GetMeshRenderingLayer();
					uint pixelLightCount = GetAdditionalLightsCount();	
					#if USE_CLUSTER_LIGHT_LOOP
					[loop] for (uint lightIndex = 0; lightIndex < min(URP_FP_DIRECTIONAL_LIGHTS_COUNT, MAX_VISIBLE_LIGHTS); lightIndex++)
					{
						CLUSTER_LIGHT_LOOP_SUBTRACTIVE_LIGHT_CHECK
						Light light = GetAdditionalLight(lightIndex, WorldPosition, ShadowMask);
						#ifdef _LIGHT_LAYERS
						if (IsMatchingLightLayer(light.layerMask, meshRenderingLayers))
						#endif
						{
							SUM_LIGHTLAMBERT( light );
						}
					}
					#endif
					
					LIGHT_LOOP_BEGIN( pixelLightCount )
						Light light = GetAdditionalLight(lightIndex, WorldPosition, ShadowMask);
						#ifdef _LIGHT_LAYERS
						if (IsMatchingLightLayer(light.layerMask, meshRenderingLayers))
						#endif
						{
							SUM_LIGHTLAMBERT( light );
						}
					LIGHT_LOOP_END
				#endif
				return Color;
			}
			
			half3 ASEIndirectDiffuse( PackedVaryings input, half3 normalWS, float3 positionWS, half3 viewDirWS )
			{
			#if defined( DYNAMICLIGHTMAP_ON )
				return SAMPLE_GI( input.lightmapUVOrVertexSH.xy, input.dynamicLightmapUV.xy, 0, normalWS );
			#elif defined( LIGHTMAP_ON )
				return SAMPLE_GI( input.lightmapUVOrVertexSH.xy, 0, normalWS );
			#elif defined( PROBE_VOLUMES_L1 ) || defined( PROBE_VOLUMES_L2 )
				return SampleProbeVolumePixel( SampleSH( normalWS ), positionWS, normalWS, viewDirWS, input.positionCS.xy );
			#else
				return SampleSH( normalWS );
			#endif
			}
			
			half4 CalculateShadowMask343_g61167(  )
			{
				#if defined(SHADOWS_SHADOWMASK) && defined(LIGHTMAP_ON)
				half4 shadowMask = inputData.shadowMask;
				#elif !defined (LIGHTMAP_ON)
				half4 shadowMask = unity_ProbesOcclusion;
				#else
				half4 shadowMask = half4(1, 1, 1, 1);
				#endif
				return shadowMask;
			}
			
			void TerrainApplyMeshModification( inout float3 position, inout half3 normal, inout float4 texcoord )
			{
			#ifdef UNITY_INSTANCING_ENABLED
				float2 patchVertex = position.xy;
				float4 instanceData = UNITY_ACCESS_INSTANCED_PROP( Terrain, _TerrainPatchInstanceData );
				float2 sampleCoords = ( patchVertex.xy + instanceData.xy ) * instanceData.z;
				float height = UnpackHeightmap( _TerrainHeightmapTexture.Load( int3( sampleCoords, 0 ) ) );
				position.xz = sampleCoords* _TerrainHeightmapScale.xz;
				position.y = height* _TerrainHeightmapScale.y;
				#ifdef ENABLE_TERRAIN_PERPIXEL_NORMAL
					normal = float3(0, 1, 0);
				#else
					normal = _TerrainNormalmapTexture.Load(int3(sampleCoords, 0)).rgb* 2 - 1;
				#endif
				texcoord.xy = sampleCoords* _TerrainHeightmapRecipSize.zw;
			#endif
			}
			

			PackedVaryings VertexFunction( Attributes input  )
			{
				PackedVaryings output = (PackedVaryings)0;
				UNITY_SETUP_INSTANCE_ID(input);
				UNITY_TRANSFER_INSTANCE_ID(input, output);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(output);

				#if defined( ASE_INSTANCED_TERRAIN ) && !defined( ASE_TESSELLATION )
					TerrainApplyMeshModification( input.positionOS.xyz, input.normalOS, input.texcoord );
				#endif
				
				float2 break956_g61173 = _Control_ST.zw;
				float2 appendResult959_g61173 = (float2(( break956_g61173.x + 0.001 ) , ( break956_g61173.y + 0.0001 )));
				float2 vertexToFrag961_g61173 = ( ( input.texcoord.xy * _Control_ST.xy ) + appendResult959_g61173 );
				output.ase_texcoord7.zw = vertexToFrag961_g61173;
				
				output.ase_texcoord7.xy = input.texcoord.xy;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = input.positionOS.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = defaultVertexValue;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					input.positionOS.xyz = vertexValue;
				#else
					input.positionOS.xyz += vertexValue;
				#endif
				input.normalOS = input.normalOS;
				input.tangentOS = input.tangentOS;

				VertexPositionInputs vertexInput = GetVertexPositionInputs( input.positionOS.xyz );
				VertexNormalInputs normalInput = GetVertexNormalInputs( input.normalOS, input.tangentOS );

				OUTPUT_LIGHTMAP_UV(input.texcoord1, unity_LightmapST, output.lightmapUVOrVertexSH.xy);
				#if defined(DYNAMICLIGHTMAP_ON)
					output.dynamicLightmapUV.xy = input.texcoord2.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
				#endif
				OUTPUT_SH4(vertexInput.positionWS, normalInput.normalWS.xyz, GetWorldSpaceNormalizeViewDir(vertexInput.positionWS), output.lightmapUVOrVertexSH.xyz, output.probeOcclusion);

				#if defined(ASE_FOG) || defined(_ADDITIONAL_LIGHTS_VERTEX)
					output.fogFactorAndVertexLight = 0;
					#if defined(ASE_FOG) && !defined(_FOG_FRAGMENT)
						output.fogFactorAndVertexLight.x = ComputeFogFactor(vertexInput.positionCS.z);
					#endif
					#ifdef _ADDITIONAL_LIGHTS_VERTEX
						half3 vertexLight = VertexLighting( vertexInput.positionWS, normalInput.normalWS );
						output.fogFactorAndVertexLight.yzw = vertexLight;
					#endif
				#endif

				output.positionCS = vertexInput.positionCS;
				output.positionWS = vertexInput.positionWS;
				output.normalWS = normalInput.normalWS;
				output.tangentWS = float4( normalInput.tangentWS, ( input.tangentOS.w > 0.0 ? 1.0 : -1.0 ) * GetOddNegativeScale() );

				#if defined( ENABLE_TERRAIN_PERPIXEL_NORMAL )
					output.tangentWS.zw = input.texcoord.xy;
					output.tangentWS.xy = input.texcoord.xy * unity_LightmapST.xy + unity_LightmapST.zw;
				#endif
				return output;
			}

			#if defined(ASE_TESSELLATION)
			struct VertexControl
			{
				float4 positionOS : INTERNALTESSPOS;
				half3 normalOS : NORMAL;
				half4 tangentOS : TANGENT;
				float4 texcoord : TEXCOORD0;
				#if defined(LIGHTMAP_ON) || defined(ASE_NEEDS_TEXTURE_COORDINATES1)
					float4 texcoord1 : TEXCOORD1;
				#endif
				#if defined(DYNAMICLIGHTMAP_ON) || defined(ASE_NEEDS_TEXTURE_COORDINATES2)
					float4 texcoord2 : TEXCOORD2;
				#endif
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( Attributes input )
			{
				VertexControl output;
				UNITY_SETUP_INSTANCE_ID(input);
				UNITY_TRANSFER_INSTANCE_ID(input, output);
				output.positionOS = input.positionOS;
				output.normalOS = input.normalOS;
				output.tangentOS = input.tangentOS;
				output.texcoord = input.texcoord;
				#if defined(LIGHTMAP_ON) || defined(ASE_NEEDS_TEXTURE_COORDINATES1)
					output.texcoord1 = input.texcoord1;
				#endif
				#if defined(DYNAMICLIGHTMAP_ON) || defined(ASE_NEEDS_TEXTURE_COORDINATES2)
					output.texcoord2 = input.texcoord2;
				#endif
				#if defined( ASE_INSTANCED_TERRAIN )
					TerrainApplyMeshModification( output.positionOS.xyz, output.normalOS, output.texcoord );
				#endif
				
				return output;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> input)
			{
				TessellationFactors output;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(input[0].positionOS, input[1].positionOS, input[2].positionOS, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(input[0].positionOS, input[1].positionOS, input[2].positionOS, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(input[0].positionOS, input[1].positionOS, input[2].positionOS, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				output.edge[0] = tf.x; output.edge[1] = tf.y; output.edge[2] = tf.z; output.inside = tf.w;
				return output;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
				return patch[id];
			}

			[domain("tri")]
			PackedVaryings DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				Attributes output = (Attributes) 0;
				output.positionOS = patch[0].positionOS * bary.x + patch[1].positionOS * bary.y + patch[2].positionOS * bary.z;
				output.normalOS = patch[0].normalOS * bary.x + patch[1].normalOS * bary.y + patch[2].normalOS * bary.z;
				output.tangentOS = patch[0].tangentOS * bary.x + patch[1].tangentOS * bary.y + patch[2].tangentOS * bary.z;
				output.texcoord = patch[0].texcoord * bary.x + patch[1].texcoord * bary.y + patch[2].texcoord * bary.z;
				#if defined(LIGHTMAP_ON) || defined(ASE_NEEDS_TEXTURE_COORDINATES1)
					output.texcoord1 = patch[0].texcoord1 * bary.x + patch[1].texcoord1 * bary.y + patch[2].texcoord1 * bary.z;
				#endif
				#if defined(DYNAMICLIGHTMAP_ON) || defined(ASE_NEEDS_TEXTURE_COORDINATES2)
					output.texcoord2 = patch[0].texcoord2 * bary.x + patch[1].texcoord2 * bary.y + patch[2].texcoord2 * bary.z;
				#endif
				
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = output.positionOS.xyz - patch[i].normalOS * (dot(output.positionOS.xyz, patch[i].normalOS) - dot(patch[i].positionOS.xyz, patch[i].normalOS));
				float phongStrength = _TessPhongStrength;
				output.positionOS.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * output.positionOS.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], output);
				return VertexFunction(output);
			}
			#else
			PackedVaryings vert ( Attributes input )
			{
				return VertexFunction( input );
			}
			#endif

			half4 frag ( PackedVaryings input
						#if defined( ASE_DEPTH_WRITE_ON )
						,out float outputDepth : ASE_SV_DEPTH
						#endif
						#ifdef _WRITE_RENDERING_LAYERS
						, out float4 outRenderingLayers : SV_Target1
						#endif
						 ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(input);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input);

				#if defined( _SURFACE_TYPE_TRANSPARENT )
					const bool isTransparent = true;
				#else
					const bool isTransparent = false;
				#endif

				#if defined(LOD_FADE_CROSSFADE)
					LODFadeCrossFade( input.positionCS );
				#endif

				#if defined(MAIN_LIGHT_CALCULATE_SHADOWS)
					float4 shadowCoord = TransformWorldToShadowCoord( input.positionWS );
				#else
					float4 shadowCoord = float4(0, 0, 0, 0);
				#endif

				// @diogo: mikktspace compliant
				float renormFactor = 1.0 / max( FLT_MIN, length( input.normalWS ) );

				float3 PositionWS = input.positionWS;
				float3 PositionRWS = GetCameraRelativePositionWS( PositionWS );
				float3 ViewDirWS = GetWorldSpaceNormalizeViewDir( PositionWS );
				float4 ShadowCoord = shadowCoord;
				float4 ScreenPosNorm = float4( GetNormalizedScreenSpaceUV( input.positionCS ), input.positionCS.zw );
				float4 ClipPos = ComputeClipSpacePosition( ScreenPosNorm.xy, input.positionCS.z ) * input.positionCS.w;
				float4 ScreenPos = ComputeScreenPos( ClipPos );
				float3 TangentWS = input.tangentWS.xyz * renormFactor;
				float3 BitangentWS = cross( input.normalWS, input.tangentWS.xyz ) * input.tangentWS.w * renormFactor;
				float3 NormalWS = input.normalWS * renormFactor;

				#if defined( ENABLE_TERRAIN_PERPIXEL_NORMAL )
					float2 sampleCoords = (input.tangentWS.zw / _TerrainHeightmapRecipSize.zw + 0.5f) * _TerrainHeightmapRecipSize.xy;
					NormalWS = TransformObjectToWorldNormal(normalize(SAMPLE_TEXTURE2D(_TerrainNormalmapTexture, sampler_TerrainNormalmapTexture, sampleCoords).rgb * 2 - 1));
					TangentWS = -cross(GetObjectToWorldMatrix()._13_23_33, NormalWS);
					BitangentWS = cross(NormalWS, -TangentWS);
				#endif

				float3 temp_cast_0 = (1.0).xxx;
				float4 ControlFinal724_g61173 = float4( 1, 1, 1, 1 );
				float2 uv_Splat0 = input.ase_texcoord7.xy * _Splat0_ST.xy + _Splat0_ST.zw;
				float4 tex2DNode2_g61173 = tex2D( _Normal0, uv_Splat0 );
				float _HeightA279_g61173 = tex2DNode2_g61173.a;
				float smoothstepResult810_g61173 = smoothstep( 0.0 , 1.0 , _HeightA279_g61173);
				float clampResult933_g61173 = clamp( smoothstepResult810_g61173 , 0.001 , 0.999 );
				float2 vertexToFrag961_g61173 = input.ase_texcoord7.zw;
				float4 tex2DNode5_g61173 = tex2D( _Control, vertexToFrag961_g61173 );
				float _MaskA481_g61173 = tex2DNode5_g61173.r;
				float clampResult830_g61173 = clamp( _MaskA481_g61173 , 0.0 , 1.0 );
				float temp_output_829_0_g61173 = ( clampResult933_g61173 * clampResult830_g61173 );
				float3 break635_g61173 = tex2DNode2_g61173.rgb;
				float2 appendResult655_g61173 = (float2(( ( break635_g61173.x * 2.0 ) - 1.0 ) , ( ( break635_g61173.y * 2.0 ) - 1.0 )));
				float3 appendResult656_g61173 = (float3(appendResult655_g61173 , sqrt( max( 0.0, ( 1.0 - ( ( break635_g61173.x * break635_g61173.x ) + ( break635_g61173.y * break635_g61173.y ) ) ) ) )));
				float3 _UnpackedNormalA720_g61173 = appendResult656_g61173;
				float2 uv_Splat1 = input.ase_texcoord7.xy * _Splat1_ST.xy + _Splat1_ST.zw;
				float4 tex2DNode1_g61173 = tex2D( _Normal1, uv_Splat1 );
				float _HeightB280_g61173 = tex2DNode1_g61173.a;
				float smoothstepResult812_g61173 = smoothstep( 0.0 , 1.0 , _HeightB280_g61173);
				float clampResult934_g61173 = clamp( smoothstepResult812_g61173 , 0.001 , 0.999 );
				float _MaskB482_g61173 = tex2DNode5_g61173.g;
				float clampResult832_g61173 = clamp( _MaskB482_g61173 , 0.0 , 1.0 );
				float temp_output_826_0_g61173 = ( clampResult934_g61173 * clampResult832_g61173 );
				float3 break657_g61173 = tex2DNode1_g61173.rgb;
				float2 appendResult664_g61173 = (float2(( ( break657_g61173.x * 2.0 ) - 1.0 ) , ( ( break657_g61173.y * 2.0 ) - 1.0 )));
				float3 appendResult673_g61173 = (float3(appendResult664_g61173 , sqrt( max( 0.0, ( 1.0 - ( ( break657_g61173.x * break657_g61173.x ) + ( break657_g61173.y * break657_g61173.y ) ) ) ) )));
				float3 _UnpackedNormalB721_g61173 = appendResult673_g61173;
				float2 uv_Splat2 = input.ase_texcoord7.xy * _Splat2_ST.xy + _Splat2_ST.zw;
				float4 tex2DNode10_g61173 = tex2D( _Normal2, uv_Splat2 );
				float _HeightC281_g61173 = tex2DNode10_g61173.a;
				float smoothstepResult811_g61173 = smoothstep( 0.0 , 1.0 , _HeightC281_g61173);
				float clampResult935_g61173 = clamp( smoothstepResult811_g61173 , 0.001 , 0.999 );
				float _MaskC483_g61173 = tex2DNode5_g61173.b;
				float clampResult831_g61173 = clamp( _MaskC483_g61173 , 0.0 , 1.0 );
				float temp_output_827_0_g61173 = ( clampResult935_g61173 * clampResult831_g61173 );
				float3 break676_g61173 = tex2DNode10_g61173.rgb;
				float2 appendResult683_g61173 = (float2(( ( break676_g61173.x * 2.0 ) - 1.0 ) , ( ( break676_g61173.y * 2.0 ) - 1.0 )));
				float3 appendResult692_g61173 = (float3(appendResult683_g61173 , sqrt( max( 0.0, ( 1.0 - ( ( break676_g61173.x * break676_g61173.x ) + ( break676_g61173.y * break676_g61173.y ) ) ) ) )));
				float3 _UnpackedNormalC722_g61173 = appendResult692_g61173;
				float2 uv_Splat3 = input.ase_texcoord7.xy * _Splat3_ST.xy + _Splat3_ST.zw;
				float4 tex2DNode11_g61173 = tex2D( _Normal3, uv_Splat3 );
				float _HeightD282_g61173 = tex2DNode11_g61173.a;
				float smoothstepResult813_g61173 = smoothstep( 0.0 , 1.0 , _HeightD282_g61173);
				float clampResult936_g61173 = clamp( smoothstepResult813_g61173 , 0.001 , 0.999 );
				float _MaskD484_g61173 = tex2DNode5_g61173.a;
				float clampResult833_g61173 = clamp( _MaskD484_g61173 , 0.0 , 1.0 );
				float temp_output_828_0_g61173 = ( clampResult936_g61173 * clampResult833_g61173 );
				float3 break695_g61173 = tex2DNode11_g61173.rgb;
				float2 appendResult702_g61173 = (float2(( ( break695_g61173.x * 2.0 ) - 1.0 ) , ( ( break695_g61173.y * 2.0 ) - 1.0 )));
				float3 appendResult711_g61173 = (float3(appendResult702_g61173 , sqrt( max( 0.0, ( 1.0 - ( ( break695_g61173.x * break695_g61173.x ) + ( break695_g61173.y * break695_g61173.y ) ) ) ) )));
				float3 _UnpackedNormalD723_g61173 = appendResult711_g61173;
				float4 weightedBlendVar840_g61173 = ControlFinal724_g61173;
				float3 weightedBlend840_g61173 = ( weightedBlendVar840_g61173.x*( temp_output_829_0_g61173 * _UnpackedNormalA720_g61173 ) + weightedBlendVar840_g61173.y*( temp_output_826_0_g61173 * _UnpackedNormalB721_g61173 ) + weightedBlendVar840_g61173.z*( temp_output_827_0_g61173 * _UnpackedNormalC722_g61173 ) + weightedBlendVar840_g61173.w*( temp_output_828_0_g61173 * _UnpackedNormalD723_g61173 ) );
				float4 weightedBlendVar841_g61173 = ControlFinal724_g61173;
				float weightedBlend841_g61173 = ( weightedBlendVar841_g61173.x*temp_output_829_0_g61173 + weightedBlendVar841_g61173.y*temp_output_826_0_g61173 + weightedBlendVar841_g61173.z*temp_output_827_0_g61173 + weightedBlendVar841_g61173.w*temp_output_828_0_g61173 );
				float3 FinalNormal765_g61173 = ( weightedBlend840_g61173 / max( weightedBlend841_g61173, 0.001 ) );
				float3 temp_output_61_0_g61173 = FinalNormal765_g61173;
				float3 Normal554 = temp_output_61_0_g61173;
				float3 tanToWorld0 = float3( TangentWS.x, BitangentWS.x, NormalWS.x );
				float3 tanToWorld1 = float3( TangentWS.y, BitangentWS.y, NormalWS.y );
				float3 tanToWorld2 = float3( TangentWS.z, BitangentWS.z, NormalWS.z );
				float3 tanNormal638 = ( Normal554 * _NormalScale );
				float3 worldNormal638 = normalize( float3( dot( tanToWorld0, tanNormal638 ), dot( tanToWorld1, tanNormal638 ), dot( tanToWorld2, tanNormal638 ) ) );
				float3 normalizeResult640 = normalize( worldNormal638 );
				float3 Normals780 = normalizeResult640;
				float smoothstepResult859_g61173 = smoothstep( 0.0 , 1.0 , _HeightA279_g61173);
				float clampResult937_g61173 = clamp( smoothstepResult859_g61173 , 0.001 , 0.999 );
				float clampResult879_g61173 = clamp( _MaskA481_g61173 , 0.0 , 1.0 );
				float temp_output_878_0_g61173 = ( clampResult937_g61173 * clampResult879_g61173 );
				float4 tex2DNode4_g61173 = tex2D( _Splat0, uv_Splat0 );
				float _LayerAlphaA778_g61173 = tex2DNode4_g61173.a;
				float smoothstepResult861_g61173 = smoothstep( 0.0 , 1.0 , _HeightB280_g61173);
				float clampResult938_g61173 = clamp( smoothstepResult861_g61173 , 0.001 , 0.999 );
				float clampResult881_g61173 = clamp( _MaskB482_g61173 , 0.0 , 1.0 );
				float temp_output_875_0_g61173 = ( clampResult938_g61173 * clampResult881_g61173 );
				float4 tex2DNode3_g61173 = tex2D( _Splat1, uv_Splat1 );
				float _LayerAlphaB779_g61173 = tex2DNode3_g61173.a;
				float smoothstepResult860_g61173 = smoothstep( 0.0 , 1.0 , _HeightC281_g61173);
				float clampResult939_g61173 = clamp( smoothstepResult860_g61173 , 0.001 , 0.999 );
				float clampResult880_g61173 = clamp( _MaskC483_g61173 , 0.0 , 1.0 );
				float temp_output_876_0_g61173 = ( clampResult939_g61173 * clampResult880_g61173 );
				float4 tex2DNode6_g61173 = tex2D( _Splat2, uv_Splat2 );
				float _LayerAlphaC780_g61173 = tex2DNode6_g61173.a;
				float smoothstepResult862_g61173 = smoothstep( 0.0 , 1.0 , _HeightD282_g61173);
				float clampResult940_g61173 = clamp( smoothstepResult862_g61173 , 0.001 , 0.999 );
				float clampResult882_g61173 = clamp( _MaskD484_g61173 , 0.0 , 1.0 );
				float temp_output_877_0_g61173 = ( clampResult940_g61173 * clampResult882_g61173 );
				float4 tex2DNode7_g61173 = tex2D( _Splat3, uv_Splat3 );
				float _LayerAlphaD781_g61173 = tex2DNode7_g61173.a;
				float4 weightedBlendVar887_g61173 = ControlFinal724_g61173;
				float weightedBlend887_g61173 = ( weightedBlendVar887_g61173.x*( temp_output_878_0_g61173 * _LayerAlphaA778_g61173 ) + weightedBlendVar887_g61173.y*( temp_output_875_0_g61173 * _LayerAlphaB779_g61173 ) + weightedBlendVar887_g61173.z*( temp_output_876_0_g61173 * _LayerAlphaC780_g61173 ) + weightedBlendVar887_g61173.w*( temp_output_877_0_g61173 * _LayerAlphaD781_g61173 ) );
				float4 weightedBlendVar888_g61173 = ControlFinal724_g61173;
				float weightedBlend888_g61173 = ( weightedBlendVar888_g61173.x*temp_output_878_0_g61173 + weightedBlendVar888_g61173.y*temp_output_875_0_g61173 + weightedBlendVar888_g61173.z*temp_output_876_0_g61173 + weightedBlendVar888_g61173.w*temp_output_877_0_g61173 );
				float FinalSmoothness897_g61173 = ( weightedBlend887_g61173 / max( weightedBlend888_g61173, 0.001 ) );
				float Smoothness533 = FinalSmoothness897_g61173;
				half3 reflectVector772 = reflect( -ViewDirWS, Normals780 );
				float3 indirectSpecular772 = GlossyEnvironmentReflection( reflectVector772, PositionWS, 1.0 - Smoothness533, _SpecularOcclusion, ScreenPosNorm.xy );
				float3 lerpResult643 = lerp( temp_cast_0 , indirectSpecular772 , _IndirectSpecularContribution1);
				float3 IndirectSpecHighlights793 = lerpResult643;
				float4 temp_output_751_0 = ( _SpecularTint1 * Smoothness533 * _SpecularIntensity );
				float3 normalizeResult4_g61169 = normalize( ( ViewDirWS + SafeNormalize( _MainLightPosition.xyz ) ) );
				float dotResult749 = dot( normalizeResult4_g61169 , Normals780 );
				float3 WorldPosition288_g61170 = PositionWS;
				float3 WorldPosition337_g61170 = WorldPosition288_g61170;
				float2 ScreenUV286_g61170 = (ScreenPosNorm).xy;
				float2 ScreenUV337_g61170 = ScreenUV286_g61170;
				float3 WorldNormal281_g61170 = Normals780;
				float3 WorldNormal337_g61170 = WorldNormal281_g61170;
				half4 localCalculateShadowMask343_g61170 = CalculateShadowMask343_g61170();
				float4 ShadowMask360_g61170 = localCalculateShadowMask343_g61170;
				float4 ShadowMask337_g61170 = ShadowMask360_g61170;
				float3 localAdditionalLightsLambertMask171x337_g61170 = AdditionalLightsLambertMask171x( WorldPosition337_g61170 , ScreenUV337_g61170 , WorldNormal337_g61170 , ShadowMask337_g61170 );
				float4 DirectSpecHighlights764 = ( float4( (temp_output_751_0).rgb , 0.0 ) * saturate( ( float4( (  (-1.0 + ( _SpecularSize1 - 0.0 ) * ( -0.5 - -1.0 ) / ( 1.0 - 0.0 ) ) + ( dotResult749 + saturate( localAdditionalLightsLambertMask171x337_g61170 ) ) ) , 0.0 ) / ( ( 1.0 - temp_output_751_0 ) * _SpecularSmoothness1 ) ) ) );
				float ase_lightIntensity = max( max( _MainLightColor.r, _MainLightColor.g ), _MainLightColor.b ) + 1e-7;
				float4 ase_lightColor = float4( _MainLightColor.rgb / ase_lightIntensity, ase_lightIntensity );
				float ase_lightAtten = 0;
				Light ase_mainLight = GetMainLight( ShadowCoord );
				ase_lightAtten = ase_mainLight.distanceAttenuation * ase_mainLight.shadowAttenuation;
				float3 bakedGI730 = ASEIndirectDiffuse( input, NormalWS, PositionWS, ViewDirWS );
				MixRealtimeAndBakedGI( ase_mainLight, NormalWS, bakedGI730, half4( 0, 0, 0, 0 ) );
				float4 HalfLambert733 = ( ( ase_lightColor * ase_lightAtten ) + float4( bakedGI730 , 0.0 ) );
				float4 SpecularHighlights768 = ( float4( IndirectSpecHighlights793 , 0.0 ) * DirectSpecHighlights764 * HalfLambert733 );
				#ifdef _ENABLESPECULARHIGHLIGHTS_ON
				float4 staticSwitch763 = SpecularHighlights768;
				#else
				float4 staticSwitch763 = float4( 0,0,0,0 );
				#endif
				float4 color648 = IsGammaSpace() ? float4( 1, 1, 1, 1 ) : float4( 1, 1, 1, 1 );
				#ifdef _ENABLECOLORTINT_ON
				float4 staticSwitch774 = _BaseTint;
				#else
				float4 staticSwitch774 = color648;
				#endif
				float smoothstepResult591_g61173 = smoothstep( 0.0 , 1.0 , _HeightA279_g61173);
				float clampResult944_g61173 = clamp( smoothstepResult591_g61173 , 0.001 , 0.999 );
				float clampResult603_g61173 = clamp( _MaskA481_g61173 , 0.0 , 1.0 );
				float temp_output_597_0_g61173 = ( clampResult944_g61173 * clampResult603_g61173 );
				float4 _LayerA287_g61173 = tex2DNode4_g61173;
				float smoothstepResult594_g61173 = smoothstep( 0.0 , 1.0 , _HeightB280_g61173);
				float clampResult943_g61173 = clamp( smoothstepResult594_g61173 , 0.001 , 0.999 );
				float clampResult604_g61173 = clamp( _MaskB482_g61173 , 0.0 , 1.0 );
				float temp_output_598_0_g61173 = ( clampResult943_g61173 * clampResult604_g61173 );
				float4 _LayerB300_g61173 = tex2DNode3_g61173;
				float smoothstepResult595_g61173 = smoothstep( 0.0 , 1.0 , _HeightC281_g61173);
				float clampResult942_g61173 = clamp( smoothstepResult595_g61173 , 0.001 , 0.999 );
				float clampResult605_g61173 = clamp( _MaskC483_g61173 , 0.0 , 1.0 );
				float temp_output_599_0_g61173 = ( clampResult942_g61173 * clampResult605_g61173 );
				float4 _LayerC301_g61173 = tex2DNode6_g61173;
				float smoothstepResult596_g61173 = smoothstep( 0.0 , 1.0 , _HeightD282_g61173);
				float clampResult941_g61173 = clamp( smoothstepResult596_g61173 , 0.001 , 0.999 );
				float clampResult606_g61173 = clamp( _MaskD484_g61173 , 0.0 , 1.0 );
				float temp_output_600_0_g61173 = ( clampResult941_g61173 * clampResult606_g61173 );
				float4 _LayerD302_g61173 = tex2DNode7_g61173;
				float4 weightedBlendVar619_g61173 = ControlFinal724_g61173;
				float4 weightedBlend619_g61173 = ( weightedBlendVar619_g61173.x*( temp_output_597_0_g61173 * _LayerA287_g61173 ) + weightedBlendVar619_g61173.y*( temp_output_598_0_g61173 * _LayerB300_g61173 ) + weightedBlendVar619_g61173.z*( temp_output_599_0_g61173 * _LayerC301_g61173 ) + weightedBlendVar619_g61173.w*( temp_output_600_0_g61173 * _LayerD302_g61173 ) );
				float4 weightedBlendVar620_g61173 = ControlFinal724_g61173;
				float weightedBlend620_g61173 = ( weightedBlendVar620_g61173.x*temp_output_597_0_g61173 + weightedBlendVar620_g61173.y*temp_output_598_0_g61173 + weightedBlendVar620_g61173.z*temp_output_599_0_g61173 + weightedBlendVar620_g61173.w*temp_output_600_0_g61173 );
				float4 FinalAlbedo479_g61173 = ( weightedBlend619_g61173 / max( weightedBlend620_g61173, 0.001 ) );
				float4 temp_output_60_0_g61173 = FinalAlbedo479_g61173;
				float4 localClipHoles100_g61173 = ( temp_output_60_0_g61173 );
				float2 uv_TerrainHolesTexture = input.ase_texcoord7.xy * _TerrainHolesTexture_ST.xy + _TerrainHolesTexture_ST.zw;
				float holeClipValue99_g61173 = tex2D( _TerrainHolesTexture, uv_TerrainHolesTexture ).r;
				float Hole100_g61173 = holeClipValue99_g61173;
				{
				#ifdef _ALPHATEST_ON
				clip(Hole100_g61173 == 0.0f ? -1 : 1);
				#endif
				}
				float4 Albedo536 = localClipHoles100_g61173;
				float dotResult723 = dot( Normals780 , SafeNormalize( _MainLightPosition.xyz ) );
				float RampScale743 = _RampScale;
				float RampOffset742 = _RampOffset;
				float CEL_Effect664 = saturate( (dotResult723*RampScale743 + RampOffset742) );
				float2 temp_cast_6 = (CEL_Effect664).xx;
				float3 WorldPosition288_g61167 = PositionWS;
				float3 WorldPosition337_g61167 = WorldPosition288_g61167;
				float2 ScreenUV286_g61167 = (ScreenPosNorm).xy;
				float2 ScreenUV337_g61167 = ScreenUV286_g61167;
				float3 WorldNormal281_g61167 = Normals780;
				float3 WorldNormal337_g61167 = WorldNormal281_g61167;
				half4 localCalculateShadowMask343_g61167 = CalculateShadowMask343_g61167();
				float4 ShadowMask360_g61167 = localCalculateShadowMask343_g61167;
				float4 ShadowMask337_g61167 = ShadowMask360_g61167;
				float3 localAdditionalLightsLambertMask171x337_g61167 = AdditionalLightsLambertMask171x( WorldPosition337_g61167 , ScreenUV337_g61167 , WorldNormal337_g61167 , ShadowMask337_g61167 );
				

				float3 BaseColor = ( staticSwitch763 + ( staticSwitch774 * ( ( ( Albedo536 * tex2D( _TextureRamp3, temp_cast_6 ) ) * HalfLambert733 ) + ( Albedo536 * tex2D( _TextureRamp3, (saturate( localAdditionalLightsLambertMask171x337_g61167 )*RampScale743 + RampOffset742).xy ) ) ) ) ).rgb;
				float3 Normal = float3(0, 0, 1);
				float3 Specular = 0.5;
				float Metallic = 0;
				float Smoothness = 0.5;
				float Occlusion = _Occlusion1;
				float3 Emission = 0;
				float Alpha = 1;
				#if defined( _ALPHATEST_ON )
					float AlphaClipThreshold = _Cutoff;
					float AlphaClipThresholdShadow = 0.5;
				#endif
				float3 BakedGI = 0;
				float3 RefractionColor = 1;
				float RefractionIndex = 1;
				float3 Transmission = 1;
				float3 Translucency = 1;

				#if defined( ASE_DEPTH_WRITE_ON )
					input.positionCS.z = input.positionCS.z;
				#endif

				#ifdef _CLEARCOAT
					float CoatMask = 0;
					float CoatSmoothness = 0;
				#endif

				#if defined( _ALPHATEST_ON )
					AlphaDiscard( Alpha, AlphaClipThreshold );
				#endif

				#if defined(MAIN_LIGHT_CALCULATE_SHADOWS) && defined(ASE_CHANGES_WORLD_POS)
					ShadowCoord = TransformWorldToShadowCoord( PositionWS );
				#endif

				InputData inputData = (InputData)0;
				inputData.positionWS = PositionWS;
				inputData.positionCS = input.positionCS;
				inputData.normalizedScreenSpaceUV = ScreenPosNorm.xy;
				inputData.viewDirectionWS = ViewDirWS;
				inputData.shadowCoord = ShadowCoord;

				#ifdef _NORMALMAP
						#if _NORMAL_DROPOFF_TS
							inputData.normalWS = TransformTangentToWorld(Normal, half3x3(TangentWS, BitangentWS, NormalWS));
						#elif _NORMAL_DROPOFF_OS
							inputData.normalWS = TransformObjectToWorldNormal(Normal);
						#elif _NORMAL_DROPOFF_WS
							inputData.normalWS = Normal;
						#endif
					inputData.normalWS = NormalizeNormalPerPixel(inputData.normalWS);
				#else
					inputData.normalWS = NormalWS;
				#endif

				#ifdef ASE_FOG
					inputData.fogCoord = InitializeInputDataFog(float4(inputData.positionWS, 1.0), input.fogFactorAndVertexLight.x);
				#endif
				#ifdef _ADDITIONAL_LIGHTS_VERTEX
					inputData.vertexLighting = input.fogFactorAndVertexLight.yzw;
				#endif

				#if defined( ENABLE_TERRAIN_PERPIXEL_NORMAL )
					float3 SH = SampleSH(inputData.normalWS.xyz);
				#else
					float3 SH = input.lightmapUVOrVertexSH.xyz;
				#endif

				#if defined(DYNAMICLIGHTMAP_ON)
					inputData.bakedGI = SAMPLE_GI(input.lightmapUVOrVertexSH.xy, input.dynamicLightmapUV.xy, SH, inputData.normalWS);
					inputData.shadowMask = SAMPLE_SHADOWMASK(input.lightmapUVOrVertexSH.xy);
				#elif !defined(LIGHTMAP_ON) && (defined(PROBE_VOLUMES_L1) || defined(PROBE_VOLUMES_L2))
					inputData.bakedGI = SAMPLE_GI( SH, GetAbsolutePositionWS(inputData.positionWS),
						inputData.normalWS,
						inputData.viewDirectionWS,
						input.positionCS.xy,
						input.probeOcclusion,
						inputData.shadowMask );
				#else
					inputData.bakedGI = SAMPLE_GI(input.lightmapUVOrVertexSH.xy, SH, inputData.normalWS);
					inputData.shadowMask = SAMPLE_SHADOWMASK(input.lightmapUVOrVertexSH.xy);
				#endif

				#ifdef ASE_BAKEDGI
					inputData.bakedGI = BakedGI;
				#endif

				#if defined(DEBUG_DISPLAY)
					#if defined(DYNAMICLIGHTMAP_ON)
						inputData.dynamicLightmapUV = input.dynamicLightmapUV.xy;
					#endif
					#if defined(LIGHTMAP_ON)
						inputData.staticLightmapUV = input.lightmapUVOrVertexSH.xy;
					#else
						inputData.vertexSH = SH;
					#endif
					#if defined(USE_APV_PROBE_OCCLUSION)
						inputData.probeOcclusion = input.probeOcclusion;
					#endif
				#endif

				SurfaceData surfaceData;
				surfaceData.albedo              = BaseColor;
				surfaceData.metallic            = saturate(Metallic);
				surfaceData.specular            = Specular;
				surfaceData.smoothness          = saturate(Smoothness),
				surfaceData.occlusion           = Occlusion,
				surfaceData.emission            = Emission,
				surfaceData.alpha               = saturate(Alpha);
				surfaceData.normalTS            = Normal;
				surfaceData.clearCoatMask       = 0;
				surfaceData.clearCoatSmoothness = 1;

				#ifdef _CLEARCOAT
					surfaceData.clearCoatMask       = saturate(CoatMask);
					surfaceData.clearCoatSmoothness = saturate(CoatSmoothness);
				#endif

				#if defined(_DBUFFER)
					ApplyDecalToSurfaceData(input.positionCS, surfaceData, inputData);
				#endif

				#ifdef ASE_LIGHTING_SIMPLE
					half4 color = UniversalFragmentBlinnPhong( inputData, surfaceData);
				#else
					half4 color = UniversalFragmentPBR( inputData, surfaceData);
				#endif

				#ifdef ASE_TRANSMISSION
				{
					float shadow = _TransmissionShadow;

					#define SUM_LIGHT_TRANSMISSION(Light)\
						float3 atten = Light.color * Light.distanceAttenuation;\
						atten = lerp( atten, atten * Light.shadowAttenuation, shadow );\
						half3 transmission = max( 0, -dot( inputData.normalWS, Light.direction ) ) * atten * Transmission;\
						color.rgb += BaseColor * transmission;

					SUM_LIGHT_TRANSMISSION( GetMainLight( inputData.shadowCoord ) );

					#if defined(_ADDITIONAL_LIGHTS)
						uint meshRenderingLayers = GetMeshRenderingLayer();
						uint pixelLightCount = GetAdditionalLightsCount();
						#if USE_CLUSTER_LIGHT_LOOP
							[loop] for (uint lightIndex = 0; lightIndex < min(URP_FP_DIRECTIONAL_LIGHTS_COUNT, MAX_VISIBLE_LIGHTS); lightIndex++)
							{
								CLUSTER_LIGHT_LOOP_SUBTRACTIVE_LIGHT_CHECK

								Light light = GetAdditionalLight(lightIndex, inputData.positionWS, inputData.shadowMask);
								#ifdef _LIGHT_LAYERS
								if (IsMatchingLightLayer(light.layerMask, meshRenderingLayers))
								#endif
								{
									SUM_LIGHT_TRANSMISSION( light );
								}
							}
						#endif
						LIGHT_LOOP_BEGIN( pixelLightCount )
							Light light = GetAdditionalLight(lightIndex, inputData.positionWS, inputData.shadowMask);
							#ifdef _LIGHT_LAYERS
							if (IsMatchingLightLayer(light.layerMask, meshRenderingLayers))
							#endif
							{
								SUM_LIGHT_TRANSMISSION( light );
							}
						LIGHT_LOOP_END
					#endif
				}
				#endif

				#ifdef ASE_TRANSLUCENCY
				{
					float shadow = _TransShadow;
					float normal = _TransNormal;
					float scattering = _TransScattering;
					float direct = _TransDirect;
					float ambient = _TransAmbient;
					float strength = _TransStrength;

					#define SUM_LIGHT_TRANSLUCENCY(Light)\
						float3 atten = Light.color * Light.distanceAttenuation;\
						atten = lerp( atten, atten * Light.shadowAttenuation, shadow );\
						half3 lightDir = Light.direction + inputData.normalWS * normal;\
						half VdotL = pow( saturate( dot( inputData.viewDirectionWS, -lightDir ) ), scattering );\
						half3 translucency = atten * ( VdotL * direct + inputData.bakedGI * ambient ) * Translucency;\
						color.rgb += BaseColor * translucency * strength;

					SUM_LIGHT_TRANSLUCENCY( GetMainLight( inputData.shadowCoord ) );

					#if defined(_ADDITIONAL_LIGHTS)
						uint meshRenderingLayers = GetMeshRenderingLayer();
						uint pixelLightCount = GetAdditionalLightsCount();
						#if USE_CLUSTER_LIGHT_LOOP
							[loop] for (uint lightIndex = 0; lightIndex < min(URP_FP_DIRECTIONAL_LIGHTS_COUNT, MAX_VISIBLE_LIGHTS); lightIndex++)
							{
								CLUSTER_LIGHT_LOOP_SUBTRACTIVE_LIGHT_CHECK

								Light light = GetAdditionalLight(lightIndex, inputData.positionWS, inputData.shadowMask);
								#ifdef _LIGHT_LAYERS
								if (IsMatchingLightLayer(light.layerMask, meshRenderingLayers))
								#endif
								{
									SUM_LIGHT_TRANSLUCENCY( light );
								}
							}
						#endif
						LIGHT_LOOP_BEGIN( pixelLightCount )
							Light light = GetAdditionalLight(lightIndex, inputData.positionWS, inputData.shadowMask);
							#ifdef _LIGHT_LAYERS
							if (IsMatchingLightLayer(light.layerMask, meshRenderingLayers))
							#endif
							{
								SUM_LIGHT_TRANSLUCENCY( light );
							}
						LIGHT_LOOP_END
					#endif
				}
				#endif

				#ifdef ASE_REFRACTION
					float4 projScreenPos = ScreenPos / ScreenPos.w;
					float3 refractionOffset = ( RefractionIndex - 1.0 ) * mul( UNITY_MATRIX_V, float4( NormalWS,0 ) ).xyz * ( 1.0 - dot( NormalWS, ViewDirWS ) );
					projScreenPos.xy += refractionOffset.xy;
					float3 refraction = SHADERGRAPH_SAMPLE_SCENE_COLOR( projScreenPos.xy ) * RefractionColor;
					color.rgb = lerp( refraction, color.rgb, color.a );
					color.a = 1;
				#endif

				#ifdef ASE_FINAL_COLOR_ALPHA_MULTIPLY
					color.rgb *= color.a;
				#endif

				#ifdef ASE_FOG
					#ifdef TERRAIN_SPLAT_ADDPASS
						color.rgb = MixFogColor(color.rgb, half3(0,0,0), inputData.fogCoord);
					#else
						color.rgb = MixFog(color.rgb, inputData.fogCoord);
					#endif
				#endif

				#if defined( ASE_DEPTH_WRITE_ON )
					outputDepth = input.positionCS.z;
				#endif

				#ifdef _WRITE_RENDERING_LAYERS
					uint renderingLayers = GetMeshRenderingLayer();
					outRenderingLayers = float4( EncodeMeshRenderingLayer( renderingLayers ), 0, 0, 0 );
				#endif

				#if defined( ASE_OPAQUE_KEEP_ALPHA )
					return half4( color.rgb, color.a );
				#else
					return half4( color.rgb, OutputAlpha( color.a, isTransparent ) );
				#endif
			}
			ENDHLSL
		}

		
		Pass
		{
			
			Name "ShadowCaster"
			Tags { "LightMode"="ShadowCaster" }

			ZWrite On
			ZTest LEqual
			AlphaToMask Off
			ColorMask 0

			HLSLPROGRAM

			#define _SPECULAR_SETUP 1
			#define _NORMAL_DROPOFF_TS 1
			#define ASE_FOG 1
			#pragma multi_compile_fragment _ DEBUG_DISPLAY
			#define _SPECULARHIGHLIGHTS_OFF
			#define ASE_LIGHTING_SIMPLE
			#define ASE_TERRAIN
			#define ASE_VERSION 19908
			#define ASE_SRP_VERSION 170100


			#pragma multi_compile_vertex _ _CASTING_PUNCTUAL_LIGHT_SHADOW

			#pragma vertex vert
			#pragma fragment frag

			#if defined( _SPECULAR_SETUP ) && defined( ASE_LIGHTING_SIMPLE )
				#if defined( _SPECULARHIGHLIGHTS_OFF )
					#undef _SPECULAR_COLOR
				#else
					#define _SPECULAR_COLOR
				#endif
			#endif

			#define SHADERPASS SHADERPASS_SHADOWCASTER

			#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
            #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			#if defined(LOD_FADE_CROSSFADE)
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/LODCrossFade.hlsl"
            #endif

			#define ASE_INSTANCED_TERRAIN
			#define ASE_NEEDS_VERT_POSITION
			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_TEXTURE_COORDINATES0
			#pragma multi_compile_instancing
			#pragma instancing_options assumeuniformscaling nomatrices nolightprobe nolightmap
			#define TERRAIN_SPLAT_FIRSTPASS 1
			#pragma editor_sync_compilation
			#pragma multi_compile_local __ _ALPHATEST_ON
			#pragma shader_feature_local _MASKMAP


			#if defined(ASE_EARLY_Z_DEPTH_OPTIMIZE) && (SHADER_TARGET >= 45)
				#define ASE_SV_DEPTH SV_DepthLessEqual
				#define ASE_SV_POSITION_QUALIFIERS linear noperspective centroid
			#else
				#define ASE_SV_DEPTH SV_Depth
				#define ASE_SV_POSITION_QUALIFIERS
			#endif

			struct Attributes
			{
				float4 positionOS : POSITION;
				half3 normalOS : NORMAL;
				half4 tangentOS : TANGENT;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct PackedVaryings
			{
				ASE_SV_POSITION_QUALIFIERS float4 positionCS : SV_POSITION;
				float3 positionWS : TEXCOORD0;
				float4 ase_texcoord1 : TEXCOORD1;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _Splat0_ST;
			float4 _TerrainHolesTexture_ST;
			float4 _BaseTint;
			float4 _Splat3_ST;
			float4 _SpecularTint1;
			float4 _Splat1_ST;
			float4 _Control_ST;
			float4 _Splat2_ST;
			float _NormalScale;
			float _SpecularOcclusion;
			float _IndirectSpecularContribution1;
			float _RampOffset;
			float _SpecularIntensity;
			float _SpecularSize1;
			float _SpecularSmoothness1;
			float _RampScale;
			float _Occlusion1;
			float _AlphaClip;
			float _Cutoff;
			#ifdef ASE_TRANSMISSION
				float _TransmissionShadow;
			#endif
			#ifdef ASE_TRANSLUCENCY
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
			#ifdef ASE_TESSELLATION
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END

			#ifdef SCENEPICKINGPASS
				float4 _SelectionID;
			#endif

			#ifdef SCENESELECTIONPASS
				int _ObjectId;
				int _PassValue;
			#endif

			#ifdef UNITY_INSTANCING_ENABLED//ASE Terrain Instancing
				TEXTURE2D(_TerrainHeightmapTexture);//ASE Terrain Instancing
				TEXTURE2D( _TerrainNormalmapTexture);//ASE Terrain Instancing
				SAMPLER(sampler_TerrainNormalmapTexture);//ASE Terrain Instancing
			#endif//ASE Terrain Instancing
			UNITY_INSTANCING_BUFFER_START( Terrain )//ASE Terrain Instancing
				UNITY_DEFINE_INSTANCED_PROP( float4, _TerrainPatchInstanceData )//ASE Terrain Instancing
			UNITY_INSTANCING_BUFFER_END( Terrain)//ASE Terrain Instancing
			CBUFFER_START( UnityTerrain)//ASE Terrain Instancing
				#ifdef UNITY_INSTANCING_ENABLED//ASE Terrain Instancing
					float4 _TerrainHeightmapRecipSize;//ASE Terrain Instancing
					float4 _TerrainHeightmapScale;//ASE Terrain Instancing
				#endif//ASE Terrain Instancing
			CBUFFER_END//ASE Terrain Instancing


			float3 _LightDirection;
			float3 _LightPosition;

			void TerrainApplyMeshModification( inout float3 position, inout half3 normal, inout float4 texcoord )
			{
			#ifdef UNITY_INSTANCING_ENABLED
				float2 patchVertex = position.xy;
				float4 instanceData = UNITY_ACCESS_INSTANCED_PROP( Terrain, _TerrainPatchInstanceData );
				float2 sampleCoords = ( patchVertex.xy + instanceData.xy ) * instanceData.z;
				float height = UnpackHeightmap( _TerrainHeightmapTexture.Load( int3( sampleCoords, 0 ) ) );
				position.xz = sampleCoords* _TerrainHeightmapScale.xz;
				position.y = height* _TerrainHeightmapScale.y;
				#ifdef ENABLE_TERRAIN_PERPIXEL_NORMAL
					normal = float3(0, 1, 0);
				#else
					normal = _TerrainNormalmapTexture.Load(int3(sampleCoords, 0)).rgb* 2 - 1;
				#endif
				texcoord.xy = sampleCoords* _TerrainHeightmapRecipSize.zw;
			#endif
			}
			

			PackedVaryings VertexFunction( Attributes input )
			{
				PackedVaryings output;
				UNITY_SETUP_INSTANCE_ID(input);
				UNITY_TRANSFER_INSTANCE_ID(input, output);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( output );

				#if defined( ASE_INSTANCED_TERRAIN ) && !defined( ASE_TESSELLATION )
					TerrainApplyMeshModification( input.positionOS.xyz, input.normalOS, input.ase_texcoord );
				#endif
				
				output.ase_texcoord1 = input.ase_texcoord;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = input.positionOS.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = defaultVertexValue;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					input.positionOS.xyz = vertexValue;
				#else
					input.positionOS.xyz += vertexValue;
				#endif

				input.normalOS = input.normalOS;
				input.tangentOS = input.tangentOS;

				float3 positionWS = TransformObjectToWorld( input.positionOS.xyz );
				float3 normalWS = TransformObjectToWorldDir(input.normalOS);

				#if _CASTING_PUNCTUAL_LIGHT_SHADOW
					float3 lightDirectionWS = normalize(_LightPosition - positionWS);
				#else
					float3 lightDirectionWS = _LightDirection;
				#endif

				float4 positionCS = TransformWorldToHClip(ApplyShadowBias(positionWS, normalWS, lightDirectionWS));

				//code for UNITY_REVERSED_Z is moved into Shadows.hlsl from 6000.0.22 and or higher
				positionCS = ApplyShadowClamping(positionCS);

				output.positionCS = positionCS;
				output.positionWS = positionWS;
				return output;
			}

			#if defined(ASE_TESSELLATION)
			struct VertexControl
			{
				float4 positionOS : INTERNALTESSPOS;
				half3 normalOS : NORMAL;
				half4 tangentOS : TANGENT;
				float4 ase_texcoord : TEXCOORD0;

				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( Attributes input )
			{
				VertexControl output;
				UNITY_SETUP_INSTANCE_ID(input);
				UNITY_TRANSFER_INSTANCE_ID(input, output);
				output.positionOS = input.positionOS;
				output.normalOS = input.normalOS;
				output.tangentOS = input.tangentOS;
				output.ase_texcoord = input.ase_texcoord;
				#if defined( ASE_INSTANCED_TERRAIN )
					TerrainApplyMeshModification( output.positionOS.xyz, output.normalOS, output.ase_texcoord );
				#endif
				
				return output;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> input)
			{
				TessellationFactors output;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(input[0].positionOS, input[1].positionOS, input[2].positionOS, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(input[0].positionOS, input[1].positionOS, input[2].positionOS, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(input[0].positionOS, input[1].positionOS, input[2].positionOS, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				output.edge[0] = tf.x; output.edge[1] = tf.y; output.edge[2] = tf.z; output.inside = tf.w;
				return output;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
				return patch[id];
			}

			[domain("tri")]
			PackedVaryings DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				Attributes output = (Attributes) 0;
				output.positionOS = patch[0].positionOS * bary.x + patch[1].positionOS * bary.y + patch[2].positionOS * bary.z;
				output.normalOS = patch[0].normalOS * bary.x + patch[1].normalOS * bary.y + patch[2].normalOS * bary.z;
				output.tangentOS = patch[0].tangentOS * bary.x + patch[1].tangentOS * bary.y + patch[2].tangentOS * bary.z;
				output.ase_texcoord = patch[0].ase_texcoord * bary.x + patch[1].ase_texcoord * bary.y + patch[2].ase_texcoord * bary.z;
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = output.positionOS.xyz - patch[i].normalOS * (dot(output.positionOS.xyz, patch[i].normalOS) - dot(patch[i].positionOS.xyz, patch[i].normalOS));
				float phongStrength = _TessPhongStrength;
				output.positionOS.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * output.positionOS.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], output);
				return VertexFunction(output);
			}
			#else
			PackedVaryings vert ( Attributes input )
			{
				return VertexFunction( input );
			}
			#endif

			half4 frag(	PackedVaryings input
						#if defined( ASE_DEPTH_WRITE_ON )
						,out float outputDepth : ASE_SV_DEPTH
						#endif
						 ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( input );
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( input );

				#if defined(MAIN_LIGHT_CALCULATE_SHADOWS) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					float4 shadowCoord = TransformWorldToShadowCoord(input.positionWS);
				#else
					float4 shadowCoord = float4(0, 0, 0, 0);
				#endif

				float3 PositionWS = input.positionWS;
				float3 PositionRWS = GetCameraRelativePositionWS( input.positionWS );
				float4 ShadowCoord = shadowCoord;
				float4 ScreenPosNorm = float4( GetNormalizedScreenSpaceUV( input.positionCS ), input.positionCS.zw );
				float4 ClipPos = ComputeClipSpacePosition( ScreenPosNorm.xy, input.positionCS.z ) * input.positionCS.w;
				float4 ScreenPos = ComputeScreenPos( ClipPos );

				

				float Alpha = 1;
				#if defined( _ALPHATEST_ON )
					float AlphaClipThreshold = _Cutoff;
					float AlphaClipThresholdShadow = 0.5;
				#endif

				#if defined( ASE_DEPTH_WRITE_ON )
					input.positionCS.z = input.positionCS.z;
				#endif

				#if defined( _ALPHATEST_ON )
					#if defined( _ALPHATEST_SHADOW_ON )
						AlphaDiscard( Alpha, AlphaClipThresholdShadow );
					#else
						AlphaDiscard( Alpha, AlphaClipThreshold );
					#endif
				#endif

				#if defined(LOD_FADE_CROSSFADE)
					LODFadeCrossFade( input.positionCS );
				#endif

				#if defined( ASE_DEPTH_WRITE_ON )
					outputDepth = input.positionCS.z;
				#endif

				return 0;
			}
			ENDHLSL
		}

		
		Pass
		{
			
			Name "DepthOnly"
			Tags { "LightMode"="DepthOnly" }

			ZWrite On
			ColorMask R
			AlphaToMask Off

			HLSLPROGRAM

			#define _SPECULAR_SETUP 1
			#define _NORMAL_DROPOFF_TS 1
			#define ASE_FOG 1
			#pragma multi_compile_fragment _ DEBUG_DISPLAY
			#define _SPECULARHIGHLIGHTS_OFF
			#define ASE_LIGHTING_SIMPLE
			#define ASE_TERRAIN
			#define ASE_VERSION 19908
			#define ASE_SRP_VERSION 170100


			#pragma vertex vert
			#pragma fragment frag

			#if defined( _SPECULAR_SETUP ) && defined( ASE_LIGHTING_SIMPLE )
				#if defined( _SPECULARHIGHLIGHTS_OFF )
					#undef _SPECULAR_COLOR
				#else
					#define _SPECULAR_COLOR
				#endif
			#endif

			#define SHADERPASS SHADERPASS_DEPTHONLY

			#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
            #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			#if defined(LOD_FADE_CROSSFADE)
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/LODCrossFade.hlsl"
            #endif

			#define ASE_INSTANCED_TERRAIN
			#define ASE_NEEDS_VERT_POSITION
			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_TEXTURE_COORDINATES0
			#pragma multi_compile_instancing
			#pragma instancing_options assumeuniformscaling nomatrices nolightprobe nolightmap
			#define TERRAIN_SPLAT_FIRSTPASS 1
			#pragma editor_sync_compilation
			#pragma multi_compile_local __ _ALPHATEST_ON
			#pragma shader_feature_local _MASKMAP


			#if defined(ASE_EARLY_Z_DEPTH_OPTIMIZE) && (SHADER_TARGET >= 45)
				#define ASE_SV_DEPTH SV_DepthLessEqual
				#define ASE_SV_POSITION_QUALIFIERS linear noperspective centroid
			#else
				#define ASE_SV_DEPTH SV_Depth
				#define ASE_SV_POSITION_QUALIFIERS
			#endif

			struct Attributes
			{
				float4 positionOS : POSITION;
				half3 normalOS : NORMAL;
				half4 tangentOS : TANGENT;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct PackedVaryings
			{
				ASE_SV_POSITION_QUALIFIERS float4 positionCS : SV_POSITION;
				float3 positionWS : TEXCOORD0;
				float4 ase_texcoord1 : TEXCOORD1;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _Splat0_ST;
			float4 _TerrainHolesTexture_ST;
			float4 _BaseTint;
			float4 _Splat3_ST;
			float4 _SpecularTint1;
			float4 _Splat1_ST;
			float4 _Control_ST;
			float4 _Splat2_ST;
			float _NormalScale;
			float _SpecularOcclusion;
			float _IndirectSpecularContribution1;
			float _RampOffset;
			float _SpecularIntensity;
			float _SpecularSize1;
			float _SpecularSmoothness1;
			float _RampScale;
			float _Occlusion1;
			float _AlphaClip;
			float _Cutoff;
			#ifdef ASE_TRANSMISSION
				float _TransmissionShadow;
			#endif
			#ifdef ASE_TRANSLUCENCY
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
			#ifdef ASE_TESSELLATION
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END

			#ifdef SCENEPICKINGPASS
				float4 _SelectionID;
			#endif

			#ifdef SCENESELECTIONPASS
				int _ObjectId;
				int _PassValue;
			#endif

			#ifdef UNITY_INSTANCING_ENABLED//ASE Terrain Instancing
				TEXTURE2D(_TerrainHeightmapTexture);//ASE Terrain Instancing
				TEXTURE2D( _TerrainNormalmapTexture);//ASE Terrain Instancing
				SAMPLER(sampler_TerrainNormalmapTexture);//ASE Terrain Instancing
			#endif//ASE Terrain Instancing
			UNITY_INSTANCING_BUFFER_START( Terrain )//ASE Terrain Instancing
				UNITY_DEFINE_INSTANCED_PROP( float4, _TerrainPatchInstanceData )//ASE Terrain Instancing
			UNITY_INSTANCING_BUFFER_END( Terrain)//ASE Terrain Instancing
			CBUFFER_START( UnityTerrain)//ASE Terrain Instancing
				#ifdef UNITY_INSTANCING_ENABLED//ASE Terrain Instancing
					float4 _TerrainHeightmapRecipSize;//ASE Terrain Instancing
					float4 _TerrainHeightmapScale;//ASE Terrain Instancing
				#endif//ASE Terrain Instancing
			CBUFFER_END//ASE Terrain Instancing


			void TerrainApplyMeshModification( inout float3 position, inout half3 normal, inout float4 texcoord )
			{
			#ifdef UNITY_INSTANCING_ENABLED
				float2 patchVertex = position.xy;
				float4 instanceData = UNITY_ACCESS_INSTANCED_PROP( Terrain, _TerrainPatchInstanceData );
				float2 sampleCoords = ( patchVertex.xy + instanceData.xy ) * instanceData.z;
				float height = UnpackHeightmap( _TerrainHeightmapTexture.Load( int3( sampleCoords, 0 ) ) );
				position.xz = sampleCoords* _TerrainHeightmapScale.xz;
				position.y = height* _TerrainHeightmapScale.y;
				#ifdef ENABLE_TERRAIN_PERPIXEL_NORMAL
					normal = float3(0, 1, 0);
				#else
					normal = _TerrainNormalmapTexture.Load(int3(sampleCoords, 0)).rgb* 2 - 1;
				#endif
				texcoord.xy = sampleCoords* _TerrainHeightmapRecipSize.zw;
			#endif
			}
			

			PackedVaryings VertexFunction( Attributes input  )
			{
				PackedVaryings output = (PackedVaryings)0;
				UNITY_SETUP_INSTANCE_ID(input);
				UNITY_TRANSFER_INSTANCE_ID(input, output);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(output);

				#if defined( ASE_INSTANCED_TERRAIN ) && !defined( ASE_TESSELLATION )
					TerrainApplyMeshModification( input.positionOS.xyz, input.normalOS, input.ase_texcoord );
				#endif
				
				output.ase_texcoord1 = input.ase_texcoord;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = input.positionOS.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = defaultVertexValue;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					input.positionOS.xyz = vertexValue;
				#else
					input.positionOS.xyz += vertexValue;
				#endif

				input.normalOS = input.normalOS;
				input.tangentOS = input.tangentOS;

				VertexPositionInputs vertexInput = GetVertexPositionInputs( input.positionOS.xyz );

				output.positionCS = vertexInput.positionCS;
				output.positionWS = vertexInput.positionWS;
				return output;
			}

			#if defined(ASE_TESSELLATION)
			struct VertexControl
			{
				float4 positionOS : INTERNALTESSPOS;
				half3 normalOS : NORMAL;
				half4 tangentOS : TANGENT;
				float4 ase_texcoord : TEXCOORD0;

				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( Attributes input )
			{
				VertexControl output;
				UNITY_SETUP_INSTANCE_ID(input);
				UNITY_TRANSFER_INSTANCE_ID(input, output);
				output.positionOS = input.positionOS;
				output.normalOS = input.normalOS;
				output.tangentOS = input.tangentOS;
				output.ase_texcoord = input.ase_texcoord;
				#if defined( ASE_INSTANCED_TERRAIN )
					TerrainApplyMeshModification( output.positionOS.xyz, output.normalOS, output.ase_texcoord );
				#endif
				
				return output;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> input)
			{
				TessellationFactors output;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(input[0].positionOS, input[1].positionOS, input[2].positionOS, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(input[0].positionOS, input[1].positionOS, input[2].positionOS, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(input[0].positionOS, input[1].positionOS, input[2].positionOS, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				output.edge[0] = tf.x; output.edge[1] = tf.y; output.edge[2] = tf.z; output.inside = tf.w;
				return output;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
				return patch[id];
			}

			[domain("tri")]
			PackedVaryings DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				Attributes output = (Attributes) 0;
				output.positionOS = patch[0].positionOS * bary.x + patch[1].positionOS * bary.y + patch[2].positionOS * bary.z;
				output.normalOS = patch[0].normalOS * bary.x + patch[1].normalOS * bary.y + patch[2].normalOS * bary.z;
				output.tangentOS = patch[0].tangentOS * bary.x + patch[1].tangentOS * bary.y + patch[2].tangentOS * bary.z;
				output.ase_texcoord = patch[0].ase_texcoord * bary.x + patch[1].ase_texcoord * bary.y + patch[2].ase_texcoord * bary.z;
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = output.positionOS.xyz - patch[i].normalOS * (dot(output.positionOS.xyz, patch[i].normalOS) - dot(patch[i].positionOS.xyz, patch[i].normalOS));
				float phongStrength = _TessPhongStrength;
				output.positionOS.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * output.positionOS.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], output);
				return VertexFunction(output);
			}
			#else
			PackedVaryings vert ( Attributes input )
			{
				return VertexFunction( input );
			}
			#endif

			half4 frag(	PackedVaryings input
						#if defined( ASE_DEPTH_WRITE_ON )
						,out float outputDepth : ASE_SV_DEPTH
						#endif
						 ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(input);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( input );

				#if defined(MAIN_LIGHT_CALCULATE_SHADOWS) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					float4 shadowCoord = TransformWorldToShadowCoord(input.positionWS);
				#else
					float4 shadowCoord = float4(0, 0, 0, 0);
				#endif

				float3 PositionWS = input.positionWS;
				float3 PositionRWS = GetCameraRelativePositionWS( input.positionWS );
				float4 ShadowCoord = shadowCoord;
				float4 ScreenPosNorm = float4( GetNormalizedScreenSpaceUV( input.positionCS ), input.positionCS.zw );
				float4 ClipPos = ComputeClipSpacePosition( ScreenPosNorm.xy, input.positionCS.z ) * input.positionCS.w;
				float4 ScreenPos = ComputeScreenPos( ClipPos );

				

				float Alpha = 1;
				float AlphaClipThreshold = _Cutoff;

				#if defined( ASE_DEPTH_WRITE_ON )
					input.positionCS.z = input.positionCS.z;
				#endif

				#if defined( _ALPHATEST_ON )
					AlphaDiscard( Alpha, AlphaClipThreshold );
				#endif

				#if defined(LOD_FADE_CROSSFADE)
					LODFadeCrossFade( input.positionCS );
				#endif

				#if defined( ASE_DEPTH_WRITE_ON )
					outputDepth = input.positionCS.z;
				#endif

				return 0;
			}
			ENDHLSL
		}

		
		Pass
		{
			
			Name "Meta"
			Tags { "LightMode"="Meta" }

			Cull Off

			HLSLPROGRAM
			#define _SPECULAR_SETUP 1
			#define _NORMAL_DROPOFF_TS 1
			#define ASE_FOG 1
			#pragma multi_compile_fragment _ DEBUG_DISPLAY
			#define _SPECULARHIGHLIGHTS_OFF
			#define ASE_LIGHTING_SIMPLE
			#define ASE_TERRAIN
			#define ASE_VERSION 19908
			#define ASE_SRP_VERSION 170100

			#pragma shader_feature EDITOR_VISUALIZATION

			#pragma vertex vert
			#pragma fragment frag

			#if defined( _SPECULAR_SETUP ) && defined( ASE_LIGHTING_SIMPLE )
				#if defined( _SPECULARHIGHLIGHTS_OFF )
					#undef _SPECULAR_COLOR
				#else
					#define _SPECULAR_COLOR
				#endif
			#endif

			#define SHADERPASS SHADERPASS_META

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
            #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/MetaInput.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			#define ASE_NEEDS_WORLD_POSITION
			#define ASE_NEEDS_FRAG_WORLD_POSITION
			#define ASE_NEEDS_TEXTURE_COORDINATES0
			#define ASE_NEEDS_VERT_TEXTURE_COORDINATES0
			#define ASE_NEEDS_FRAG_TEXTURE_COORDINATES0
			#define ASE_NEEDS_VERT_TANGENT
			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_FRAG_SHADOWCOORDS
			#define ASE_NEEDS_VERT_TEXTURE_COORDINATES1
			#define ASE_NEEDS_VERT_TEXTURE_COORDINATES2
			#define ASE_INSTANCED_TERRAIN
			#define ASE_NEEDS_VERT_POSITION
			#pragma shader_feature_local _ENABLESPECULARHIGHLIGHTS_ON
			#pragma multi_compile _ _CLUSTER_LIGHT_LOOP
			#pragma multi_compile_fragment _ _REFLECTION_PROBE_ATLAS
			#pragma multi_compile _ LIGHTMAP_ON
			#pragma multi_compile _ DIRLIGHTMAP_COMBINED
			#pragma multi_compile _ _MIXED_LIGHTING_SUBTRACTIVE
			#pragma multi_compile _ LIGHTMAP_BICUBIC_SAMPLING
			#pragma multi_compile _ DYNAMICLIGHTMAP_ON
			#pragma shader_feature_local _ENABLECOLORTINT_ON
			#pragma multi_compile_instancing
			#pragma instancing_options assumeuniformscaling nomatrices nolightprobe nolightmap
			#define TERRAIN_SPLAT_FIRSTPASS 1
			#pragma editor_sync_compilation
			#pragma multi_compile_local __ _ALPHATEST_ON
			#pragma shader_feature_local _MASKMAP


			struct Attributes
			{
				float4 positionOS : POSITION;
				half3 normalOS : NORMAL;
				half4 tangentOS : TANGENT;
				float4 texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct PackedVaryings
			{
				float4 positionCS : SV_POSITION;
				float3 positionWS : TEXCOORD0;
				#ifdef EDITOR_VISUALIZATION
					float4 VizUV : TEXCOORD1;
					float4 LightCoord : TEXCOORD2;
				#endif
				float4 ase_texcoord3 : TEXCOORD3;
				float4 ase_texcoord4 : TEXCOORD4;
				float4 ase_texcoord5 : TEXCOORD5;
				float4 ase_texcoord6 : TEXCOORD6;
				float4 ase_texcoord7 : TEXCOORD7;
				float4 lightmapUVOrVertexSH : TEXCOORD8;
				float4 dynamicLightmapUV : TEXCOORD9;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _Splat0_ST;
			float4 _TerrainHolesTexture_ST;
			float4 _BaseTint;
			float4 _Splat3_ST;
			float4 _SpecularTint1;
			float4 _Splat1_ST;
			float4 _Control_ST;
			float4 _Splat2_ST;
			float _NormalScale;
			float _SpecularOcclusion;
			float _IndirectSpecularContribution1;
			float _RampOffset;
			float _SpecularIntensity;
			float _SpecularSize1;
			float _SpecularSmoothness1;
			float _RampScale;
			float _Occlusion1;
			float _AlphaClip;
			float _Cutoff;
			#ifdef ASE_TRANSMISSION
				float _TransmissionShadow;
			#endif
			#ifdef ASE_TRANSLUCENCY
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
			#ifdef ASE_TESSELLATION
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END

			#ifdef SCENEPICKINGPASS
				float4 _SelectionID;
			#endif

			#ifdef SCENESELECTIONPASS
				int _ObjectId;
				int _PassValue;
			#endif

			sampler2D _Normal0;
			sampler2D _Splat0;
			sampler2D _Control;
			sampler2D _Normal1;
			sampler2D _Splat1;
			sampler2D _Normal2;
			sampler2D _Splat2;
			sampler2D _Normal3;
			sampler2D _Splat3;
			sampler2D _TerrainHolesTexture;
			sampler2D _TextureRamp3;
			#ifdef UNITY_INSTANCING_ENABLED//ASE Terrain Instancing
				TEXTURE2D(_TerrainHeightmapTexture);//ASE Terrain Instancing
				TEXTURE2D( _TerrainNormalmapTexture);//ASE Terrain Instancing
				SAMPLER(sampler_TerrainNormalmapTexture);//ASE Terrain Instancing
			#endif//ASE Terrain Instancing
			UNITY_INSTANCING_BUFFER_START( Terrain )//ASE Terrain Instancing
				UNITY_DEFINE_INSTANCED_PROP( float4, _TerrainPatchInstanceData )//ASE Terrain Instancing
			UNITY_INSTANCING_BUFFER_END( Terrain)//ASE Terrain Instancing
			CBUFFER_START( UnityTerrain)//ASE Terrain Instancing
				#ifdef UNITY_INSTANCING_ENABLED//ASE Terrain Instancing
					float4 _TerrainHeightmapRecipSize;//ASE Terrain Instancing
					float4 _TerrainHeightmapScale;//ASE Terrain Instancing
				#endif//ASE Terrain Instancing
			CBUFFER_END//ASE Terrain Instancing


			half4 CalculateShadowMask343_g61170(  )
			{
				#if defined(SHADOWS_SHADOWMASK) && defined(LIGHTMAP_ON)
				half4 shadowMask = inputData.shadowMask;
				#elif !defined (LIGHTMAP_ON)
				half4 shadowMask = unity_ProbesOcclusion;
				#else
				half4 shadowMask = half4(1, 1, 1, 1);
				#endif
				return shadowMask;
			}
			
			float3 AdditionalLightsLambertMask171x( float3 WorldPosition, float2 ScreenUV, float3 WorldNormal, float4 ShadowMask )
			{
				float3 Color = 0;
				#if defined(_ADDITIONAL_LIGHTS)
					#define SUM_LIGHTLAMBERT(Light)\
						half3 AttLightColor = Light.color * ( Light.distanceAttenuation * Light.shadowAttenuation );\
						Color += LightingLambert( AttLightColor, Light.direction, WorldNormal );
					InputData inputData = (InputData)0;
					inputData.normalizedScreenSpaceUV = ScreenUV;
					inputData.positionWS = WorldPosition;
					uint meshRenderingLayers = GetMeshRenderingLayer();
					uint pixelLightCount = GetAdditionalLightsCount();	
					#if USE_CLUSTER_LIGHT_LOOP
					[loop] for (uint lightIndex = 0; lightIndex < min(URP_FP_DIRECTIONAL_LIGHTS_COUNT, MAX_VISIBLE_LIGHTS); lightIndex++)
					{
						CLUSTER_LIGHT_LOOP_SUBTRACTIVE_LIGHT_CHECK
						Light light = GetAdditionalLight(lightIndex, WorldPosition, ShadowMask);
						#ifdef _LIGHT_LAYERS
						if (IsMatchingLightLayer(light.layerMask, meshRenderingLayers))
						#endif
						{
							SUM_LIGHTLAMBERT( light );
						}
					}
					#endif
					
					LIGHT_LOOP_BEGIN( pixelLightCount )
						Light light = GetAdditionalLight(lightIndex, WorldPosition, ShadowMask);
						#ifdef _LIGHT_LAYERS
						if (IsMatchingLightLayer(light.layerMask, meshRenderingLayers))
						#endif
						{
							SUM_LIGHTLAMBERT( light );
						}
					LIGHT_LOOP_END
				#endif
				return Color;
			}
			
			half3 ASEIndirectDiffuse( PackedVaryings input, half3 normalWS, float3 positionWS, half3 viewDirWS )
			{
			#if defined( DYNAMICLIGHTMAP_ON )
				return SAMPLE_GI( input.lightmapUVOrVertexSH.xy, input.dynamicLightmapUV.xy, 0, normalWS );
			#elif defined( LIGHTMAP_ON )
				return SAMPLE_GI( input.lightmapUVOrVertexSH.xy, 0, normalWS );
			#elif defined( PROBE_VOLUMES_L1 ) || defined( PROBE_VOLUMES_L2 )
				return SampleProbeVolumePixel( SampleSH( normalWS ), positionWS, normalWS, viewDirWS, input.positionCS.xy );
			#else
				return SampleSH( normalWS );
			#endif
			}
			
			half4 CalculateShadowMask343_g61167(  )
			{
				#if defined(SHADOWS_SHADOWMASK) && defined(LIGHTMAP_ON)
				half4 shadowMask = inputData.shadowMask;
				#elif !defined (LIGHTMAP_ON)
				half4 shadowMask = unity_ProbesOcclusion;
				#else
				half4 shadowMask = half4(1, 1, 1, 1);
				#endif
				return shadowMask;
			}
			
			void TerrainApplyMeshModification( inout float3 position, inout half3 normal, inout float4 texcoord )
			{
			#ifdef UNITY_INSTANCING_ENABLED
				float2 patchVertex = position.xy;
				float4 instanceData = UNITY_ACCESS_INSTANCED_PROP( Terrain, _TerrainPatchInstanceData );
				float2 sampleCoords = ( patchVertex.xy + instanceData.xy ) * instanceData.z;
				float height = UnpackHeightmap( _TerrainHeightmapTexture.Load( int3( sampleCoords, 0 ) ) );
				position.xz = sampleCoords* _TerrainHeightmapScale.xz;
				position.y = height* _TerrainHeightmapScale.y;
				#ifdef ENABLE_TERRAIN_PERPIXEL_NORMAL
					normal = float3(0, 1, 0);
				#else
					normal = _TerrainNormalmapTexture.Load(int3(sampleCoords, 0)).rgb* 2 - 1;
				#endif
				texcoord.xy = sampleCoords* _TerrainHeightmapRecipSize.zw;
			#endif
			}
			

			PackedVaryings VertexFunction( Attributes input  )
			{
				PackedVaryings output = (PackedVaryings)0;
				UNITY_SETUP_INSTANCE_ID(input);
				UNITY_TRANSFER_INSTANCE_ID(input, output);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(output);

				#if defined( ASE_INSTANCED_TERRAIN ) && !defined( ASE_TESSELLATION )
					TerrainApplyMeshModification( input.positionOS.xyz, input.normalOS, input.texcoord );
				#endif
				
				float2 break956_g61173 = _Control_ST.zw;
				float2 appendResult959_g61173 = (float2(( break956_g61173.x + 0.001 ) , ( break956_g61173.y + 0.0001 )));
				float2 vertexToFrag961_g61173 = ( ( input.texcoord.xy * _Control_ST.xy ) + appendResult959_g61173 );
				output.ase_texcoord3.zw = vertexToFrag961_g61173;
				float3 ase_tangentWS = TransformObjectToWorldDir( input.tangentOS.xyz );
				output.ase_texcoord4.xyz = ase_tangentWS;
				float3 ase_normalWS = TransformObjectToWorldNormal( input.normalOS );
				output.ase_texcoord5.xyz = ase_normalWS;
				float ase_tangentSign = input.tangentOS.w * ( unity_WorldTransformParams.w >= 0.0 ? 1.0 : -1.0 );
				float3 ase_bitangentWS = cross( ase_normalWS, ase_tangentWS ) * ase_tangentSign;
				output.ase_texcoord6.xyz = ase_bitangentWS;
				float4 ase_positionCS = TransformObjectToHClip( ( input.positionOS ).xyz );
				float4 screenPos = ComputeScreenPos( ase_positionCS );
				output.ase_texcoord7 = screenPos;
				OUTPUT_LIGHTMAP_UV( input.texcoord1, unity_LightmapST, output.lightmapUVOrVertexSH.xy );
				float3 ase_positionWS = TransformObjectToWorld( ( input.positionOS ).xyz );
				#if !defined( OUTPUT_SH4 )
				OUTPUT_SH( ase_positionWS, ase_normalWS, GetWorldSpaceNormalizeViewDir( ase_positionWS ), output.lightmapUVOrVertexSH.xyz );
				#elif UNITY_VERSION > 60000009
				OUTPUT_SH4( ase_positionWS, ase_normalWS, GetWorldSpaceNormalizeViewDir( ase_positionWS ), output.lightmapUVOrVertexSH.xyz, output.probeOcclusion );
				#else
				OUTPUT_SH4( ase_positionWS, ase_normalWS, GetWorldSpaceNormalizeViewDir( ase_positionWS ), output.lightmapUVOrVertexSH.xyz );
				#endif
				#if defined( DYNAMICLIGHTMAP_ON )
				output.dynamicLightmapUV.xy = input.texcoord2.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
				#endif
				
				output.ase_texcoord3.xy = input.texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				output.ase_texcoord4.w = 0;
				output.ase_texcoord5.w = 0;
				output.ase_texcoord6.w = 0;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = input.positionOS.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = defaultVertexValue;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					input.positionOS.xyz = vertexValue;
				#else
					input.positionOS.xyz += vertexValue;
				#endif

				input.normalOS = input.normalOS;
				input.tangentOS = input.tangentOS;

				#ifdef EDITOR_VISUALIZATION
					float2 VizUV = 0;
					float4 LightCoord = 0;
					UnityEditorVizData(input.positionOS.xyz, input.texcoord.xy, input.texcoord1.xy, input.texcoord2.xy, VizUV, LightCoord);
					output.VizUV = float4(VizUV, 0, 0);
					output.LightCoord = LightCoord;
				#endif

				output.positionCS = MetaVertexPosition( input.positionOS, input.texcoord1.xy, input.texcoord1.xy, unity_LightmapST, unity_DynamicLightmapST );
				output.positionWS = TransformObjectToWorld( input.positionOS.xyz );
				return output;
			}

			#if defined(ASE_TESSELLATION)
			struct VertexControl
			{
				float4 positionOS : INTERNALTESSPOS;
				half3 normalOS : NORMAL;
				half4 tangentOS : TANGENT;
				float4 texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( Attributes input )
			{
				VertexControl output;
				UNITY_SETUP_INSTANCE_ID(input);
				UNITY_TRANSFER_INSTANCE_ID(input, output);
				output.positionOS = input.positionOS;
				output.normalOS = input.normalOS;
				output.tangentOS = input.tangentOS;
				output.texcoord = input.texcoord;
				output.texcoord1 = input.texcoord1;
				output.texcoord2 = input.texcoord2;
				#if defined( ASE_INSTANCED_TERRAIN )
					TerrainApplyMeshModification( output.positionOS.xyz, output.normalOS, output.texcoord );
				#endif
				
				return output;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> input)
			{
				TessellationFactors output;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(input[0].positionOS, input[1].positionOS, input[2].positionOS, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(input[0].positionOS, input[1].positionOS, input[2].positionOS, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(input[0].positionOS, input[1].positionOS, input[2].positionOS, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				output.edge[0] = tf.x; output.edge[1] = tf.y; output.edge[2] = tf.z; output.inside = tf.w;
				return output;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
				return patch[id];
			}

			[domain("tri")]
			PackedVaryings DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				Attributes output = (Attributes) 0;
				output.positionOS = patch[0].positionOS * bary.x + patch[1].positionOS * bary.y + patch[2].positionOS * bary.z;
				output.normalOS = patch[0].normalOS * bary.x + patch[1].normalOS * bary.y + patch[2].normalOS * bary.z;
				output.tangentOS = patch[0].tangentOS * bary.x + patch[1].tangentOS * bary.y + patch[2].tangentOS * bary.z;
				output.texcoord = patch[0].texcoord * bary.x + patch[1].texcoord * bary.y + patch[2].texcoord * bary.z;
				output.texcoord1 = patch[0].texcoord1 * bary.x + patch[1].texcoord1 * bary.y + patch[2].texcoord1 * bary.z;
				output.texcoord2 = patch[0].texcoord2 * bary.x + patch[1].texcoord2 * bary.y + patch[2].texcoord2 * bary.z;
				
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = output.positionOS.xyz - patch[i].normalOS * (dot(output.positionOS.xyz, patch[i].normalOS) - dot(patch[i].positionOS.xyz, patch[i].normalOS));
				float phongStrength = _TessPhongStrength;
				output.positionOS.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * output.positionOS.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], output);
				return VertexFunction(output);
			}
			#else
			PackedVaryings vert ( Attributes input )
			{
				return VertexFunction( input );
			}
			#endif

			half4 frag(PackedVaryings input  ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(input);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( input );

				#if defined(MAIN_LIGHT_CALCULATE_SHADOWS) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					float4 shadowCoord = TransformWorldToShadowCoord(input.positionWS);
				#else
					float4 shadowCoord = float4(0, 0, 0, 0);
				#endif

				float3 PositionWS = input.positionWS;
				float3 PositionRWS = GetCameraRelativePositionWS( input.positionWS );
				float4 ShadowCoord = shadowCoord;

				float3 temp_cast_0 = (1.0).xxx;
				float3 ase_viewVectorWS = ( ( unity_OrthoParams.w == 0 ) ? _WorldSpaceCameraPos - PositionWS : UNITY_MATRIX_V[ 2 ].xyz );
				float3 ase_viewDirWS = normalize( ase_viewVectorWS );
				float4 ControlFinal724_g61173 = float4( 1, 1, 1, 1 );
				float2 uv_Splat0 = input.ase_texcoord3.xy * _Splat0_ST.xy + _Splat0_ST.zw;
				float4 tex2DNode2_g61173 = tex2D( _Normal0, uv_Splat0 );
				float _HeightA279_g61173 = tex2DNode2_g61173.a;
				float smoothstepResult810_g61173 = smoothstep( 0.0 , 1.0 , _HeightA279_g61173);
				float clampResult933_g61173 = clamp( smoothstepResult810_g61173 , 0.001 , 0.999 );
				float2 vertexToFrag961_g61173 = input.ase_texcoord3.zw;
				float4 tex2DNode5_g61173 = tex2D( _Control, vertexToFrag961_g61173 );
				float _MaskA481_g61173 = tex2DNode5_g61173.r;
				float clampResult830_g61173 = clamp( _MaskA481_g61173 , 0.0 , 1.0 );
				float temp_output_829_0_g61173 = ( clampResult933_g61173 * clampResult830_g61173 );
				float3 break635_g61173 = tex2DNode2_g61173.rgb;
				float2 appendResult655_g61173 = (float2(( ( break635_g61173.x * 2.0 ) - 1.0 ) , ( ( break635_g61173.y * 2.0 ) - 1.0 )));
				float3 appendResult656_g61173 = (float3(appendResult655_g61173 , sqrt( max( 0.0, ( 1.0 - ( ( break635_g61173.x * break635_g61173.x ) + ( break635_g61173.y * break635_g61173.y ) ) ) ) )));
				float3 _UnpackedNormalA720_g61173 = appendResult656_g61173;
				float2 uv_Splat1 = input.ase_texcoord3.xy * _Splat1_ST.xy + _Splat1_ST.zw;
				float4 tex2DNode1_g61173 = tex2D( _Normal1, uv_Splat1 );
				float _HeightB280_g61173 = tex2DNode1_g61173.a;
				float smoothstepResult812_g61173 = smoothstep( 0.0 , 1.0 , _HeightB280_g61173);
				float clampResult934_g61173 = clamp( smoothstepResult812_g61173 , 0.001 , 0.999 );
				float _MaskB482_g61173 = tex2DNode5_g61173.g;
				float clampResult832_g61173 = clamp( _MaskB482_g61173 , 0.0 , 1.0 );
				float temp_output_826_0_g61173 = ( clampResult934_g61173 * clampResult832_g61173 );
				float3 break657_g61173 = tex2DNode1_g61173.rgb;
				float2 appendResult664_g61173 = (float2(( ( break657_g61173.x * 2.0 ) - 1.0 ) , ( ( break657_g61173.y * 2.0 ) - 1.0 )));
				float3 appendResult673_g61173 = (float3(appendResult664_g61173 , sqrt( max( 0.0, ( 1.0 - ( ( break657_g61173.x * break657_g61173.x ) + ( break657_g61173.y * break657_g61173.y ) ) ) ) )));
				float3 _UnpackedNormalB721_g61173 = appendResult673_g61173;
				float2 uv_Splat2 = input.ase_texcoord3.xy * _Splat2_ST.xy + _Splat2_ST.zw;
				float4 tex2DNode10_g61173 = tex2D( _Normal2, uv_Splat2 );
				float _HeightC281_g61173 = tex2DNode10_g61173.a;
				float smoothstepResult811_g61173 = smoothstep( 0.0 , 1.0 , _HeightC281_g61173);
				float clampResult935_g61173 = clamp( smoothstepResult811_g61173 , 0.001 , 0.999 );
				float _MaskC483_g61173 = tex2DNode5_g61173.b;
				float clampResult831_g61173 = clamp( _MaskC483_g61173 , 0.0 , 1.0 );
				float temp_output_827_0_g61173 = ( clampResult935_g61173 * clampResult831_g61173 );
				float3 break676_g61173 = tex2DNode10_g61173.rgb;
				float2 appendResult683_g61173 = (float2(( ( break676_g61173.x * 2.0 ) - 1.0 ) , ( ( break676_g61173.y * 2.0 ) - 1.0 )));
				float3 appendResult692_g61173 = (float3(appendResult683_g61173 , sqrt( max( 0.0, ( 1.0 - ( ( break676_g61173.x * break676_g61173.x ) + ( break676_g61173.y * break676_g61173.y ) ) ) ) )));
				float3 _UnpackedNormalC722_g61173 = appendResult692_g61173;
				float2 uv_Splat3 = input.ase_texcoord3.xy * _Splat3_ST.xy + _Splat3_ST.zw;
				float4 tex2DNode11_g61173 = tex2D( _Normal3, uv_Splat3 );
				float _HeightD282_g61173 = tex2DNode11_g61173.a;
				float smoothstepResult813_g61173 = smoothstep( 0.0 , 1.0 , _HeightD282_g61173);
				float clampResult936_g61173 = clamp( smoothstepResult813_g61173 , 0.001 , 0.999 );
				float _MaskD484_g61173 = tex2DNode5_g61173.a;
				float clampResult833_g61173 = clamp( _MaskD484_g61173 , 0.0 , 1.0 );
				float temp_output_828_0_g61173 = ( clampResult936_g61173 * clampResult833_g61173 );
				float3 break695_g61173 = tex2DNode11_g61173.rgb;
				float2 appendResult702_g61173 = (float2(( ( break695_g61173.x * 2.0 ) - 1.0 ) , ( ( break695_g61173.y * 2.0 ) - 1.0 )));
				float3 appendResult711_g61173 = (float3(appendResult702_g61173 , sqrt( max( 0.0, ( 1.0 - ( ( break695_g61173.x * break695_g61173.x ) + ( break695_g61173.y * break695_g61173.y ) ) ) ) )));
				float3 _UnpackedNormalD723_g61173 = appendResult711_g61173;
				float4 weightedBlendVar840_g61173 = ControlFinal724_g61173;
				float3 weightedBlend840_g61173 = ( weightedBlendVar840_g61173.x*( temp_output_829_0_g61173 * _UnpackedNormalA720_g61173 ) + weightedBlendVar840_g61173.y*( temp_output_826_0_g61173 * _UnpackedNormalB721_g61173 ) + weightedBlendVar840_g61173.z*( temp_output_827_0_g61173 * _UnpackedNormalC722_g61173 ) + weightedBlendVar840_g61173.w*( temp_output_828_0_g61173 * _UnpackedNormalD723_g61173 ) );
				float4 weightedBlendVar841_g61173 = ControlFinal724_g61173;
				float weightedBlend841_g61173 = ( weightedBlendVar841_g61173.x*temp_output_829_0_g61173 + weightedBlendVar841_g61173.y*temp_output_826_0_g61173 + weightedBlendVar841_g61173.z*temp_output_827_0_g61173 + weightedBlendVar841_g61173.w*temp_output_828_0_g61173 );
				float3 FinalNormal765_g61173 = ( weightedBlend840_g61173 / max( weightedBlend841_g61173, 0.001 ) );
				float3 temp_output_61_0_g61173 = FinalNormal765_g61173;
				float3 Normal554 = temp_output_61_0_g61173;
				float3 ase_tangentWS = input.ase_texcoord4.xyz;
				float3 ase_normalWS = input.ase_texcoord5.xyz;
				float3 ase_bitangentWS = input.ase_texcoord6.xyz;
				float3 tanToWorld0 = float3( ase_tangentWS.x, ase_bitangentWS.x, ase_normalWS.x );
				float3 tanToWorld1 = float3( ase_tangentWS.y, ase_bitangentWS.y, ase_normalWS.y );
				float3 tanToWorld2 = float3( ase_tangentWS.z, ase_bitangentWS.z, ase_normalWS.z );
				float3 tanNormal638 = ( Normal554 * _NormalScale );
				float3 worldNormal638 = normalize( float3( dot( tanToWorld0, tanNormal638 ), dot( tanToWorld1, tanNormal638 ), dot( tanToWorld2, tanNormal638 ) ) );
				float3 normalizeResult640 = normalize( worldNormal638 );
				float3 Normals780 = normalizeResult640;
				float smoothstepResult859_g61173 = smoothstep( 0.0 , 1.0 , _HeightA279_g61173);
				float clampResult937_g61173 = clamp( smoothstepResult859_g61173 , 0.001 , 0.999 );
				float clampResult879_g61173 = clamp( _MaskA481_g61173 , 0.0 , 1.0 );
				float temp_output_878_0_g61173 = ( clampResult937_g61173 * clampResult879_g61173 );
				float4 tex2DNode4_g61173 = tex2D( _Splat0, uv_Splat0 );
				float _LayerAlphaA778_g61173 = tex2DNode4_g61173.a;
				float smoothstepResult861_g61173 = smoothstep( 0.0 , 1.0 , _HeightB280_g61173);
				float clampResult938_g61173 = clamp( smoothstepResult861_g61173 , 0.001 , 0.999 );
				float clampResult881_g61173 = clamp( _MaskB482_g61173 , 0.0 , 1.0 );
				float temp_output_875_0_g61173 = ( clampResult938_g61173 * clampResult881_g61173 );
				float4 tex2DNode3_g61173 = tex2D( _Splat1, uv_Splat1 );
				float _LayerAlphaB779_g61173 = tex2DNode3_g61173.a;
				float smoothstepResult860_g61173 = smoothstep( 0.0 , 1.0 , _HeightC281_g61173);
				float clampResult939_g61173 = clamp( smoothstepResult860_g61173 , 0.001 , 0.999 );
				float clampResult880_g61173 = clamp( _MaskC483_g61173 , 0.0 , 1.0 );
				float temp_output_876_0_g61173 = ( clampResult939_g61173 * clampResult880_g61173 );
				float4 tex2DNode6_g61173 = tex2D( _Splat2, uv_Splat2 );
				float _LayerAlphaC780_g61173 = tex2DNode6_g61173.a;
				float smoothstepResult862_g61173 = smoothstep( 0.0 , 1.0 , _HeightD282_g61173);
				float clampResult940_g61173 = clamp( smoothstepResult862_g61173 , 0.001 , 0.999 );
				float clampResult882_g61173 = clamp( _MaskD484_g61173 , 0.0 , 1.0 );
				float temp_output_877_0_g61173 = ( clampResult940_g61173 * clampResult882_g61173 );
				float4 tex2DNode7_g61173 = tex2D( _Splat3, uv_Splat3 );
				float _LayerAlphaD781_g61173 = tex2DNode7_g61173.a;
				float4 weightedBlendVar887_g61173 = ControlFinal724_g61173;
				float weightedBlend887_g61173 = ( weightedBlendVar887_g61173.x*( temp_output_878_0_g61173 * _LayerAlphaA778_g61173 ) + weightedBlendVar887_g61173.y*( temp_output_875_0_g61173 * _LayerAlphaB779_g61173 ) + weightedBlendVar887_g61173.z*( temp_output_876_0_g61173 * _LayerAlphaC780_g61173 ) + weightedBlendVar887_g61173.w*( temp_output_877_0_g61173 * _LayerAlphaD781_g61173 ) );
				float4 weightedBlendVar888_g61173 = ControlFinal724_g61173;
				float weightedBlend888_g61173 = ( weightedBlendVar888_g61173.x*temp_output_878_0_g61173 + weightedBlendVar888_g61173.y*temp_output_875_0_g61173 + weightedBlendVar888_g61173.z*temp_output_876_0_g61173 + weightedBlendVar888_g61173.w*temp_output_877_0_g61173 );
				float FinalSmoothness897_g61173 = ( weightedBlend887_g61173 / max( weightedBlend888_g61173, 0.001 ) );
				float Smoothness533 = FinalSmoothness897_g61173;
				half3 reflectVector772 = reflect( -ase_viewDirWS, Normals780 );
				float4 screenPos = input.ase_texcoord7;
				float4 ase_positionSSNorm = screenPos / screenPos.w;
				ase_positionSSNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_positionSSNorm.z : ase_positionSSNorm.z * 0.5 + 0.5;
				float3 indirectSpecular772 = GlossyEnvironmentReflection( reflectVector772, PositionWS, 1.0 - Smoothness533, _SpecularOcclusion, ase_positionSSNorm.xy );
				float3 lerpResult643 = lerp( temp_cast_0 , indirectSpecular772 , _IndirectSpecularContribution1);
				float3 IndirectSpecHighlights793 = lerpResult643;
				float4 temp_output_751_0 = ( _SpecularTint1 * Smoothness533 * _SpecularIntensity );
				float3 normalizeResult4_g61169 = normalize( ( ase_viewDirWS + SafeNormalize( _MainLightPosition.xyz ) ) );
				float dotResult749 = dot( normalizeResult4_g61169 , Normals780 );
				float3 WorldPosition288_g61170 = PositionWS;
				float3 WorldPosition337_g61170 = WorldPosition288_g61170;
				float2 ScreenUV286_g61170 = (ase_positionSSNorm).xy;
				float2 ScreenUV337_g61170 = ScreenUV286_g61170;
				float3 WorldNormal281_g61170 = Normals780;
				float3 WorldNormal337_g61170 = WorldNormal281_g61170;
				half4 localCalculateShadowMask343_g61170 = CalculateShadowMask343_g61170();
				float4 ShadowMask360_g61170 = localCalculateShadowMask343_g61170;
				float4 ShadowMask337_g61170 = ShadowMask360_g61170;
				float3 localAdditionalLightsLambertMask171x337_g61170 = AdditionalLightsLambertMask171x( WorldPosition337_g61170 , ScreenUV337_g61170 , WorldNormal337_g61170 , ShadowMask337_g61170 );
				float4 DirectSpecHighlights764 = ( float4( (temp_output_751_0).rgb , 0.0 ) * saturate( ( float4( (  (-1.0 + ( _SpecularSize1 - 0.0 ) * ( -0.5 - -1.0 ) / ( 1.0 - 0.0 ) ) + ( dotResult749 + saturate( localAdditionalLightsLambertMask171x337_g61170 ) ) ) , 0.0 ) / ( ( 1.0 - temp_output_751_0 ) * _SpecularSmoothness1 ) ) ) );
				float ase_lightIntensity = max( max( _MainLightColor.r, _MainLightColor.g ), _MainLightColor.b ) + 1e-7;
				float4 ase_lightColor = float4( _MainLightColor.rgb / ase_lightIntensity, ase_lightIntensity );
				float ase_lightAtten = 0;
				Light ase_mainLight = GetMainLight( ShadowCoord );
				ase_lightAtten = ase_mainLight.distanceAttenuation * ase_mainLight.shadowAttenuation;
				float3 bakedGI730 = ASEIndirectDiffuse( input, ase_normalWS, PositionWS, ase_viewDirWS );
				MixRealtimeAndBakedGI( ase_mainLight, ase_normalWS, bakedGI730, half4( 0, 0, 0, 0 ) );
				float4 HalfLambert733 = ( ( ase_lightColor * ase_lightAtten ) + float4( bakedGI730 , 0.0 ) );
				float4 SpecularHighlights768 = ( float4( IndirectSpecHighlights793 , 0.0 ) * DirectSpecHighlights764 * HalfLambert733 );
				#ifdef _ENABLESPECULARHIGHLIGHTS_ON
				float4 staticSwitch763 = SpecularHighlights768;
				#else
				float4 staticSwitch763 = float4( 0,0,0,0 );
				#endif
				float4 color648 = IsGammaSpace() ? float4( 1, 1, 1, 1 ) : float4( 1, 1, 1, 1 );
				#ifdef _ENABLECOLORTINT_ON
				float4 staticSwitch774 = _BaseTint;
				#else
				float4 staticSwitch774 = color648;
				#endif
				float smoothstepResult591_g61173 = smoothstep( 0.0 , 1.0 , _HeightA279_g61173);
				float clampResult944_g61173 = clamp( smoothstepResult591_g61173 , 0.001 , 0.999 );
				float clampResult603_g61173 = clamp( _MaskA481_g61173 , 0.0 , 1.0 );
				float temp_output_597_0_g61173 = ( clampResult944_g61173 * clampResult603_g61173 );
				float4 _LayerA287_g61173 = tex2DNode4_g61173;
				float smoothstepResult594_g61173 = smoothstep( 0.0 , 1.0 , _HeightB280_g61173);
				float clampResult943_g61173 = clamp( smoothstepResult594_g61173 , 0.001 , 0.999 );
				float clampResult604_g61173 = clamp( _MaskB482_g61173 , 0.0 , 1.0 );
				float temp_output_598_0_g61173 = ( clampResult943_g61173 * clampResult604_g61173 );
				float4 _LayerB300_g61173 = tex2DNode3_g61173;
				float smoothstepResult595_g61173 = smoothstep( 0.0 , 1.0 , _HeightC281_g61173);
				float clampResult942_g61173 = clamp( smoothstepResult595_g61173 , 0.001 , 0.999 );
				float clampResult605_g61173 = clamp( _MaskC483_g61173 , 0.0 , 1.0 );
				float temp_output_599_0_g61173 = ( clampResult942_g61173 * clampResult605_g61173 );
				float4 _LayerC301_g61173 = tex2DNode6_g61173;
				float smoothstepResult596_g61173 = smoothstep( 0.0 , 1.0 , _HeightD282_g61173);
				float clampResult941_g61173 = clamp( smoothstepResult596_g61173 , 0.001 , 0.999 );
				float clampResult606_g61173 = clamp( _MaskD484_g61173 , 0.0 , 1.0 );
				float temp_output_600_0_g61173 = ( clampResult941_g61173 * clampResult606_g61173 );
				float4 _LayerD302_g61173 = tex2DNode7_g61173;
				float4 weightedBlendVar619_g61173 = ControlFinal724_g61173;
				float4 weightedBlend619_g61173 = ( weightedBlendVar619_g61173.x*( temp_output_597_0_g61173 * _LayerA287_g61173 ) + weightedBlendVar619_g61173.y*( temp_output_598_0_g61173 * _LayerB300_g61173 ) + weightedBlendVar619_g61173.z*( temp_output_599_0_g61173 * _LayerC301_g61173 ) + weightedBlendVar619_g61173.w*( temp_output_600_0_g61173 * _LayerD302_g61173 ) );
				float4 weightedBlendVar620_g61173 = ControlFinal724_g61173;
				float weightedBlend620_g61173 = ( weightedBlendVar620_g61173.x*temp_output_597_0_g61173 + weightedBlendVar620_g61173.y*temp_output_598_0_g61173 + weightedBlendVar620_g61173.z*temp_output_599_0_g61173 + weightedBlendVar620_g61173.w*temp_output_600_0_g61173 );
				float4 FinalAlbedo479_g61173 = ( weightedBlend619_g61173 / max( weightedBlend620_g61173, 0.001 ) );
				float4 temp_output_60_0_g61173 = FinalAlbedo479_g61173;
				float4 localClipHoles100_g61173 = ( temp_output_60_0_g61173 );
				float2 uv_TerrainHolesTexture = input.ase_texcoord3.xy * _TerrainHolesTexture_ST.xy + _TerrainHolesTexture_ST.zw;
				float holeClipValue99_g61173 = tex2D( _TerrainHolesTexture, uv_TerrainHolesTexture ).r;
				float Hole100_g61173 = holeClipValue99_g61173;
				{
				#ifdef _ALPHATEST_ON
				clip(Hole100_g61173 == 0.0f ? -1 : 1);
				#endif
				}
				float4 Albedo536 = localClipHoles100_g61173;
				float dotResult723 = dot( Normals780 , SafeNormalize( _MainLightPosition.xyz ) );
				float RampScale743 = _RampScale;
				float RampOffset742 = _RampOffset;
				float CEL_Effect664 = saturate( (dotResult723*RampScale743 + RampOffset742) );
				float2 temp_cast_6 = (CEL_Effect664).xx;
				float3 WorldPosition288_g61167 = PositionWS;
				float3 WorldPosition337_g61167 = WorldPosition288_g61167;
				float2 ScreenUV286_g61167 = (ase_positionSSNorm).xy;
				float2 ScreenUV337_g61167 = ScreenUV286_g61167;
				float3 WorldNormal281_g61167 = Normals780;
				float3 WorldNormal337_g61167 = WorldNormal281_g61167;
				half4 localCalculateShadowMask343_g61167 = CalculateShadowMask343_g61167();
				float4 ShadowMask360_g61167 = localCalculateShadowMask343_g61167;
				float4 ShadowMask337_g61167 = ShadowMask360_g61167;
				float3 localAdditionalLightsLambertMask171x337_g61167 = AdditionalLightsLambertMask171x( WorldPosition337_g61167 , ScreenUV337_g61167 , WorldNormal337_g61167 , ShadowMask337_g61167 );
				

				float3 BaseColor = ( staticSwitch763 + ( staticSwitch774 * ( ( ( Albedo536 * tex2D( _TextureRamp3, temp_cast_6 ) ) * HalfLambert733 ) + ( Albedo536 * tex2D( _TextureRamp3, (saturate( localAdditionalLightsLambertMask171x337_g61167 )*RampScale743 + RampOffset742).xy ) ) ) ) ).rgb;
				float3 Emission = 0;
				float Alpha = 1;
				#if defined( _ALPHATEST_ON )
					float AlphaClipThreshold = _Cutoff;
				#endif

				#if defined( _ALPHATEST_ON )
					AlphaDiscard( Alpha, AlphaClipThreshold );
				#endif

				MetaInput metaInput = (MetaInput)0;
				metaInput.Albedo = BaseColor;
				metaInput.Emission = Emission;
				#ifdef EDITOR_VISUALIZATION
					metaInput.VizUV = input.VizUV.xy;
					metaInput.LightCoord = input.LightCoord;
				#endif

				return UnityMetaFragment(metaInput);
			}
			ENDHLSL
		}

		
		Pass
		{
			
			Name "Universal2D"
			Tags { "LightMode"="Universal2D" }

			Blend One Zero
			ZWrite On
			ZTest LEqual
			Offset 0 , 0
			ColorMask RGBA

			HLSLPROGRAM

			#define _SPECULAR_SETUP 1
			#define _NORMAL_DROPOFF_TS 1
			#define ASE_FOG 1
			#pragma multi_compile_fragment _ DEBUG_DISPLAY
			#define _SPECULARHIGHLIGHTS_OFF
			#define ASE_LIGHTING_SIMPLE
			#define ASE_TERRAIN
			#define ASE_VERSION 19908
			#define ASE_SRP_VERSION 170100


			#pragma vertex vert
			#pragma fragment frag

			#if defined( _SPECULAR_SETUP ) && defined( ASE_LIGHTING_SIMPLE )
				#if defined( _SPECULARHIGHLIGHTS_OFF )
					#undef _SPECULAR_COLOR
				#else
					#define _SPECULAR_COLOR
				#endif
			#endif

			#define SHADERPASS SHADERPASS_2D

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
            #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			#define ASE_NEEDS_WORLD_POSITION
			#define ASE_NEEDS_FRAG_WORLD_POSITION
			#define ASE_NEEDS_TEXTURE_COORDINATES0
			#define ASE_NEEDS_VERT_TEXTURE_COORDINATES0
			#define ASE_NEEDS_FRAG_TEXTURE_COORDINATES0
			#define ASE_NEEDS_VERT_TANGENT
			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_FRAG_SHADOWCOORDS
			#define ASE_INSTANCED_TERRAIN
			#define ASE_NEEDS_VERT_POSITION
			#pragma shader_feature_local _ENABLESPECULARHIGHLIGHTS_ON
			#pragma multi_compile _ _CLUSTER_LIGHT_LOOP
			#pragma multi_compile_fragment _ _REFLECTION_PROBE_ATLAS
			#pragma multi_compile _ LIGHTMAP_ON
			#pragma multi_compile _ DIRLIGHTMAP_COMBINED
			#pragma multi_compile _ _MIXED_LIGHTING_SUBTRACTIVE
			#pragma multi_compile _ LIGHTMAP_BICUBIC_SAMPLING
			#pragma multi_compile _ DYNAMICLIGHTMAP_ON
			#pragma shader_feature_local _ENABLECOLORTINT_ON
			#pragma multi_compile_instancing
			#pragma instancing_options assumeuniformscaling nomatrices nolightprobe nolightmap
			#define TERRAIN_SPLAT_FIRSTPASS 1
			#pragma editor_sync_compilation
			#pragma multi_compile_local __ _ALPHATEST_ON
			#pragma shader_feature_local _MASKMAP


			struct Attributes
			{
				float4 positionOS : POSITION;
				half3 normalOS : NORMAL;
				half4 tangentOS : TANGENT;
				float4 ase_texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct PackedVaryings
			{
				float4 positionCS : SV_POSITION;
				float3 positionWS : TEXCOORD0;
				float4 ase_texcoord1 : TEXCOORD1;
				float4 ase_texcoord2 : TEXCOORD2;
				float4 ase_texcoord3 : TEXCOORD3;
				float4 ase_texcoord4 : TEXCOORD4;
				float4 ase_texcoord5 : TEXCOORD5;
				float4 lightmapUVOrVertexSH : TEXCOORD6;
				float4 dynamicLightmapUV : TEXCOORD7;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _Splat0_ST;
			float4 _TerrainHolesTexture_ST;
			float4 _BaseTint;
			float4 _Splat3_ST;
			float4 _SpecularTint1;
			float4 _Splat1_ST;
			float4 _Control_ST;
			float4 _Splat2_ST;
			float _NormalScale;
			float _SpecularOcclusion;
			float _IndirectSpecularContribution1;
			float _RampOffset;
			float _SpecularIntensity;
			float _SpecularSize1;
			float _SpecularSmoothness1;
			float _RampScale;
			float _Occlusion1;
			float _AlphaClip;
			float _Cutoff;
			#ifdef ASE_TRANSMISSION
				float _TransmissionShadow;
			#endif
			#ifdef ASE_TRANSLUCENCY
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
			#ifdef ASE_TESSELLATION
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END

			#ifdef SCENEPICKINGPASS
				float4 _SelectionID;
			#endif

			#ifdef SCENESELECTIONPASS
				int _ObjectId;
				int _PassValue;
			#endif

			sampler2D _Normal0;
			sampler2D _Splat0;
			sampler2D _Control;
			sampler2D _Normal1;
			sampler2D _Splat1;
			sampler2D _Normal2;
			sampler2D _Splat2;
			sampler2D _Normal3;
			sampler2D _Splat3;
			sampler2D _TerrainHolesTexture;
			sampler2D _TextureRamp3;
			#ifdef UNITY_INSTANCING_ENABLED//ASE Terrain Instancing
				TEXTURE2D(_TerrainHeightmapTexture);//ASE Terrain Instancing
				TEXTURE2D( _TerrainNormalmapTexture);//ASE Terrain Instancing
				SAMPLER(sampler_TerrainNormalmapTexture);//ASE Terrain Instancing
			#endif//ASE Terrain Instancing
			UNITY_INSTANCING_BUFFER_START( Terrain )//ASE Terrain Instancing
				UNITY_DEFINE_INSTANCED_PROP( float4, _TerrainPatchInstanceData )//ASE Terrain Instancing
			UNITY_INSTANCING_BUFFER_END( Terrain)//ASE Terrain Instancing
			CBUFFER_START( UnityTerrain)//ASE Terrain Instancing
				#ifdef UNITY_INSTANCING_ENABLED//ASE Terrain Instancing
					float4 _TerrainHeightmapRecipSize;//ASE Terrain Instancing
					float4 _TerrainHeightmapScale;//ASE Terrain Instancing
				#endif//ASE Terrain Instancing
			CBUFFER_END//ASE Terrain Instancing


			half4 CalculateShadowMask343_g61170(  )
			{
				#if defined(SHADOWS_SHADOWMASK) && defined(LIGHTMAP_ON)
				half4 shadowMask = inputData.shadowMask;
				#elif !defined (LIGHTMAP_ON)
				half4 shadowMask = unity_ProbesOcclusion;
				#else
				half4 shadowMask = half4(1, 1, 1, 1);
				#endif
				return shadowMask;
			}
			
			float3 AdditionalLightsLambertMask171x( float3 WorldPosition, float2 ScreenUV, float3 WorldNormal, float4 ShadowMask )
			{
				float3 Color = 0;
				#if defined(_ADDITIONAL_LIGHTS)
					#define SUM_LIGHTLAMBERT(Light)\
						half3 AttLightColor = Light.color * ( Light.distanceAttenuation * Light.shadowAttenuation );\
						Color += LightingLambert( AttLightColor, Light.direction, WorldNormal );
					InputData inputData = (InputData)0;
					inputData.normalizedScreenSpaceUV = ScreenUV;
					inputData.positionWS = WorldPosition;
					uint meshRenderingLayers = GetMeshRenderingLayer();
					uint pixelLightCount = GetAdditionalLightsCount();	
					#if USE_CLUSTER_LIGHT_LOOP
					[loop] for (uint lightIndex = 0; lightIndex < min(URP_FP_DIRECTIONAL_LIGHTS_COUNT, MAX_VISIBLE_LIGHTS); lightIndex++)
					{
						CLUSTER_LIGHT_LOOP_SUBTRACTIVE_LIGHT_CHECK
						Light light = GetAdditionalLight(lightIndex, WorldPosition, ShadowMask);
						#ifdef _LIGHT_LAYERS
						if (IsMatchingLightLayer(light.layerMask, meshRenderingLayers))
						#endif
						{
							SUM_LIGHTLAMBERT( light );
						}
					}
					#endif
					
					LIGHT_LOOP_BEGIN( pixelLightCount )
						Light light = GetAdditionalLight(lightIndex, WorldPosition, ShadowMask);
						#ifdef _LIGHT_LAYERS
						if (IsMatchingLightLayer(light.layerMask, meshRenderingLayers))
						#endif
						{
							SUM_LIGHTLAMBERT( light );
						}
					LIGHT_LOOP_END
				#endif
				return Color;
			}
			
			half3 ASEIndirectDiffuse( PackedVaryings input, half3 normalWS, float3 positionWS, half3 viewDirWS )
			{
			#if defined( DYNAMICLIGHTMAP_ON )
				return SAMPLE_GI( input.lightmapUVOrVertexSH.xy, input.dynamicLightmapUV.xy, 0, normalWS );
			#elif defined( LIGHTMAP_ON )
				return SAMPLE_GI( input.lightmapUVOrVertexSH.xy, 0, normalWS );
			#elif defined( PROBE_VOLUMES_L1 ) || defined( PROBE_VOLUMES_L2 )
				return SampleProbeVolumePixel( SampleSH( normalWS ), positionWS, normalWS, viewDirWS, input.positionCS.xy );
			#else
				return SampleSH( normalWS );
			#endif
			}
			
			half4 CalculateShadowMask343_g61167(  )
			{
				#if defined(SHADOWS_SHADOWMASK) && defined(LIGHTMAP_ON)
				half4 shadowMask = inputData.shadowMask;
				#elif !defined (LIGHTMAP_ON)
				half4 shadowMask = unity_ProbesOcclusion;
				#else
				half4 shadowMask = half4(1, 1, 1, 1);
				#endif
				return shadowMask;
			}
			
			void TerrainApplyMeshModification( inout float3 position, inout half3 normal, inout float4 texcoord )
			{
			#ifdef UNITY_INSTANCING_ENABLED
				float2 patchVertex = position.xy;
				float4 instanceData = UNITY_ACCESS_INSTANCED_PROP( Terrain, _TerrainPatchInstanceData );
				float2 sampleCoords = ( patchVertex.xy + instanceData.xy ) * instanceData.z;
				float height = UnpackHeightmap( _TerrainHeightmapTexture.Load( int3( sampleCoords, 0 ) ) );
				position.xz = sampleCoords* _TerrainHeightmapScale.xz;
				position.y = height* _TerrainHeightmapScale.y;
				#ifdef ENABLE_TERRAIN_PERPIXEL_NORMAL
					normal = float3(0, 1, 0);
				#else
					normal = _TerrainNormalmapTexture.Load(int3(sampleCoords, 0)).rgb* 2 - 1;
				#endif
				texcoord.xy = sampleCoords* _TerrainHeightmapRecipSize.zw;
			#endif
			}
			

			PackedVaryings VertexFunction( Attributes input  )
			{
				PackedVaryings output = (PackedVaryings)0;
				UNITY_SETUP_INSTANCE_ID( input );
				UNITY_TRANSFER_INSTANCE_ID( input, output );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( output );

				#if defined( ASE_INSTANCED_TERRAIN ) && !defined( ASE_TESSELLATION )
					TerrainApplyMeshModification( input.positionOS.xyz, input.normalOS, input.ase_texcoord );
				#endif
				
				float2 break956_g61173 = _Control_ST.zw;
				float2 appendResult959_g61173 = (float2(( break956_g61173.x + 0.001 ) , ( break956_g61173.y + 0.0001 )));
				float2 vertexToFrag961_g61173 = ( ( input.ase_texcoord.xy * _Control_ST.xy ) + appendResult959_g61173 );
				output.ase_texcoord1.zw = vertexToFrag961_g61173;
				float3 ase_tangentWS = TransformObjectToWorldDir( input.tangentOS.xyz );
				output.ase_texcoord2.xyz = ase_tangentWS;
				float3 ase_normalWS = TransformObjectToWorldNormal( input.normalOS );
				output.ase_texcoord3.xyz = ase_normalWS;
				float ase_tangentSign = input.tangentOS.w * ( unity_WorldTransformParams.w >= 0.0 ? 1.0 : -1.0 );
				float3 ase_bitangentWS = cross( ase_normalWS, ase_tangentWS ) * ase_tangentSign;
				output.ase_texcoord4.xyz = ase_bitangentWS;
				float4 ase_positionCS = TransformObjectToHClip( ( input.positionOS ).xyz );
				float4 screenPos = ComputeScreenPos( ase_positionCS );
				output.ase_texcoord5 = screenPos;
				OUTPUT_LIGHTMAP_UV( input.texcoord1, unity_LightmapST, output.lightmapUVOrVertexSH.xy );
				float3 ase_positionWS = TransformObjectToWorld( ( input.positionOS ).xyz );
				#if !defined( OUTPUT_SH4 )
				OUTPUT_SH( ase_positionWS, ase_normalWS, GetWorldSpaceNormalizeViewDir( ase_positionWS ), output.lightmapUVOrVertexSH.xyz );
				#elif UNITY_VERSION > 60000009
				OUTPUT_SH4( ase_positionWS, ase_normalWS, GetWorldSpaceNormalizeViewDir( ase_positionWS ), output.lightmapUVOrVertexSH.xyz, output.probeOcclusion );
				#else
				OUTPUT_SH4( ase_positionWS, ase_normalWS, GetWorldSpaceNormalizeViewDir( ase_positionWS ), output.lightmapUVOrVertexSH.xyz );
				#endif
				#if defined( DYNAMICLIGHTMAP_ON )
				output.dynamicLightmapUV.xy = input.texcoord2.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
				#endif
				
				output.ase_texcoord1.xy = input.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				output.ase_texcoord2.w = 0;
				output.ase_texcoord3.w = 0;
				output.ase_texcoord4.w = 0;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = input.positionOS.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = defaultVertexValue;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					input.positionOS.xyz = vertexValue;
				#else
					input.positionOS.xyz += vertexValue;
				#endif

				input.normalOS = input.normalOS;
				input.tangentOS = input.tangentOS;

				VertexPositionInputs vertexInput = GetVertexPositionInputs( input.positionOS.xyz );

				output.positionCS = vertexInput.positionCS;
				output.positionWS = vertexInput.positionWS;
				return output;
			}

			#if defined(ASE_TESSELLATION)
			struct VertexControl
			{
				float4 positionOS : INTERNALTESSPOS;
				half3 normalOS : NORMAL;
				half4 tangentOS : TANGENT;
				float4 ase_texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;

				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( Attributes input )
			{
				VertexControl output;
				UNITY_SETUP_INSTANCE_ID(input);
				UNITY_TRANSFER_INSTANCE_ID(input, output);
				output.positionOS = input.positionOS;
				output.normalOS = input.normalOS;
				output.tangentOS = input.tangentOS;
				output.ase_texcoord = input.ase_texcoord;
				output.texcoord1 = input.texcoord1;
				output.texcoord2 = input.texcoord2;
				#if defined( ASE_INSTANCED_TERRAIN )
					TerrainApplyMeshModification( output.positionOS.xyz, output.normalOS, output.ase_texcoord );
				#endif
				
				return output;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> input)
			{
				TessellationFactors output;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(input[0].positionOS, input[1].positionOS, input[2].positionOS, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(input[0].positionOS, input[1].positionOS, input[2].positionOS, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(input[0].positionOS, input[1].positionOS, input[2].positionOS, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				output.edge[0] = tf.x; output.edge[1] = tf.y; output.edge[2] = tf.z; output.inside = tf.w;
				return output;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
				return patch[id];
			}

			[domain("tri")]
			PackedVaryings DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				Attributes output = (Attributes) 0;
				output.positionOS = patch[0].positionOS * bary.x + patch[1].positionOS * bary.y + patch[2].positionOS * bary.z;
				output.normalOS = patch[0].normalOS * bary.x + patch[1].normalOS * bary.y + patch[2].normalOS * bary.z;
				output.tangentOS = patch[0].tangentOS * bary.x + patch[1].tangentOS * bary.y + patch[2].tangentOS * bary.z;
				output.ase_texcoord = patch[0].ase_texcoord * bary.x + patch[1].ase_texcoord * bary.y + patch[2].ase_texcoord * bary.z;
				output.texcoord1 = patch[0].texcoord1 * bary.x + patch[1].texcoord1 * bary.y + patch[2].texcoord1 * bary.z;
				output.texcoord2 = patch[0].texcoord2 * bary.x + patch[1].texcoord2 * bary.y + patch[2].texcoord2 * bary.z;
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = output.positionOS.xyz - patch[i].normalOS * (dot(output.positionOS.xyz, patch[i].normalOS) - dot(patch[i].positionOS.xyz, patch[i].normalOS));
				float phongStrength = _TessPhongStrength;
				output.positionOS.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * output.positionOS.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], output);
				return VertexFunction(output);
			}
			#else
			PackedVaryings vert ( Attributes input )
			{
				return VertexFunction( input );
			}
			#endif

			half4 frag(PackedVaryings input  ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( input );
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( input );

				#if defined(MAIN_LIGHT_CALCULATE_SHADOWS) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					float4 shadowCoord = TransformWorldToShadowCoord(input.positionWS);
				#else
					float4 shadowCoord = float4(0, 0, 0, 0);
				#endif

				float3 PositionWS = input.positionWS;
				float3 PositionRWS = GetCameraRelativePositionWS( input.positionWS );
				float4 ShadowCoord = shadowCoord;

				float3 temp_cast_0 = (1.0).xxx;
				float3 ase_viewVectorWS = ( ( unity_OrthoParams.w == 0 ) ? _WorldSpaceCameraPos - PositionWS : UNITY_MATRIX_V[ 2 ].xyz );
				float3 ase_viewDirWS = normalize( ase_viewVectorWS );
				float4 ControlFinal724_g61173 = float4( 1, 1, 1, 1 );
				float2 uv_Splat0 = input.ase_texcoord1.xy * _Splat0_ST.xy + _Splat0_ST.zw;
				float4 tex2DNode2_g61173 = tex2D( _Normal0, uv_Splat0 );
				float _HeightA279_g61173 = tex2DNode2_g61173.a;
				float smoothstepResult810_g61173 = smoothstep( 0.0 , 1.0 , _HeightA279_g61173);
				float clampResult933_g61173 = clamp( smoothstepResult810_g61173 , 0.001 , 0.999 );
				float2 vertexToFrag961_g61173 = input.ase_texcoord1.zw;
				float4 tex2DNode5_g61173 = tex2D( _Control, vertexToFrag961_g61173 );
				float _MaskA481_g61173 = tex2DNode5_g61173.r;
				float clampResult830_g61173 = clamp( _MaskA481_g61173 , 0.0 , 1.0 );
				float temp_output_829_0_g61173 = ( clampResult933_g61173 * clampResult830_g61173 );
				float3 break635_g61173 = tex2DNode2_g61173.rgb;
				float2 appendResult655_g61173 = (float2(( ( break635_g61173.x * 2.0 ) - 1.0 ) , ( ( break635_g61173.y * 2.0 ) - 1.0 )));
				float3 appendResult656_g61173 = (float3(appendResult655_g61173 , sqrt( max( 0.0, ( 1.0 - ( ( break635_g61173.x * break635_g61173.x ) + ( break635_g61173.y * break635_g61173.y ) ) ) ) )));
				float3 _UnpackedNormalA720_g61173 = appendResult656_g61173;
				float2 uv_Splat1 = input.ase_texcoord1.xy * _Splat1_ST.xy + _Splat1_ST.zw;
				float4 tex2DNode1_g61173 = tex2D( _Normal1, uv_Splat1 );
				float _HeightB280_g61173 = tex2DNode1_g61173.a;
				float smoothstepResult812_g61173 = smoothstep( 0.0 , 1.0 , _HeightB280_g61173);
				float clampResult934_g61173 = clamp( smoothstepResult812_g61173 , 0.001 , 0.999 );
				float _MaskB482_g61173 = tex2DNode5_g61173.g;
				float clampResult832_g61173 = clamp( _MaskB482_g61173 , 0.0 , 1.0 );
				float temp_output_826_0_g61173 = ( clampResult934_g61173 * clampResult832_g61173 );
				float3 break657_g61173 = tex2DNode1_g61173.rgb;
				float2 appendResult664_g61173 = (float2(( ( break657_g61173.x * 2.0 ) - 1.0 ) , ( ( break657_g61173.y * 2.0 ) - 1.0 )));
				float3 appendResult673_g61173 = (float3(appendResult664_g61173 , sqrt( max( 0.0, ( 1.0 - ( ( break657_g61173.x * break657_g61173.x ) + ( break657_g61173.y * break657_g61173.y ) ) ) ) )));
				float3 _UnpackedNormalB721_g61173 = appendResult673_g61173;
				float2 uv_Splat2 = input.ase_texcoord1.xy * _Splat2_ST.xy + _Splat2_ST.zw;
				float4 tex2DNode10_g61173 = tex2D( _Normal2, uv_Splat2 );
				float _HeightC281_g61173 = tex2DNode10_g61173.a;
				float smoothstepResult811_g61173 = smoothstep( 0.0 , 1.0 , _HeightC281_g61173);
				float clampResult935_g61173 = clamp( smoothstepResult811_g61173 , 0.001 , 0.999 );
				float _MaskC483_g61173 = tex2DNode5_g61173.b;
				float clampResult831_g61173 = clamp( _MaskC483_g61173 , 0.0 , 1.0 );
				float temp_output_827_0_g61173 = ( clampResult935_g61173 * clampResult831_g61173 );
				float3 break676_g61173 = tex2DNode10_g61173.rgb;
				float2 appendResult683_g61173 = (float2(( ( break676_g61173.x * 2.0 ) - 1.0 ) , ( ( break676_g61173.y * 2.0 ) - 1.0 )));
				float3 appendResult692_g61173 = (float3(appendResult683_g61173 , sqrt( max( 0.0, ( 1.0 - ( ( break676_g61173.x * break676_g61173.x ) + ( break676_g61173.y * break676_g61173.y ) ) ) ) )));
				float3 _UnpackedNormalC722_g61173 = appendResult692_g61173;
				float2 uv_Splat3 = input.ase_texcoord1.xy * _Splat3_ST.xy + _Splat3_ST.zw;
				float4 tex2DNode11_g61173 = tex2D( _Normal3, uv_Splat3 );
				float _HeightD282_g61173 = tex2DNode11_g61173.a;
				float smoothstepResult813_g61173 = smoothstep( 0.0 , 1.0 , _HeightD282_g61173);
				float clampResult936_g61173 = clamp( smoothstepResult813_g61173 , 0.001 , 0.999 );
				float _MaskD484_g61173 = tex2DNode5_g61173.a;
				float clampResult833_g61173 = clamp( _MaskD484_g61173 , 0.0 , 1.0 );
				float temp_output_828_0_g61173 = ( clampResult936_g61173 * clampResult833_g61173 );
				float3 break695_g61173 = tex2DNode11_g61173.rgb;
				float2 appendResult702_g61173 = (float2(( ( break695_g61173.x * 2.0 ) - 1.0 ) , ( ( break695_g61173.y * 2.0 ) - 1.0 )));
				float3 appendResult711_g61173 = (float3(appendResult702_g61173 , sqrt( max( 0.0, ( 1.0 - ( ( break695_g61173.x * break695_g61173.x ) + ( break695_g61173.y * break695_g61173.y ) ) ) ) )));
				float3 _UnpackedNormalD723_g61173 = appendResult711_g61173;
				float4 weightedBlendVar840_g61173 = ControlFinal724_g61173;
				float3 weightedBlend840_g61173 = ( weightedBlendVar840_g61173.x*( temp_output_829_0_g61173 * _UnpackedNormalA720_g61173 ) + weightedBlendVar840_g61173.y*( temp_output_826_0_g61173 * _UnpackedNormalB721_g61173 ) + weightedBlendVar840_g61173.z*( temp_output_827_0_g61173 * _UnpackedNormalC722_g61173 ) + weightedBlendVar840_g61173.w*( temp_output_828_0_g61173 * _UnpackedNormalD723_g61173 ) );
				float4 weightedBlendVar841_g61173 = ControlFinal724_g61173;
				float weightedBlend841_g61173 = ( weightedBlendVar841_g61173.x*temp_output_829_0_g61173 + weightedBlendVar841_g61173.y*temp_output_826_0_g61173 + weightedBlendVar841_g61173.z*temp_output_827_0_g61173 + weightedBlendVar841_g61173.w*temp_output_828_0_g61173 );
				float3 FinalNormal765_g61173 = ( weightedBlend840_g61173 / max( weightedBlend841_g61173, 0.001 ) );
				float3 temp_output_61_0_g61173 = FinalNormal765_g61173;
				float3 Normal554 = temp_output_61_0_g61173;
				float3 ase_tangentWS = input.ase_texcoord2.xyz;
				float3 ase_normalWS = input.ase_texcoord3.xyz;
				float3 ase_bitangentWS = input.ase_texcoord4.xyz;
				float3 tanToWorld0 = float3( ase_tangentWS.x, ase_bitangentWS.x, ase_normalWS.x );
				float3 tanToWorld1 = float3( ase_tangentWS.y, ase_bitangentWS.y, ase_normalWS.y );
				float3 tanToWorld2 = float3( ase_tangentWS.z, ase_bitangentWS.z, ase_normalWS.z );
				float3 tanNormal638 = ( Normal554 * _NormalScale );
				float3 worldNormal638 = normalize( float3( dot( tanToWorld0, tanNormal638 ), dot( tanToWorld1, tanNormal638 ), dot( tanToWorld2, tanNormal638 ) ) );
				float3 normalizeResult640 = normalize( worldNormal638 );
				float3 Normals780 = normalizeResult640;
				float smoothstepResult859_g61173 = smoothstep( 0.0 , 1.0 , _HeightA279_g61173);
				float clampResult937_g61173 = clamp( smoothstepResult859_g61173 , 0.001 , 0.999 );
				float clampResult879_g61173 = clamp( _MaskA481_g61173 , 0.0 , 1.0 );
				float temp_output_878_0_g61173 = ( clampResult937_g61173 * clampResult879_g61173 );
				float4 tex2DNode4_g61173 = tex2D( _Splat0, uv_Splat0 );
				float _LayerAlphaA778_g61173 = tex2DNode4_g61173.a;
				float smoothstepResult861_g61173 = smoothstep( 0.0 , 1.0 , _HeightB280_g61173);
				float clampResult938_g61173 = clamp( smoothstepResult861_g61173 , 0.001 , 0.999 );
				float clampResult881_g61173 = clamp( _MaskB482_g61173 , 0.0 , 1.0 );
				float temp_output_875_0_g61173 = ( clampResult938_g61173 * clampResult881_g61173 );
				float4 tex2DNode3_g61173 = tex2D( _Splat1, uv_Splat1 );
				float _LayerAlphaB779_g61173 = tex2DNode3_g61173.a;
				float smoothstepResult860_g61173 = smoothstep( 0.0 , 1.0 , _HeightC281_g61173);
				float clampResult939_g61173 = clamp( smoothstepResult860_g61173 , 0.001 , 0.999 );
				float clampResult880_g61173 = clamp( _MaskC483_g61173 , 0.0 , 1.0 );
				float temp_output_876_0_g61173 = ( clampResult939_g61173 * clampResult880_g61173 );
				float4 tex2DNode6_g61173 = tex2D( _Splat2, uv_Splat2 );
				float _LayerAlphaC780_g61173 = tex2DNode6_g61173.a;
				float smoothstepResult862_g61173 = smoothstep( 0.0 , 1.0 , _HeightD282_g61173);
				float clampResult940_g61173 = clamp( smoothstepResult862_g61173 , 0.001 , 0.999 );
				float clampResult882_g61173 = clamp( _MaskD484_g61173 , 0.0 , 1.0 );
				float temp_output_877_0_g61173 = ( clampResult940_g61173 * clampResult882_g61173 );
				float4 tex2DNode7_g61173 = tex2D( _Splat3, uv_Splat3 );
				float _LayerAlphaD781_g61173 = tex2DNode7_g61173.a;
				float4 weightedBlendVar887_g61173 = ControlFinal724_g61173;
				float weightedBlend887_g61173 = ( weightedBlendVar887_g61173.x*( temp_output_878_0_g61173 * _LayerAlphaA778_g61173 ) + weightedBlendVar887_g61173.y*( temp_output_875_0_g61173 * _LayerAlphaB779_g61173 ) + weightedBlendVar887_g61173.z*( temp_output_876_0_g61173 * _LayerAlphaC780_g61173 ) + weightedBlendVar887_g61173.w*( temp_output_877_0_g61173 * _LayerAlphaD781_g61173 ) );
				float4 weightedBlendVar888_g61173 = ControlFinal724_g61173;
				float weightedBlend888_g61173 = ( weightedBlendVar888_g61173.x*temp_output_878_0_g61173 + weightedBlendVar888_g61173.y*temp_output_875_0_g61173 + weightedBlendVar888_g61173.z*temp_output_876_0_g61173 + weightedBlendVar888_g61173.w*temp_output_877_0_g61173 );
				float FinalSmoothness897_g61173 = ( weightedBlend887_g61173 / max( weightedBlend888_g61173, 0.001 ) );
				float Smoothness533 = FinalSmoothness897_g61173;
				half3 reflectVector772 = reflect( -ase_viewDirWS, Normals780 );
				float4 screenPos = input.ase_texcoord5;
				float4 ase_positionSSNorm = screenPos / screenPos.w;
				ase_positionSSNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_positionSSNorm.z : ase_positionSSNorm.z * 0.5 + 0.5;
				float3 indirectSpecular772 = GlossyEnvironmentReflection( reflectVector772, PositionWS, 1.0 - Smoothness533, _SpecularOcclusion, ase_positionSSNorm.xy );
				float3 lerpResult643 = lerp( temp_cast_0 , indirectSpecular772 , _IndirectSpecularContribution1);
				float3 IndirectSpecHighlights793 = lerpResult643;
				float4 temp_output_751_0 = ( _SpecularTint1 * Smoothness533 * _SpecularIntensity );
				float3 normalizeResult4_g61169 = normalize( ( ase_viewDirWS + SafeNormalize( _MainLightPosition.xyz ) ) );
				float dotResult749 = dot( normalizeResult4_g61169 , Normals780 );
				float3 WorldPosition288_g61170 = PositionWS;
				float3 WorldPosition337_g61170 = WorldPosition288_g61170;
				float2 ScreenUV286_g61170 = (ase_positionSSNorm).xy;
				float2 ScreenUV337_g61170 = ScreenUV286_g61170;
				float3 WorldNormal281_g61170 = Normals780;
				float3 WorldNormal337_g61170 = WorldNormal281_g61170;
				half4 localCalculateShadowMask343_g61170 = CalculateShadowMask343_g61170();
				float4 ShadowMask360_g61170 = localCalculateShadowMask343_g61170;
				float4 ShadowMask337_g61170 = ShadowMask360_g61170;
				float3 localAdditionalLightsLambertMask171x337_g61170 = AdditionalLightsLambertMask171x( WorldPosition337_g61170 , ScreenUV337_g61170 , WorldNormal337_g61170 , ShadowMask337_g61170 );
				float4 DirectSpecHighlights764 = ( float4( (temp_output_751_0).rgb , 0.0 ) * saturate( ( float4( (  (-1.0 + ( _SpecularSize1 - 0.0 ) * ( -0.5 - -1.0 ) / ( 1.0 - 0.0 ) ) + ( dotResult749 + saturate( localAdditionalLightsLambertMask171x337_g61170 ) ) ) , 0.0 ) / ( ( 1.0 - temp_output_751_0 ) * _SpecularSmoothness1 ) ) ) );
				float ase_lightIntensity = max( max( _MainLightColor.r, _MainLightColor.g ), _MainLightColor.b ) + 1e-7;
				float4 ase_lightColor = float4( _MainLightColor.rgb / ase_lightIntensity, ase_lightIntensity );
				float ase_lightAtten = 0;
				Light ase_mainLight = GetMainLight( ShadowCoord );
				ase_lightAtten = ase_mainLight.distanceAttenuation * ase_mainLight.shadowAttenuation;
				float3 bakedGI730 = ASEIndirectDiffuse( input, ase_normalWS, PositionWS, ase_viewDirWS );
				MixRealtimeAndBakedGI( ase_mainLight, ase_normalWS, bakedGI730, half4( 0, 0, 0, 0 ) );
				float4 HalfLambert733 = ( ( ase_lightColor * ase_lightAtten ) + float4( bakedGI730 , 0.0 ) );
				float4 SpecularHighlights768 = ( float4( IndirectSpecHighlights793 , 0.0 ) * DirectSpecHighlights764 * HalfLambert733 );
				#ifdef _ENABLESPECULARHIGHLIGHTS_ON
				float4 staticSwitch763 = SpecularHighlights768;
				#else
				float4 staticSwitch763 = float4( 0,0,0,0 );
				#endif
				float4 color648 = IsGammaSpace() ? float4( 1, 1, 1, 1 ) : float4( 1, 1, 1, 1 );
				#ifdef _ENABLECOLORTINT_ON
				float4 staticSwitch774 = _BaseTint;
				#else
				float4 staticSwitch774 = color648;
				#endif
				float smoothstepResult591_g61173 = smoothstep( 0.0 , 1.0 , _HeightA279_g61173);
				float clampResult944_g61173 = clamp( smoothstepResult591_g61173 , 0.001 , 0.999 );
				float clampResult603_g61173 = clamp( _MaskA481_g61173 , 0.0 , 1.0 );
				float temp_output_597_0_g61173 = ( clampResult944_g61173 * clampResult603_g61173 );
				float4 _LayerA287_g61173 = tex2DNode4_g61173;
				float smoothstepResult594_g61173 = smoothstep( 0.0 , 1.0 , _HeightB280_g61173);
				float clampResult943_g61173 = clamp( smoothstepResult594_g61173 , 0.001 , 0.999 );
				float clampResult604_g61173 = clamp( _MaskB482_g61173 , 0.0 , 1.0 );
				float temp_output_598_0_g61173 = ( clampResult943_g61173 * clampResult604_g61173 );
				float4 _LayerB300_g61173 = tex2DNode3_g61173;
				float smoothstepResult595_g61173 = smoothstep( 0.0 , 1.0 , _HeightC281_g61173);
				float clampResult942_g61173 = clamp( smoothstepResult595_g61173 , 0.001 , 0.999 );
				float clampResult605_g61173 = clamp( _MaskC483_g61173 , 0.0 , 1.0 );
				float temp_output_599_0_g61173 = ( clampResult942_g61173 * clampResult605_g61173 );
				float4 _LayerC301_g61173 = tex2DNode6_g61173;
				float smoothstepResult596_g61173 = smoothstep( 0.0 , 1.0 , _HeightD282_g61173);
				float clampResult941_g61173 = clamp( smoothstepResult596_g61173 , 0.001 , 0.999 );
				float clampResult606_g61173 = clamp( _MaskD484_g61173 , 0.0 , 1.0 );
				float temp_output_600_0_g61173 = ( clampResult941_g61173 * clampResult606_g61173 );
				float4 _LayerD302_g61173 = tex2DNode7_g61173;
				float4 weightedBlendVar619_g61173 = ControlFinal724_g61173;
				float4 weightedBlend619_g61173 = ( weightedBlendVar619_g61173.x*( temp_output_597_0_g61173 * _LayerA287_g61173 ) + weightedBlendVar619_g61173.y*( temp_output_598_0_g61173 * _LayerB300_g61173 ) + weightedBlendVar619_g61173.z*( temp_output_599_0_g61173 * _LayerC301_g61173 ) + weightedBlendVar619_g61173.w*( temp_output_600_0_g61173 * _LayerD302_g61173 ) );
				float4 weightedBlendVar620_g61173 = ControlFinal724_g61173;
				float weightedBlend620_g61173 = ( weightedBlendVar620_g61173.x*temp_output_597_0_g61173 + weightedBlendVar620_g61173.y*temp_output_598_0_g61173 + weightedBlendVar620_g61173.z*temp_output_599_0_g61173 + weightedBlendVar620_g61173.w*temp_output_600_0_g61173 );
				float4 FinalAlbedo479_g61173 = ( weightedBlend619_g61173 / max( weightedBlend620_g61173, 0.001 ) );
				float4 temp_output_60_0_g61173 = FinalAlbedo479_g61173;
				float4 localClipHoles100_g61173 = ( temp_output_60_0_g61173 );
				float2 uv_TerrainHolesTexture = input.ase_texcoord1.xy * _TerrainHolesTexture_ST.xy + _TerrainHolesTexture_ST.zw;
				float holeClipValue99_g61173 = tex2D( _TerrainHolesTexture, uv_TerrainHolesTexture ).r;
				float Hole100_g61173 = holeClipValue99_g61173;
				{
				#ifdef _ALPHATEST_ON
				clip(Hole100_g61173 == 0.0f ? -1 : 1);
				#endif
				}
				float4 Albedo536 = localClipHoles100_g61173;
				float dotResult723 = dot( Normals780 , SafeNormalize( _MainLightPosition.xyz ) );
				float RampScale743 = _RampScale;
				float RampOffset742 = _RampOffset;
				float CEL_Effect664 = saturate( (dotResult723*RampScale743 + RampOffset742) );
				float2 temp_cast_6 = (CEL_Effect664).xx;
				float3 WorldPosition288_g61167 = PositionWS;
				float3 WorldPosition337_g61167 = WorldPosition288_g61167;
				float2 ScreenUV286_g61167 = (ase_positionSSNorm).xy;
				float2 ScreenUV337_g61167 = ScreenUV286_g61167;
				float3 WorldNormal281_g61167 = Normals780;
				float3 WorldNormal337_g61167 = WorldNormal281_g61167;
				half4 localCalculateShadowMask343_g61167 = CalculateShadowMask343_g61167();
				float4 ShadowMask360_g61167 = localCalculateShadowMask343_g61167;
				float4 ShadowMask337_g61167 = ShadowMask360_g61167;
				float3 localAdditionalLightsLambertMask171x337_g61167 = AdditionalLightsLambertMask171x( WorldPosition337_g61167 , ScreenUV337_g61167 , WorldNormal337_g61167 , ShadowMask337_g61167 );
				

				float3 BaseColor = ( staticSwitch763 + ( staticSwitch774 * ( ( ( Albedo536 * tex2D( _TextureRamp3, temp_cast_6 ) ) * HalfLambert733 ) + ( Albedo536 * tex2D( _TextureRamp3, (saturate( localAdditionalLightsLambertMask171x337_g61167 )*RampScale743 + RampOffset742).xy ) ) ) ) ).rgb;
				float Alpha = 1;
				#if defined( _ALPHATEST_ON )
					float AlphaClipThreshold = _Cutoff;
				#endif

				half4 color = half4(BaseColor, Alpha );

				#if defined( _ALPHATEST_ON )
					AlphaDiscard( Alpha, AlphaClipThreshold );
				#endif

				return color;
			}
			ENDHLSL
		}

		
		Pass
		{
			
			Name "DepthNormals"
			Tags { "LightMode"="DepthNormals" }

			ZWrite On
			Blend One Zero
			ZTest LEqual
			ZWrite On

			HLSLPROGRAM

			#define _SPECULAR_SETUP 1
			#define _NORMAL_DROPOFF_TS 1
			#define ASE_FOG 1
			#pragma multi_compile_fragment _ DEBUG_DISPLAY
			#define _SPECULARHIGHLIGHTS_OFF
			#define ASE_LIGHTING_SIMPLE
			#define ASE_TERRAIN
			#pragma shader_feature _INSTANCEDTERRAINNORMALS_PIXEL
			#define ASE_VERSION 19908
			#define ASE_SRP_VERSION 170100


			#pragma vertex vert
			#pragma fragment frag

			#if defined( _SPECULAR_SETUP ) && defined( ASE_LIGHTING_SIMPLE )
				#if defined( _SPECULARHIGHLIGHTS_OFF )
					#undef _SPECULAR_COLOR
				#else
					#define _SPECULAR_COLOR
				#endif
			#endif

			#define SHADERPASS SHADERPASS_DEPTHNORMALSONLY
			//#define SHADERPASS SHADERPASS_DEPTHNORMALS

			#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
			#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
            #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			#if defined(LOD_FADE_CROSSFADE)
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/LODCrossFade.hlsl"
            #endif

			#if defined( UNITY_INSTANCING_ENABLED ) && defined( ASE_INSTANCED_TERRAIN ) && ( defined(_TERRAIN_INSTANCED_PERPIXEL_NORMAL) || defined(_INSTANCEDTERRAINNORMALS_PIXEL) )
				#define ENABLE_TERRAIN_PERPIXEL_NORMAL
			#endif

			#define ASE_INSTANCED_TERRAIN
			#define ASE_NEEDS_VERT_POSITION
			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_TEXTURE_COORDINATES0
			#pragma multi_compile_instancing
			#pragma instancing_options assumeuniformscaling nomatrices nolightprobe nolightmap
			#define TERRAIN_SPLAT_FIRSTPASS 1
			#pragma editor_sync_compilation
			#pragma multi_compile_local __ _ALPHATEST_ON
			#pragma shader_feature_local _MASKMAP


			#if defined(ASE_EARLY_Z_DEPTH_OPTIMIZE) && (SHADER_TARGET >= 45)
				#define ASE_SV_DEPTH SV_DepthLessEqual
				#define ASE_SV_POSITION_QUALIFIERS linear noperspective centroid
			#else
				#define ASE_SV_DEPTH SV_Depth
				#define ASE_SV_POSITION_QUALIFIERS
			#endif

			struct Attributes
			{
				float4 positionOS : POSITION;
				half3 normalOS : NORMAL;
				half4 tangentOS : TANGENT;
				half4 texcoord : TEXCOORD0;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct PackedVaryings
			{
				ASE_SV_POSITION_QUALIFIERS float4 positionCS : SV_POSITION;
				float3 positionWS : TEXCOORD0;
				half3 normalWS : TEXCOORD1;
				float4 tangentWS : TEXCOORD2; // holds terrainUV ifdef ENABLE_TERRAIN_PERPIXEL_NORMAL
				float4 ase_texcoord3 : TEXCOORD3;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _Splat0_ST;
			float4 _TerrainHolesTexture_ST;
			float4 _BaseTint;
			float4 _Splat3_ST;
			float4 _SpecularTint1;
			float4 _Splat1_ST;
			float4 _Control_ST;
			float4 _Splat2_ST;
			float _NormalScale;
			float _SpecularOcclusion;
			float _IndirectSpecularContribution1;
			float _RampOffset;
			float _SpecularIntensity;
			float _SpecularSize1;
			float _SpecularSmoothness1;
			float _RampScale;
			float _Occlusion1;
			float _AlphaClip;
			float _Cutoff;
			#ifdef ASE_TRANSMISSION
				float _TransmissionShadow;
			#endif
			#ifdef ASE_TRANSLUCENCY
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
			#ifdef ASE_TESSELLATION
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END

			#ifdef SCENEPICKINGPASS
				float4 _SelectionID;
			#endif

			#ifdef SCENESELECTIONPASS
				int _ObjectId;
				int _PassValue;
			#endif

			#ifdef UNITY_INSTANCING_ENABLED//ASE Terrain Instancing
				TEXTURE2D(_TerrainHeightmapTexture);//ASE Terrain Instancing
				TEXTURE2D( _TerrainNormalmapTexture);//ASE Terrain Instancing
				SAMPLER(sampler_TerrainNormalmapTexture);//ASE Terrain Instancing
			#endif//ASE Terrain Instancing
			UNITY_INSTANCING_BUFFER_START( Terrain )//ASE Terrain Instancing
				UNITY_DEFINE_INSTANCED_PROP( float4, _TerrainPatchInstanceData )//ASE Terrain Instancing
			UNITY_INSTANCING_BUFFER_END( Terrain)//ASE Terrain Instancing
			CBUFFER_START( UnityTerrain)//ASE Terrain Instancing
				#ifdef UNITY_INSTANCING_ENABLED//ASE Terrain Instancing
					float4 _TerrainHeightmapRecipSize;//ASE Terrain Instancing
					float4 _TerrainHeightmapScale;//ASE Terrain Instancing
				#endif//ASE Terrain Instancing
			CBUFFER_END//ASE Terrain Instancing


			void TerrainApplyMeshModification( inout float3 position, inout half3 normal, inout float4 texcoord )
			{
			#ifdef UNITY_INSTANCING_ENABLED
				float2 patchVertex = position.xy;
				float4 instanceData = UNITY_ACCESS_INSTANCED_PROP( Terrain, _TerrainPatchInstanceData );
				float2 sampleCoords = ( patchVertex.xy + instanceData.xy ) * instanceData.z;
				float height = UnpackHeightmap( _TerrainHeightmapTexture.Load( int3( sampleCoords, 0 ) ) );
				position.xz = sampleCoords* _TerrainHeightmapScale.xz;
				position.y = height* _TerrainHeightmapScale.y;
				#ifdef ENABLE_TERRAIN_PERPIXEL_NORMAL
					normal = float3(0, 1, 0);
				#else
					normal = _TerrainNormalmapTexture.Load(int3(sampleCoords, 0)).rgb* 2 - 1;
				#endif
				texcoord.xy = sampleCoords* _TerrainHeightmapRecipSize.zw;
			#endif
			}
			

			PackedVaryings VertexFunction( Attributes input  )
			{
				PackedVaryings output = (PackedVaryings)0;
				UNITY_SETUP_INSTANCE_ID(input);
				UNITY_TRANSFER_INSTANCE_ID(input, output);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(output);

				#if defined( ASE_INSTANCED_TERRAIN ) && !defined( ASE_TESSELLATION )
					TerrainApplyMeshModification( input.positionOS.xyz, input.normalOS, input.texcoord );
				#endif
				
				output.ase_texcoord3 = input.texcoord;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = input.positionOS.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = defaultVertexValue;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					input.positionOS.xyz = vertexValue;
				#else
					input.positionOS.xyz += vertexValue;
				#endif

				input.normalOS = input.normalOS;
				input.tangentOS = input.tangentOS;

				VertexPositionInputs vertexInput = GetVertexPositionInputs( input.positionOS.xyz );
				VertexNormalInputs normalInput = GetVertexNormalInputs( input.normalOS, input.tangentOS );

				output.positionCS = vertexInput.positionCS;
				output.positionWS = vertexInput.positionWS;
				output.normalWS = normalInput.normalWS;
				output.tangentWS = float4( normalInput.tangentWS, ( input.tangentOS.w > 0.0 ? 1.0 : -1.0 ) * GetOddNegativeScale() );

				#if defined( ENABLE_TERRAIN_PERPIXEL_NORMAL )
					output.tangentWS.zw = input.texcoord.xy;
					output.tangentWS.xy = input.texcoord.xy * unity_LightmapST.xy + unity_LightmapST.zw;
				#endif
				return output;
			}

			#if defined(ASE_TESSELLATION)
			struct VertexControl
			{
				float4 positionOS : INTERNALTESSPOS;
				half3 normalOS : NORMAL;
				half4 tangentOS : TANGENT;
				float4 texcoord : TEXCOORD0;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( Attributes input )
			{
				VertexControl output;
				UNITY_SETUP_INSTANCE_ID(input);
				UNITY_TRANSFER_INSTANCE_ID(input, output);
				output.positionOS = input.positionOS;
				output.normalOS = input.normalOS;
				output.tangentOS = input.tangentOS;
				output.texcoord = input.texcoord;
				#if defined( ASE_INSTANCED_TERRAIN )
					TerrainApplyMeshModification( output.positionOS.xyz, output.normalOS, output.texcoord );
				#endif
				
				return output;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> input)
			{
				TessellationFactors output;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(input[0].positionOS, input[1].positionOS, input[2].positionOS, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(input[0].positionOS, input[1].positionOS, input[2].positionOS, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(input[0].positionOS, input[1].positionOS, input[2].positionOS, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				output.edge[0] = tf.x; output.edge[1] = tf.y; output.edge[2] = tf.z; output.inside = tf.w;
				return output;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
				return patch[id];
			}

			[domain("tri")]
			PackedVaryings DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				Attributes output = (Attributes) 0;
				output.positionOS = patch[0].positionOS * bary.x + patch[1].positionOS * bary.y + patch[2].positionOS * bary.z;
				output.normalOS = patch[0].normalOS * bary.x + patch[1].normalOS * bary.y + patch[2].normalOS * bary.z;
				output.tangentOS = patch[0].tangentOS * bary.x + patch[1].tangentOS * bary.y + patch[2].tangentOS * bary.z;
				output.texcoord = patch[0].texcoord * bary.x + patch[1].texcoord * bary.y + patch[2].texcoord * bary.z;
				
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = output.positionOS.xyz - patch[i].normalOS * (dot(output.positionOS.xyz, patch[i].normalOS) - dot(patch[i].positionOS.xyz, patch[i].normalOS));
				float phongStrength = _TessPhongStrength;
				output.positionOS.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * output.positionOS.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], output);
				return VertexFunction(output);
			}
			#else
			PackedVaryings vert ( Attributes input )
			{
				return VertexFunction( input );
			}
			#endif

			void frag(	PackedVaryings input
						, out half4 outNormalWS : SV_Target0
						#if defined( ASE_DEPTH_WRITE_ON )
						,out float outputDepth : ASE_SV_DEPTH
						#endif
						#ifdef _WRITE_RENDERING_LAYERS
						, out float4 outRenderingLayers : SV_Target1
						#endif
						 )
			{
				UNITY_SETUP_INSTANCE_ID(input);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( input );

				#if defined(MAIN_LIGHT_CALCULATE_SHADOWS) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					float4 shadowCoord = TransformWorldToShadowCoord(input.positionWS);
				#else
					float4 shadowCoord = float4(0, 0, 0, 0);
				#endif

				// @diogo: mikktspace compliant
				float renormFactor = 1.0 / max( FLT_MIN, length( input.normalWS ) );

				float3 PositionWS = input.positionWS;
				float3 PositionRWS = GetCameraRelativePositionWS( input.positionWS );
				float4 ShadowCoord = shadowCoord;
				float4 ScreenPosNorm = float4( GetNormalizedScreenSpaceUV( input.positionCS ), input.positionCS.zw );
				float4 ClipPos = ComputeClipSpacePosition( ScreenPosNorm.xy, input.positionCS.z ) * input.positionCS.w;
				float4 ScreenPos = ComputeScreenPos( ClipPos );
				float3 TangentWS = input.tangentWS.xyz * renormFactor;
				float3 BitangentWS = cross( input.normalWS, input.tangentWS.xyz ) * input.tangentWS.w * renormFactor;
				float3 NormalWS = input.normalWS * renormFactor;

				#if defined( ENABLE_TERRAIN_PERPIXEL_NORMAL )
					float2 sampleCoords = (input.tangentWS.zw / _TerrainHeightmapRecipSize.zw + 0.5f) * _TerrainHeightmapRecipSize.xy;
					NormalWS = TransformObjectToWorldNormal(normalize(SAMPLE_TEXTURE2D(_TerrainNormalmapTexture, sampler_TerrainNormalmapTexture, sampleCoords).rgb * 2 - 1));
					TangentWS = -cross(GetObjectToWorldMatrix()._13_23_33, NormalWS);
					BitangentWS = cross(NormalWS, -TangentWS);
				#endif

				

				float3 Normal = float3(0, 0, 1);
				float Alpha = 1;
				#if defined( _ALPHATEST_ON )
					float AlphaClipThreshold = _Cutoff;
				#endif

				#if defined( ASE_DEPTH_WRITE_ON )
					input.positionCS.z = input.positionCS.z;
				#endif

				#if defined( _ALPHATEST_ON )
					AlphaDiscard( Alpha, AlphaClipThreshold );
				#endif

				#if defined(LOD_FADE_CROSSFADE)
					LODFadeCrossFade( input.positionCS );
				#endif

				#if defined( ASE_DEPTH_WRITE_ON )
					outputDepth = input.positionCS.z;
				#endif

				#if defined(_GBUFFER_NORMALS_OCT)
					float2 octNormalWS = PackNormalOctQuadEncode(NormalWS);
					float2 remappedOctNormalWS = saturate(octNormalWS * 0.5 + 0.5);
					half3 packedNormalWS = PackFloat2To888(remappedOctNormalWS);
					outNormalWS = half4(packedNormalWS, 0.0);
				#else
					#if defined(_NORMALMAP)
						#if _NORMAL_DROPOFF_TS
							float3 normalWS = TransformTangentToWorld(Normal, half3x3(TangentWS, BitangentWS, NormalWS));
						#elif _NORMAL_DROPOFF_OS
							float3 normalWS = TransformObjectToWorldNormal(Normal);
						#elif _NORMAL_DROPOFF_WS
							float3 normalWS = Normal;
						#endif
					#else
						float3 normalWS = NormalWS;
					#endif
					outNormalWS = half4(NormalizeNormalPerPixel(normalWS), 0.0);
				#endif

				#ifdef _WRITE_RENDERING_LAYERS
					uint renderingLayers = GetMeshRenderingLayer();
					outRenderingLayers = float4(EncodeMeshRenderingLayer(renderingLayers), 0, 0, 0);
				#endif
			}
			ENDHLSL
		}

		
		Pass
		{
			
			Name "GBuffer"
			Tags { "LightMode"="UniversalGBuffer" }

			Blend One Zero
			ZWrite On
			ZTest LEqual
			Offset 0 , 0
			ColorMask RGBA
			

			HLSLPROGRAM

			#define _SPECULAR_SETUP 1
			#define _NORMAL_DROPOFF_TS 1
			#pragma shader_feature_local_fragment _RECEIVE_SHADOWS_OFF
			#pragma shader_feature_local_fragment _ENVIRONMENTREFLECTIONS_OFF
			#pragma instancing_options renderinglayer
			#define ASE_FOG 1
			#pragma multi_compile_fragment _ DEBUG_DISPLAY
			#define _SPECULARHIGHLIGHTS_OFF
			#define ASE_LIGHTING_SIMPLE
			#define ASE_TERRAIN
			#pragma shader_feature _INSTANCEDTERRAINNORMALS_PIXEL
			#define ASE_VERSION 19908
			#define ASE_SRP_VERSION 170100


			// Deferred Rendering Path does not support the OpenGL-based graphics API:
			// Desktop OpenGL, OpenGL ES 3.0, WebGL 2.0.
			#pragma exclude_renderers glcore gles3 

			#pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
			#pragma multi_compile_fragment _ _REFLECTION_PROBE_BLENDING
			#pragma multi_compile_fragment _ _REFLECTION_PROBE_BOX_PROJECTION
			#pragma multi_compile_fragment _ _SHADOWS_SOFT _SHADOWS_SOFT_LOW _SHADOWS_SOFT_MEDIUM _SHADOWS_SOFT_HIGH
			#pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
			#pragma multi_compile_fragment _ _GBUFFER_NORMALS_OCT
			#pragma multi_compile_fragment _ _RENDER_PASS_ENABLED
			#pragma multi_compile _ _CLUSTER_LIGHT_LOOP

			#pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
			#pragma multi_compile _ _MIXED_LIGHTING_SUBTRACTIVE
			#pragma multi_compile _ SHADOWS_SHADOWMASK
			#pragma multi_compile _ DIRLIGHTMAP_COMBINED
			#pragma multi_compile _ USE_LEGACY_LIGHTMAPS
			#pragma multi_compile _ LIGHTMAP_ON
			#pragma multi_compile _ LIGHTMAP_BICUBIC_SAMPLING
			#pragma multi_compile _ DYNAMICLIGHTMAP_ON

			#pragma vertex vert
			#pragma fragment frag

			#if defined( _SPECULAR_SETUP ) && defined( ASE_LIGHTING_SIMPLE )
				#if defined( _SPECULARHIGHLIGHTS_OFF )
					#undef _SPECULAR_COLOR
				#else
					#define _SPECULAR_COLOR
				#endif
			#endif

			#define SHADERPASS SHADERPASS_GBUFFER

			#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
			#include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
			#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
			#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ProbeVolumeVariants.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			#if defined(LOD_FADE_CROSSFADE)
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/LODCrossFade.hlsl"
            #endif

			#if defined( UNITY_INSTANCING_ENABLED ) && defined( ASE_INSTANCED_TERRAIN ) && ( defined(_TERRAIN_INSTANCED_PERPIXEL_NORMAL) || defined(_INSTANCEDTERRAINNORMALS_PIXEL) )
				#define ENABLE_TERRAIN_PERPIXEL_NORMAL
			#endif

			#define ASE_NEEDS_FRAG_WORLD_VIEW_DIR
			#define ASE_NEEDS_TEXTURE_COORDINATES0
			#define ASE_NEEDS_VERT_TEXTURE_COORDINATES0
			#define ASE_NEEDS_FRAG_TEXTURE_COORDINATES0
			#define ASE_NEEDS_WORLD_TANGENT
			#define ASE_NEEDS_FRAG_WORLD_TANGENT
			#define ASE_NEEDS_WORLD_NORMAL
			#define ASE_NEEDS_FRAG_WORLD_NORMAL
			#define ASE_NEEDS_FRAG_WORLD_BITANGENT
			#define ASE_NEEDS_WORLD_POSITION
			#define ASE_NEEDS_FRAG_WORLD_POSITION
			#define ASE_NEEDS_FRAG_SCREEN_POSITION_NORMALIZED
			#define ASE_NEEDS_FRAG_SHADOWCOORDS
			#define ASE_NEEDS_VERT_TEXTURE_COORDINATES1
			#define ASE_INSTANCED_TERRAIN
			#define ASE_NEEDS_VERT_POSITION
			#define ASE_NEEDS_VERT_NORMAL
			#pragma shader_feature_local _ENABLESPECULARHIGHLIGHTS_ON
			#pragma multi_compile_fragment _ _REFLECTION_PROBE_ATLAS
			#pragma shader_feature_local _ENABLECOLORTINT_ON
			#pragma multi_compile_instancing
			#pragma instancing_options assumeuniformscaling nomatrices nolightprobe nolightmap
			#define TERRAIN_SPLAT_FIRSTPASS 1
			#pragma editor_sync_compilation
			#pragma multi_compile_local __ _ALPHATEST_ON
			#pragma shader_feature_local _MASKMAP


			#if defined(ASE_EARLY_Z_DEPTH_OPTIMIZE) && (SHADER_TARGET >= 45)
				#define ASE_SV_DEPTH SV_DepthLessEqual
				#define ASE_SV_POSITION_QUALIFIERS linear noperspective centroid
			#else
				#define ASE_SV_DEPTH SV_Depth
				#define ASE_SV_POSITION_QUALIFIERS
			#endif

			struct Attributes
			{
				float4 positionOS : POSITION;
				half3 normalOS : NORMAL;
				half4 tangentOS : TANGENT;
				float4 texcoord : TEXCOORD0;
				#if defined(LIGHTMAP_ON) || defined(ASE_NEEDS_TEXTURE_COORDINATES1)
					float4 texcoord1 : TEXCOORD1;
				#endif
				#if defined(DYNAMICLIGHTMAP_ON) || defined(ASE_NEEDS_TEXTURE_COORDINATES2)
					float4 texcoord2 : TEXCOORD2;
				#endif
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct PackedVaryings
			{
				ASE_SV_POSITION_QUALIFIERS float4 positionCS : SV_POSITION;
				float3 positionWS : TEXCOORD0;
				half3 normalWS : TEXCOORD1;
				float4 tangentWS : TEXCOORD2; // holds terrainUV ifdef ENABLE_TERRAIN_PERPIXEL_NORMAL
				float4 lightmapUVOrVertexSH : TEXCOORD3;
				#if defined(ASE_FOG) || defined(_ADDITIONAL_LIGHTS_VERTEX)
					half4 fogFactorAndVertexLight : TEXCOORD4;
				#endif
				#if defined(DYNAMICLIGHTMAP_ON)
					float2 dynamicLightmapUV : TEXCOORD5;
				#endif
				#if defined(USE_APV_PROBE_OCCLUSION)
					float4 probeOcclusion : TEXCOORD6;
				#endif
				float4 ase_texcoord7 : TEXCOORD7;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _Splat0_ST;
			float4 _TerrainHolesTexture_ST;
			float4 _BaseTint;
			float4 _Splat3_ST;
			float4 _SpecularTint1;
			float4 _Splat1_ST;
			float4 _Control_ST;
			float4 _Splat2_ST;
			float _NormalScale;
			float _SpecularOcclusion;
			float _IndirectSpecularContribution1;
			float _RampOffset;
			float _SpecularIntensity;
			float _SpecularSize1;
			float _SpecularSmoothness1;
			float _RampScale;
			float _Occlusion1;
			float _AlphaClip;
			float _Cutoff;
			#ifdef ASE_TRANSMISSION
				float _TransmissionShadow;
			#endif
			#ifdef ASE_TRANSLUCENCY
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
			#ifdef ASE_TESSELLATION
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END

			#ifdef SCENEPICKINGPASS
				float4 _SelectionID;
			#endif

			#ifdef SCENESELECTIONPASS
				int _ObjectId;
				int _PassValue;
			#endif

			sampler2D _Normal0;
			sampler2D _Splat0;
			sampler2D _Control;
			sampler2D _Normal1;
			sampler2D _Splat1;
			sampler2D _Normal2;
			sampler2D _Splat2;
			sampler2D _Normal3;
			sampler2D _Splat3;
			sampler2D _TerrainHolesTexture;
			sampler2D _TextureRamp3;
			#ifdef UNITY_INSTANCING_ENABLED//ASE Terrain Instancing
				TEXTURE2D(_TerrainHeightmapTexture);//ASE Terrain Instancing
				TEXTURE2D( _TerrainNormalmapTexture);//ASE Terrain Instancing
				SAMPLER(sampler_TerrainNormalmapTexture);//ASE Terrain Instancing
			#endif//ASE Terrain Instancing
			UNITY_INSTANCING_BUFFER_START( Terrain )//ASE Terrain Instancing
				UNITY_DEFINE_INSTANCED_PROP( float4, _TerrainPatchInstanceData )//ASE Terrain Instancing
			UNITY_INSTANCING_BUFFER_END( Terrain)//ASE Terrain Instancing
			CBUFFER_START( UnityTerrain)//ASE Terrain Instancing
				#ifdef UNITY_INSTANCING_ENABLED//ASE Terrain Instancing
					float4 _TerrainHeightmapRecipSize;//ASE Terrain Instancing
					float4 _TerrainHeightmapScale;//ASE Terrain Instancing
				#endif//ASE Terrain Instancing
			CBUFFER_END//ASE Terrain Instancing


			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/GBufferOutput.hlsl"

			half4 CalculateShadowMask343_g61170(  )
			{
				#if defined(SHADOWS_SHADOWMASK) && defined(LIGHTMAP_ON)
				half4 shadowMask = inputData.shadowMask;
				#elif !defined (LIGHTMAP_ON)
				half4 shadowMask = unity_ProbesOcclusion;
				#else
				half4 shadowMask = half4(1, 1, 1, 1);
				#endif
				return shadowMask;
			}
			
			float3 AdditionalLightsLambertMask171x( float3 WorldPosition, float2 ScreenUV, float3 WorldNormal, float4 ShadowMask )
			{
				float3 Color = 0;
				#if defined(_ADDITIONAL_LIGHTS)
					#define SUM_LIGHTLAMBERT(Light)\
						half3 AttLightColor = Light.color * ( Light.distanceAttenuation * Light.shadowAttenuation );\
						Color += LightingLambert( AttLightColor, Light.direction, WorldNormal );
					InputData inputData = (InputData)0;
					inputData.normalizedScreenSpaceUV = ScreenUV;
					inputData.positionWS = WorldPosition;
					uint meshRenderingLayers = GetMeshRenderingLayer();
					uint pixelLightCount = GetAdditionalLightsCount();	
					#if USE_CLUSTER_LIGHT_LOOP
					[loop] for (uint lightIndex = 0; lightIndex < min(URP_FP_DIRECTIONAL_LIGHTS_COUNT, MAX_VISIBLE_LIGHTS); lightIndex++)
					{
						CLUSTER_LIGHT_LOOP_SUBTRACTIVE_LIGHT_CHECK
						Light light = GetAdditionalLight(lightIndex, WorldPosition, ShadowMask);
						#ifdef _LIGHT_LAYERS
						if (IsMatchingLightLayer(light.layerMask, meshRenderingLayers))
						#endif
						{
							SUM_LIGHTLAMBERT( light );
						}
					}
					#endif
					
					LIGHT_LOOP_BEGIN( pixelLightCount )
						Light light = GetAdditionalLight(lightIndex, WorldPosition, ShadowMask);
						#ifdef _LIGHT_LAYERS
						if (IsMatchingLightLayer(light.layerMask, meshRenderingLayers))
						#endif
						{
							SUM_LIGHTLAMBERT( light );
						}
					LIGHT_LOOP_END
				#endif
				return Color;
			}
			
			half3 ASEIndirectDiffuse( PackedVaryings input, half3 normalWS, float3 positionWS, half3 viewDirWS )
			{
			#if defined( DYNAMICLIGHTMAP_ON )
				return SAMPLE_GI( input.lightmapUVOrVertexSH.xy, input.dynamicLightmapUV.xy, 0, normalWS );
			#elif defined( LIGHTMAP_ON )
				return SAMPLE_GI( input.lightmapUVOrVertexSH.xy, 0, normalWS );
			#elif defined( PROBE_VOLUMES_L1 ) || defined( PROBE_VOLUMES_L2 )
				return SampleProbeVolumePixel( SampleSH( normalWS ), positionWS, normalWS, viewDirWS, input.positionCS.xy );
			#else
				return SampleSH( normalWS );
			#endif
			}
			
			half4 CalculateShadowMask343_g61167(  )
			{
				#if defined(SHADOWS_SHADOWMASK) && defined(LIGHTMAP_ON)
				half4 shadowMask = inputData.shadowMask;
				#elif !defined (LIGHTMAP_ON)
				half4 shadowMask = unity_ProbesOcclusion;
				#else
				half4 shadowMask = half4(1, 1, 1, 1);
				#endif
				return shadowMask;
			}
			
			void TerrainApplyMeshModification( inout float3 position, inout half3 normal, inout float4 texcoord )
			{
			#ifdef UNITY_INSTANCING_ENABLED
				float2 patchVertex = position.xy;
				float4 instanceData = UNITY_ACCESS_INSTANCED_PROP( Terrain, _TerrainPatchInstanceData );
				float2 sampleCoords = ( patchVertex.xy + instanceData.xy ) * instanceData.z;
				float height = UnpackHeightmap( _TerrainHeightmapTexture.Load( int3( sampleCoords, 0 ) ) );
				position.xz = sampleCoords* _TerrainHeightmapScale.xz;
				position.y = height* _TerrainHeightmapScale.y;
				#ifdef ENABLE_TERRAIN_PERPIXEL_NORMAL
					normal = float3(0, 1, 0);
				#else
					normal = _TerrainNormalmapTexture.Load(int3(sampleCoords, 0)).rgb* 2 - 1;
				#endif
				texcoord.xy = sampleCoords* _TerrainHeightmapRecipSize.zw;
			#endif
			}
			

			PackedVaryings VertexFunction( Attributes input  )
			{
				PackedVaryings output = (PackedVaryings)0;
				UNITY_SETUP_INSTANCE_ID(input);
				UNITY_TRANSFER_INSTANCE_ID(input, output);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(output);

				#if defined( ASE_INSTANCED_TERRAIN ) && !defined( ASE_TESSELLATION )
					TerrainApplyMeshModification( input.positionOS.xyz, input.normalOS, input.texcoord );
				#endif
				
				float2 break956_g61173 = _Control_ST.zw;
				float2 appendResult959_g61173 = (float2(( break956_g61173.x + 0.001 ) , ( break956_g61173.y + 0.0001 )));
				float2 vertexToFrag961_g61173 = ( ( input.texcoord.xy * _Control_ST.xy ) + appendResult959_g61173 );
				output.ase_texcoord7.zw = vertexToFrag961_g61173;
				
				output.ase_texcoord7.xy = input.texcoord.xy;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = input.positionOS.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = defaultVertexValue;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					input.positionOS.xyz = vertexValue;
				#else
					input.positionOS.xyz += vertexValue;
				#endif

				input.normalOS = input.normalOS;
				input.tangentOS = input.tangentOS;

				VertexPositionInputs vertexInput = GetVertexPositionInputs( input.positionOS.xyz );
				VertexNormalInputs normalInput = GetVertexNormalInputs( input.normalOS, input.tangentOS );

				OUTPUT_LIGHTMAP_UV(input.texcoord1, unity_LightmapST, output.lightmapUVOrVertexSH.xy);
				#if defined(DYNAMICLIGHTMAP_ON)
					output.dynamicLightmapUV.xy = input.texcoord2.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
				#endif
				OUTPUT_SH4(vertexInput.positionWS, normalInput.normalWS.xyz, GetWorldSpaceNormalizeViewDir(vertexInput.positionWS), output.lightmapUVOrVertexSH.xyz, output.probeOcclusion);

				#if defined(ASE_FOG) || defined(_ADDITIONAL_LIGHTS_VERTEX)
					output.fogFactorAndVertexLight = 0;
					#if defined(ASE_FOG) && !defined(_FOG_FRAGMENT)
						// @diogo: no fog applied in GBuffer
					#endif
					#ifdef _ADDITIONAL_LIGHTS_VERTEX
						half3 vertexLight = VertexLighting( vertexInput.positionWS, normalInput.normalWS );
						output.fogFactorAndVertexLight.yzw = vertexLight;
					#endif
				#endif

				output.positionCS = vertexInput.positionCS;
				output.positionWS = vertexInput.positionWS;
				output.normalWS = normalInput.normalWS;
				output.tangentWS = float4( normalInput.tangentWS, ( input.tangentOS.w > 0.0 ? 1.0 : -1.0 ) * GetOddNegativeScale() );

				#if defined( ENABLE_TERRAIN_PERPIXEL_NORMAL )
					output.tangentWS.zw = input.texcoord.xy;
					output.tangentWS.xy = input.texcoord.xy * unity_LightmapST.xy + unity_LightmapST.zw;
				#endif
				return output;
			}

			#if defined(ASE_TESSELLATION)
			struct VertexControl
			{
				float4 positionOS : INTERNALTESSPOS;
				half3 normalOS : NORMAL;
				half4 tangentOS : TANGENT;
				float4 texcoord : TEXCOORD0;
				#if defined(LIGHTMAP_ON) || defined(ASE_NEEDS_TEXTURE_COORDINATES1)
					float4 texcoord1 : TEXCOORD1;
				#endif
				#if defined(DYNAMICLIGHTMAP_ON) || defined(ASE_NEEDS_TEXTURE_COORDINATES2)
					float4 texcoord2 : TEXCOORD2;
				#endif
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( Attributes input )
			{
				VertexControl output;
				UNITY_SETUP_INSTANCE_ID(input);
				UNITY_TRANSFER_INSTANCE_ID(input, output);
				output.positionOS = input.positionOS;
				output.normalOS = input.normalOS;
				output.tangentOS = input.tangentOS;
				output.texcoord = input.texcoord;
				#if defined(LIGHTMAP_ON) || defined(ASE_NEEDS_TEXTURE_COORDINATES1)
					output.texcoord1 = input.texcoord1;
				#endif
				#if defined(DYNAMICLIGHTMAP_ON) || defined(ASE_NEEDS_TEXTURE_COORDINATES2)
					output.texcoord2 = input.texcoord2;
				#endif
				#if defined( ASE_INSTANCED_TERRAIN )
					TerrainApplyMeshModification( output.positionOS.xyz, output.normalOS, output.texcoord );
				#endif
				
				return output;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> input)
			{
				TessellationFactors output;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(input[0].positionOS, input[1].positionOS, input[2].positionOS, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(input[0].positionOS, input[1].positionOS, input[2].positionOS, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(input[0].positionOS, input[1].positionOS, input[2].positionOS, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				output.edge[0] = tf.x; output.edge[1] = tf.y; output.edge[2] = tf.z; output.inside = tf.w;
				return output;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
				return patch[id];
			}

			[domain("tri")]
			PackedVaryings DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				Attributes output = (Attributes) 0;
				output.positionOS = patch[0].positionOS * bary.x + patch[1].positionOS * bary.y + patch[2].positionOS * bary.z;
				output.normalOS = patch[0].normalOS * bary.x + patch[1].normalOS * bary.y + patch[2].normalOS * bary.z;
				output.tangentOS = patch[0].tangentOS * bary.x + patch[1].tangentOS * bary.y + patch[2].tangentOS * bary.z;
				output.texcoord = patch[0].texcoord * bary.x + patch[1].texcoord * bary.y + patch[2].texcoord * bary.z;
				#if defined(LIGHTMAP_ON) || defined(ASE_NEEDS_TEXTURE_COORDINATES1)
					output.texcoord1 = patch[0].texcoord1 * bary.x + patch[1].texcoord1 * bary.y + patch[2].texcoord1 * bary.z;
				#endif
				#if defined(DYNAMICLIGHTMAP_ON) || defined(ASE_NEEDS_TEXTURE_COORDINATES2)
					output.texcoord2 = patch[0].texcoord2 * bary.x + patch[1].texcoord2 * bary.y + patch[2].texcoord2 * bary.z;
				#endif
				
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = output.positionOS.xyz - patch[i].normalOS * (dot(output.positionOS.xyz, patch[i].normalOS) - dot(patch[i].positionOS.xyz, patch[i].normalOS));
				float phongStrength = _TessPhongStrength;
				output.positionOS.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * output.positionOS.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], output);
				return VertexFunction(output);
			}
			#else
			PackedVaryings vert ( Attributes input )
			{
				return VertexFunction( input );
			}
			#endif

			GBufferFragOutput frag ( PackedVaryings input
								#if defined( ASE_DEPTH_WRITE_ON )
								,out float outputDepth : ASE_SV_DEPTH
								#endif
								 )
			{
				UNITY_SETUP_INSTANCE_ID(input);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input);

				#if defined(LOD_FADE_CROSSFADE)
					LODFadeCrossFade( input.positionCS );
				#endif

				#if defined(MAIN_LIGHT_CALCULATE_SHADOWS)
					float4 shadowCoord = TransformWorldToShadowCoord( input.positionWS );
				#else
					float4 shadowCoord = float4(0, 0, 0, 0);
				#endif

				// @diogo: mikktspace compliant
				float renormFactor = 1.0 / max( FLT_MIN, length( input.normalWS ) );

				float3 PositionWS = input.positionWS;
				float3 PositionRWS = GetCameraRelativePositionWS( PositionWS );
				float3 ViewDirWS = GetWorldSpaceNormalizeViewDir( PositionWS );
				float4 ShadowCoord = shadowCoord;
				float4 ScreenPosNorm = float4( GetNormalizedScreenSpaceUV( input.positionCS ), input.positionCS.zw );
				float4 ClipPos = ComputeClipSpacePosition( ScreenPosNorm.xy, input.positionCS.z ) * input.positionCS.w;
				float4 ScreenPos = ComputeScreenPos( ClipPos );
				float3 TangentWS = input.tangentWS.xyz * renormFactor;
				float3 BitangentWS = cross( input.normalWS, input.tangentWS.xyz ) * input.tangentWS.w * renormFactor;
				float3 NormalWS = input.normalWS * renormFactor;

				#if defined( ENABLE_TERRAIN_PERPIXEL_NORMAL )
					float2 sampleCoords = (input.tangentWS.zw / _TerrainHeightmapRecipSize.zw + 0.5f) * _TerrainHeightmapRecipSize.xy;
					NormalWS = TransformObjectToWorldNormal(normalize(SAMPLE_TEXTURE2D(_TerrainNormalmapTexture, sampler_TerrainNormalmapTexture, sampleCoords).rgb * 2 - 1));
					TangentWS = -cross(GetObjectToWorldMatrix()._13_23_33, NormalWS);
					BitangentWS = cross(NormalWS, -TangentWS);
				#endif

				float3 temp_cast_0 = (1.0).xxx;
				float4 ControlFinal724_g61173 = float4( 1, 1, 1, 1 );
				float2 uv_Splat0 = input.ase_texcoord7.xy * _Splat0_ST.xy + _Splat0_ST.zw;
				float4 tex2DNode2_g61173 = tex2D( _Normal0, uv_Splat0 );
				float _HeightA279_g61173 = tex2DNode2_g61173.a;
				float smoothstepResult810_g61173 = smoothstep( 0.0 , 1.0 , _HeightA279_g61173);
				float clampResult933_g61173 = clamp( smoothstepResult810_g61173 , 0.001 , 0.999 );
				float2 vertexToFrag961_g61173 = input.ase_texcoord7.zw;
				float4 tex2DNode5_g61173 = tex2D( _Control, vertexToFrag961_g61173 );
				float _MaskA481_g61173 = tex2DNode5_g61173.r;
				float clampResult830_g61173 = clamp( _MaskA481_g61173 , 0.0 , 1.0 );
				float temp_output_829_0_g61173 = ( clampResult933_g61173 * clampResult830_g61173 );
				float3 break635_g61173 = tex2DNode2_g61173.rgb;
				float2 appendResult655_g61173 = (float2(( ( break635_g61173.x * 2.0 ) - 1.0 ) , ( ( break635_g61173.y * 2.0 ) - 1.0 )));
				float3 appendResult656_g61173 = (float3(appendResult655_g61173 , sqrt( max( 0.0, ( 1.0 - ( ( break635_g61173.x * break635_g61173.x ) + ( break635_g61173.y * break635_g61173.y ) ) ) ) )));
				float3 _UnpackedNormalA720_g61173 = appendResult656_g61173;
				float2 uv_Splat1 = input.ase_texcoord7.xy * _Splat1_ST.xy + _Splat1_ST.zw;
				float4 tex2DNode1_g61173 = tex2D( _Normal1, uv_Splat1 );
				float _HeightB280_g61173 = tex2DNode1_g61173.a;
				float smoothstepResult812_g61173 = smoothstep( 0.0 , 1.0 , _HeightB280_g61173);
				float clampResult934_g61173 = clamp( smoothstepResult812_g61173 , 0.001 , 0.999 );
				float _MaskB482_g61173 = tex2DNode5_g61173.g;
				float clampResult832_g61173 = clamp( _MaskB482_g61173 , 0.0 , 1.0 );
				float temp_output_826_0_g61173 = ( clampResult934_g61173 * clampResult832_g61173 );
				float3 break657_g61173 = tex2DNode1_g61173.rgb;
				float2 appendResult664_g61173 = (float2(( ( break657_g61173.x * 2.0 ) - 1.0 ) , ( ( break657_g61173.y * 2.0 ) - 1.0 )));
				float3 appendResult673_g61173 = (float3(appendResult664_g61173 , sqrt( max( 0.0, ( 1.0 - ( ( break657_g61173.x * break657_g61173.x ) + ( break657_g61173.y * break657_g61173.y ) ) ) ) )));
				float3 _UnpackedNormalB721_g61173 = appendResult673_g61173;
				float2 uv_Splat2 = input.ase_texcoord7.xy * _Splat2_ST.xy + _Splat2_ST.zw;
				float4 tex2DNode10_g61173 = tex2D( _Normal2, uv_Splat2 );
				float _HeightC281_g61173 = tex2DNode10_g61173.a;
				float smoothstepResult811_g61173 = smoothstep( 0.0 , 1.0 , _HeightC281_g61173);
				float clampResult935_g61173 = clamp( smoothstepResult811_g61173 , 0.001 , 0.999 );
				float _MaskC483_g61173 = tex2DNode5_g61173.b;
				float clampResult831_g61173 = clamp( _MaskC483_g61173 , 0.0 , 1.0 );
				float temp_output_827_0_g61173 = ( clampResult935_g61173 * clampResult831_g61173 );
				float3 break676_g61173 = tex2DNode10_g61173.rgb;
				float2 appendResult683_g61173 = (float2(( ( break676_g61173.x * 2.0 ) - 1.0 ) , ( ( break676_g61173.y * 2.0 ) - 1.0 )));
				float3 appendResult692_g61173 = (float3(appendResult683_g61173 , sqrt( max( 0.0, ( 1.0 - ( ( break676_g61173.x * break676_g61173.x ) + ( break676_g61173.y * break676_g61173.y ) ) ) ) )));
				float3 _UnpackedNormalC722_g61173 = appendResult692_g61173;
				float2 uv_Splat3 = input.ase_texcoord7.xy * _Splat3_ST.xy + _Splat3_ST.zw;
				float4 tex2DNode11_g61173 = tex2D( _Normal3, uv_Splat3 );
				float _HeightD282_g61173 = tex2DNode11_g61173.a;
				float smoothstepResult813_g61173 = smoothstep( 0.0 , 1.0 , _HeightD282_g61173);
				float clampResult936_g61173 = clamp( smoothstepResult813_g61173 , 0.001 , 0.999 );
				float _MaskD484_g61173 = tex2DNode5_g61173.a;
				float clampResult833_g61173 = clamp( _MaskD484_g61173 , 0.0 , 1.0 );
				float temp_output_828_0_g61173 = ( clampResult936_g61173 * clampResult833_g61173 );
				float3 break695_g61173 = tex2DNode11_g61173.rgb;
				float2 appendResult702_g61173 = (float2(( ( break695_g61173.x * 2.0 ) - 1.0 ) , ( ( break695_g61173.y * 2.0 ) - 1.0 )));
				float3 appendResult711_g61173 = (float3(appendResult702_g61173 , sqrt( max( 0.0, ( 1.0 - ( ( break695_g61173.x * break695_g61173.x ) + ( break695_g61173.y * break695_g61173.y ) ) ) ) )));
				float3 _UnpackedNormalD723_g61173 = appendResult711_g61173;
				float4 weightedBlendVar840_g61173 = ControlFinal724_g61173;
				float3 weightedBlend840_g61173 = ( weightedBlendVar840_g61173.x*( temp_output_829_0_g61173 * _UnpackedNormalA720_g61173 ) + weightedBlendVar840_g61173.y*( temp_output_826_0_g61173 * _UnpackedNormalB721_g61173 ) + weightedBlendVar840_g61173.z*( temp_output_827_0_g61173 * _UnpackedNormalC722_g61173 ) + weightedBlendVar840_g61173.w*( temp_output_828_0_g61173 * _UnpackedNormalD723_g61173 ) );
				float4 weightedBlendVar841_g61173 = ControlFinal724_g61173;
				float weightedBlend841_g61173 = ( weightedBlendVar841_g61173.x*temp_output_829_0_g61173 + weightedBlendVar841_g61173.y*temp_output_826_0_g61173 + weightedBlendVar841_g61173.z*temp_output_827_0_g61173 + weightedBlendVar841_g61173.w*temp_output_828_0_g61173 );
				float3 FinalNormal765_g61173 = ( weightedBlend840_g61173 / max( weightedBlend841_g61173, 0.001 ) );
				float3 temp_output_61_0_g61173 = FinalNormal765_g61173;
				float3 Normal554 = temp_output_61_0_g61173;
				float3 tanToWorld0 = float3( TangentWS.x, BitangentWS.x, NormalWS.x );
				float3 tanToWorld1 = float3( TangentWS.y, BitangentWS.y, NormalWS.y );
				float3 tanToWorld2 = float3( TangentWS.z, BitangentWS.z, NormalWS.z );
				float3 tanNormal638 = ( Normal554 * _NormalScale );
				float3 worldNormal638 = normalize( float3( dot( tanToWorld0, tanNormal638 ), dot( tanToWorld1, tanNormal638 ), dot( tanToWorld2, tanNormal638 ) ) );
				float3 normalizeResult640 = normalize( worldNormal638 );
				float3 Normals780 = normalizeResult640;
				float smoothstepResult859_g61173 = smoothstep( 0.0 , 1.0 , _HeightA279_g61173);
				float clampResult937_g61173 = clamp( smoothstepResult859_g61173 , 0.001 , 0.999 );
				float clampResult879_g61173 = clamp( _MaskA481_g61173 , 0.0 , 1.0 );
				float temp_output_878_0_g61173 = ( clampResult937_g61173 * clampResult879_g61173 );
				float4 tex2DNode4_g61173 = tex2D( _Splat0, uv_Splat0 );
				float _LayerAlphaA778_g61173 = tex2DNode4_g61173.a;
				float smoothstepResult861_g61173 = smoothstep( 0.0 , 1.0 , _HeightB280_g61173);
				float clampResult938_g61173 = clamp( smoothstepResult861_g61173 , 0.001 , 0.999 );
				float clampResult881_g61173 = clamp( _MaskB482_g61173 , 0.0 , 1.0 );
				float temp_output_875_0_g61173 = ( clampResult938_g61173 * clampResult881_g61173 );
				float4 tex2DNode3_g61173 = tex2D( _Splat1, uv_Splat1 );
				float _LayerAlphaB779_g61173 = tex2DNode3_g61173.a;
				float smoothstepResult860_g61173 = smoothstep( 0.0 , 1.0 , _HeightC281_g61173);
				float clampResult939_g61173 = clamp( smoothstepResult860_g61173 , 0.001 , 0.999 );
				float clampResult880_g61173 = clamp( _MaskC483_g61173 , 0.0 , 1.0 );
				float temp_output_876_0_g61173 = ( clampResult939_g61173 * clampResult880_g61173 );
				float4 tex2DNode6_g61173 = tex2D( _Splat2, uv_Splat2 );
				float _LayerAlphaC780_g61173 = tex2DNode6_g61173.a;
				float smoothstepResult862_g61173 = smoothstep( 0.0 , 1.0 , _HeightD282_g61173);
				float clampResult940_g61173 = clamp( smoothstepResult862_g61173 , 0.001 , 0.999 );
				float clampResult882_g61173 = clamp( _MaskD484_g61173 , 0.0 , 1.0 );
				float temp_output_877_0_g61173 = ( clampResult940_g61173 * clampResult882_g61173 );
				float4 tex2DNode7_g61173 = tex2D( _Splat3, uv_Splat3 );
				float _LayerAlphaD781_g61173 = tex2DNode7_g61173.a;
				float4 weightedBlendVar887_g61173 = ControlFinal724_g61173;
				float weightedBlend887_g61173 = ( weightedBlendVar887_g61173.x*( temp_output_878_0_g61173 * _LayerAlphaA778_g61173 ) + weightedBlendVar887_g61173.y*( temp_output_875_0_g61173 * _LayerAlphaB779_g61173 ) + weightedBlendVar887_g61173.z*( temp_output_876_0_g61173 * _LayerAlphaC780_g61173 ) + weightedBlendVar887_g61173.w*( temp_output_877_0_g61173 * _LayerAlphaD781_g61173 ) );
				float4 weightedBlendVar888_g61173 = ControlFinal724_g61173;
				float weightedBlend888_g61173 = ( weightedBlendVar888_g61173.x*temp_output_878_0_g61173 + weightedBlendVar888_g61173.y*temp_output_875_0_g61173 + weightedBlendVar888_g61173.z*temp_output_876_0_g61173 + weightedBlendVar888_g61173.w*temp_output_877_0_g61173 );
				float FinalSmoothness897_g61173 = ( weightedBlend887_g61173 / max( weightedBlend888_g61173, 0.001 ) );
				float Smoothness533 = FinalSmoothness897_g61173;
				half3 reflectVector772 = reflect( -ViewDirWS, Normals780 );
				float3 indirectSpecular772 = GlossyEnvironmentReflection( reflectVector772, PositionWS, 1.0 - Smoothness533, _SpecularOcclusion, ScreenPosNorm.xy );
				float3 lerpResult643 = lerp( temp_cast_0 , indirectSpecular772 , _IndirectSpecularContribution1);
				float3 IndirectSpecHighlights793 = lerpResult643;
				float4 temp_output_751_0 = ( _SpecularTint1 * Smoothness533 * _SpecularIntensity );
				float3 normalizeResult4_g61169 = normalize( ( ViewDirWS + SafeNormalize( _MainLightPosition.xyz ) ) );
				float dotResult749 = dot( normalizeResult4_g61169 , Normals780 );
				float3 WorldPosition288_g61170 = PositionWS;
				float3 WorldPosition337_g61170 = WorldPosition288_g61170;
				float2 ScreenUV286_g61170 = (ScreenPosNorm).xy;
				float2 ScreenUV337_g61170 = ScreenUV286_g61170;
				float3 WorldNormal281_g61170 = Normals780;
				float3 WorldNormal337_g61170 = WorldNormal281_g61170;
				half4 localCalculateShadowMask343_g61170 = CalculateShadowMask343_g61170();
				float4 ShadowMask360_g61170 = localCalculateShadowMask343_g61170;
				float4 ShadowMask337_g61170 = ShadowMask360_g61170;
				float3 localAdditionalLightsLambertMask171x337_g61170 = AdditionalLightsLambertMask171x( WorldPosition337_g61170 , ScreenUV337_g61170 , WorldNormal337_g61170 , ShadowMask337_g61170 );
				float4 DirectSpecHighlights764 = ( float4( (temp_output_751_0).rgb , 0.0 ) * saturate( ( float4( (  (-1.0 + ( _SpecularSize1 - 0.0 ) * ( -0.5 - -1.0 ) / ( 1.0 - 0.0 ) ) + ( dotResult749 + saturate( localAdditionalLightsLambertMask171x337_g61170 ) ) ) , 0.0 ) / ( ( 1.0 - temp_output_751_0 ) * _SpecularSmoothness1 ) ) ) );
				float ase_lightIntensity = max( max( _MainLightColor.r, _MainLightColor.g ), _MainLightColor.b ) + 1e-7;
				float4 ase_lightColor = float4( _MainLightColor.rgb / ase_lightIntensity, ase_lightIntensity );
				float ase_lightAtten = 0;
				Light ase_mainLight = GetMainLight( ShadowCoord );
				ase_lightAtten = ase_mainLight.distanceAttenuation * ase_mainLight.shadowAttenuation;
				float3 bakedGI730 = ASEIndirectDiffuse( input, NormalWS, PositionWS, ViewDirWS );
				MixRealtimeAndBakedGI( ase_mainLight, NormalWS, bakedGI730, half4( 0, 0, 0, 0 ) );
				float4 HalfLambert733 = ( ( ase_lightColor * ase_lightAtten ) + float4( bakedGI730 , 0.0 ) );
				float4 SpecularHighlights768 = ( float4( IndirectSpecHighlights793 , 0.0 ) * DirectSpecHighlights764 * HalfLambert733 );
				#ifdef _ENABLESPECULARHIGHLIGHTS_ON
				float4 staticSwitch763 = SpecularHighlights768;
				#else
				float4 staticSwitch763 = float4( 0,0,0,0 );
				#endif
				float4 color648 = IsGammaSpace() ? float4( 1, 1, 1, 1 ) : float4( 1, 1, 1, 1 );
				#ifdef _ENABLECOLORTINT_ON
				float4 staticSwitch774 = _BaseTint;
				#else
				float4 staticSwitch774 = color648;
				#endif
				float smoothstepResult591_g61173 = smoothstep( 0.0 , 1.0 , _HeightA279_g61173);
				float clampResult944_g61173 = clamp( smoothstepResult591_g61173 , 0.001 , 0.999 );
				float clampResult603_g61173 = clamp( _MaskA481_g61173 , 0.0 , 1.0 );
				float temp_output_597_0_g61173 = ( clampResult944_g61173 * clampResult603_g61173 );
				float4 _LayerA287_g61173 = tex2DNode4_g61173;
				float smoothstepResult594_g61173 = smoothstep( 0.0 , 1.0 , _HeightB280_g61173);
				float clampResult943_g61173 = clamp( smoothstepResult594_g61173 , 0.001 , 0.999 );
				float clampResult604_g61173 = clamp( _MaskB482_g61173 , 0.0 , 1.0 );
				float temp_output_598_0_g61173 = ( clampResult943_g61173 * clampResult604_g61173 );
				float4 _LayerB300_g61173 = tex2DNode3_g61173;
				float smoothstepResult595_g61173 = smoothstep( 0.0 , 1.0 , _HeightC281_g61173);
				float clampResult942_g61173 = clamp( smoothstepResult595_g61173 , 0.001 , 0.999 );
				float clampResult605_g61173 = clamp( _MaskC483_g61173 , 0.0 , 1.0 );
				float temp_output_599_0_g61173 = ( clampResult942_g61173 * clampResult605_g61173 );
				float4 _LayerC301_g61173 = tex2DNode6_g61173;
				float smoothstepResult596_g61173 = smoothstep( 0.0 , 1.0 , _HeightD282_g61173);
				float clampResult941_g61173 = clamp( smoothstepResult596_g61173 , 0.001 , 0.999 );
				float clampResult606_g61173 = clamp( _MaskD484_g61173 , 0.0 , 1.0 );
				float temp_output_600_0_g61173 = ( clampResult941_g61173 * clampResult606_g61173 );
				float4 _LayerD302_g61173 = tex2DNode7_g61173;
				float4 weightedBlendVar619_g61173 = ControlFinal724_g61173;
				float4 weightedBlend619_g61173 = ( weightedBlendVar619_g61173.x*( temp_output_597_0_g61173 * _LayerA287_g61173 ) + weightedBlendVar619_g61173.y*( temp_output_598_0_g61173 * _LayerB300_g61173 ) + weightedBlendVar619_g61173.z*( temp_output_599_0_g61173 * _LayerC301_g61173 ) + weightedBlendVar619_g61173.w*( temp_output_600_0_g61173 * _LayerD302_g61173 ) );
				float4 weightedBlendVar620_g61173 = ControlFinal724_g61173;
				float weightedBlend620_g61173 = ( weightedBlendVar620_g61173.x*temp_output_597_0_g61173 + weightedBlendVar620_g61173.y*temp_output_598_0_g61173 + weightedBlendVar620_g61173.z*temp_output_599_0_g61173 + weightedBlendVar620_g61173.w*temp_output_600_0_g61173 );
				float4 FinalAlbedo479_g61173 = ( weightedBlend619_g61173 / max( weightedBlend620_g61173, 0.001 ) );
				float4 temp_output_60_0_g61173 = FinalAlbedo479_g61173;
				float4 localClipHoles100_g61173 = ( temp_output_60_0_g61173 );
				float2 uv_TerrainHolesTexture = input.ase_texcoord7.xy * _TerrainHolesTexture_ST.xy + _TerrainHolesTexture_ST.zw;
				float holeClipValue99_g61173 = tex2D( _TerrainHolesTexture, uv_TerrainHolesTexture ).r;
				float Hole100_g61173 = holeClipValue99_g61173;
				{
				#ifdef _ALPHATEST_ON
				clip(Hole100_g61173 == 0.0f ? -1 : 1);
				#endif
				}
				float4 Albedo536 = localClipHoles100_g61173;
				float dotResult723 = dot( Normals780 , SafeNormalize( _MainLightPosition.xyz ) );
				float RampScale743 = _RampScale;
				float RampOffset742 = _RampOffset;
				float CEL_Effect664 = saturate( (dotResult723*RampScale743 + RampOffset742) );
				float2 temp_cast_6 = (CEL_Effect664).xx;
				float3 WorldPosition288_g61167 = PositionWS;
				float3 WorldPosition337_g61167 = WorldPosition288_g61167;
				float2 ScreenUV286_g61167 = (ScreenPosNorm).xy;
				float2 ScreenUV337_g61167 = ScreenUV286_g61167;
				float3 WorldNormal281_g61167 = Normals780;
				float3 WorldNormal337_g61167 = WorldNormal281_g61167;
				half4 localCalculateShadowMask343_g61167 = CalculateShadowMask343_g61167();
				float4 ShadowMask360_g61167 = localCalculateShadowMask343_g61167;
				float4 ShadowMask337_g61167 = ShadowMask360_g61167;
				float3 localAdditionalLightsLambertMask171x337_g61167 = AdditionalLightsLambertMask171x( WorldPosition337_g61167 , ScreenUV337_g61167 , WorldNormal337_g61167 , ShadowMask337_g61167 );
				

				float3 BaseColor = ( staticSwitch763 + ( staticSwitch774 * ( ( ( Albedo536 * tex2D( _TextureRamp3, temp_cast_6 ) ) * HalfLambert733 ) + ( Albedo536 * tex2D( _TextureRamp3, (saturate( localAdditionalLightsLambertMask171x337_g61167 )*RampScale743 + RampOffset742).xy ) ) ) ) ).rgb;
				float3 Normal = float3(0, 0, 1);
				float3 Specular = 0.5;
				float Metallic = 0;
				float Smoothness = 0.5;
				float Occlusion = _Occlusion1;
				float3 Emission = 0;
				float Alpha = 1;
				#if defined( _ALPHATEST_ON )
					float AlphaClipThreshold = _Cutoff;
					float AlphaClipThresholdShadow = 0.5;
				#endif
				float3 BakedGI = 0;
				float3 RefractionColor = 1;
				float RefractionIndex = 1;
				float3 Transmission = 1;
				float3 Translucency = 1;

				#if defined( ASE_DEPTH_WRITE_ON )
					input.positionCS.z = input.positionCS.z;
				#endif

				#if defined( _ALPHATEST_ON )
					AlphaDiscard( Alpha, AlphaClipThreshold );
				#endif

				#if defined(MAIN_LIGHT_CALCULATE_SHADOWS) && defined(ASE_CHANGES_WORLD_POS)
					ShadowCoord = TransformWorldToShadowCoord( PositionWS );
				#endif

				InputData inputData = (InputData)0;
				inputData.positionWS = PositionWS;
				inputData.positionCS = input.positionCS;
				inputData.normalizedScreenSpaceUV = ScreenPosNorm.xy;
				inputData.shadowCoord = ShadowCoord;

				#ifdef _NORMALMAP
					#if _NORMAL_DROPOFF_TS
						inputData.normalWS = TransformTangentToWorld(Normal, half3x3( TangentWS, BitangentWS, NormalWS ));
					#elif _NORMAL_DROPOFF_OS
						inputData.normalWS = TransformObjectToWorldNormal(Normal);
					#elif _NORMAL_DROPOFF_WS
						inputData.normalWS = Normal;
					#endif
				#else
					inputData.normalWS = NormalWS;
				#endif

				inputData.normalWS = NormalizeNormalPerPixel(inputData.normalWS);
				inputData.viewDirectionWS = SafeNormalize( ViewDirWS );

				#ifdef ASE_FOG
					// @diogo: no fog applied in GBuffer
				#endif
				#ifdef _ADDITIONAL_LIGHTS_VERTEX
					inputData.vertexLighting = input.fogFactorAndVertexLight.yzw;
				#endif

				#if defined( ENABLE_TERRAIN_PERPIXEL_NORMAL )
					float3 SH = SampleSH(inputData.normalWS.xyz);
				#else
					float3 SH = input.lightmapUVOrVertexSH.xyz;
				#endif

				#if defined(DYNAMICLIGHTMAP_ON)
					inputData.bakedGI = SAMPLE_GI(input.lightmapUVOrVertexSH.xy, input.dynamicLightmapUV.xy, SH, inputData.normalWS);
					inputData.shadowMask = SAMPLE_SHADOWMASK(input.lightmapUVOrVertexSH.xy);
				#elif !defined(LIGHTMAP_ON) && (defined(PROBE_VOLUMES_L1) || defined(PROBE_VOLUMES_L2))
					inputData.bakedGI = SAMPLE_GI(SH,
						GetAbsolutePositionWS(inputData.positionWS),
						inputData.normalWS,
						inputData.viewDirectionWS,
						input.positionCS.xy,
						input.probeOcclusion,
						inputData.shadowMask);
				#else
					inputData.bakedGI = SAMPLE_GI(input.lightmapUVOrVertexSH.xy, SH, inputData.normalWS);
					inputData.shadowMask = SAMPLE_SHADOWMASK(input.lightmapUVOrVertexSH.xy);
				#endif

				#ifdef ASE_BAKEDGI
					inputData.bakedGI = BakedGI;
				#endif

				#if defined(DEBUG_DISPLAY)
					#if defined(DYNAMICLIGHTMAP_ON)
						inputData.dynamicLightmapUV = input.dynamicLightmapUV.xy;
						#endif
					#if defined(LIGHTMAP_ON)
						inputData.staticLightmapUV = input.lightmapUVOrVertexSH.xy;
					#else
						inputData.vertexSH = SH;
					#endif
					#if defined(USE_APV_PROBE_OCCLUSION)
						inputData.probeOcclusion = input.probeOcclusion;
					#endif
				#endif

				#ifdef _DBUFFER
					ApplyDecal(input.positionCS,
						BaseColor,
						Specular,
						inputData.normalWS,
						Metallic,
						Occlusion,
						Smoothness);
				#endif

				BRDFData brdfData;
				InitializeBRDFData(BaseColor, Metallic, Specular, Smoothness, Alpha, brdfData);

				Light mainLight = GetMainLight(inputData.shadowCoord, inputData.positionWS, inputData.shadowMask);
				half4 color;
				MixRealtimeAndBakedGI(mainLight, inputData.normalWS, inputData.bakedGI, inputData.shadowMask);

				color.rgb = GlobalIllumination(brdfData, (BRDFData)0, 0,
                              inputData.bakedGI, Occlusion, inputData.positionWS,
                              inputData.normalWS, inputData.viewDirectionWS, inputData.normalizedScreenSpaceUV);

				color.a = Alpha;

				#ifdef ASE_FINAL_COLOR_ALPHA_MULTIPLY
					color.rgb *= color.a;
				#endif

				#if defined( ASE_DEPTH_WRITE_ON )
					outputDepth = input.positionCS.z;
				#endif

				return PackGBuffersBRDFData(brdfData, inputData, Smoothness, Emission + color.rgb, Occlusion);
			}

			ENDHLSL
		}

		
		Pass
		{
			
			Name "SceneSelectionPass"
			Tags { "LightMode"="SceneSelectionPass" }

			Cull Off
			AlphaToMask Off

			HLSLPROGRAM

			#define _SPECULAR_SETUP 1
			#define _NORMAL_DROPOFF_TS 1
			#define ASE_FOG 1
			#pragma multi_compile_fragment _ DEBUG_DISPLAY
			#define _SPECULARHIGHLIGHTS_OFF
			#define ASE_LIGHTING_SIMPLE
			#define ASE_TERRAIN
			#define ASE_VERSION 19908
			#define ASE_SRP_VERSION 170100


			#pragma vertex vert
			#pragma fragment frag

			#if defined( _SPECULAR_SETUP ) && defined( ASE_LIGHTING_SIMPLE )
				#if defined( _SPECULARHIGHLIGHTS_OFF )
					#undef _SPECULAR_COLOR
				#else
					#define _SPECULAR_COLOR
				#endif
			#endif

			#define SCENESELECTIONPASS 1

			#define ATTRIBUTES_NEED_NORMAL
			#define ATTRIBUTES_NEED_TANGENT
			#define SHADERPASS SHADERPASS_DEPTHONLY

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
            #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			#define ASE_INSTANCED_TERRAIN
			#define ASE_NEEDS_VERT_POSITION
			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_TEXTURE_COORDINATES0
			#pragma multi_compile_instancing
			#pragma instancing_options assumeuniformscaling nomatrices nolightprobe nolightmap
			#define TERRAIN_SPLAT_FIRSTPASS 1
			#pragma editor_sync_compilation
			#pragma multi_compile_local __ _ALPHATEST_ON
			#pragma shader_feature_local _MASKMAP


			#if defined(ASE_EARLY_Z_DEPTH_OPTIMIZE) && (SHADER_TARGET >= 45)
				#define ASE_SV_DEPTH SV_DepthLessEqual
				#define ASE_SV_POSITION_QUALIFIERS linear noperspective centroid
			#else
				#define ASE_SV_DEPTH SV_Depth
				#define ASE_SV_POSITION_QUALIFIERS
			#endif

			struct Attributes
			{
				float4 positionOS : POSITION;
				half3 normalOS : NORMAL;
				half4 tangentOS : TANGENT;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct PackedVaryings
			{
				ASE_SV_POSITION_QUALIFIERS float4 positionCS : SV_POSITION;
				float3 positionWS : TEXCOORD0;
				float4 ase_texcoord1 : TEXCOORD1;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _Splat0_ST;
			float4 _TerrainHolesTexture_ST;
			float4 _BaseTint;
			float4 _Splat3_ST;
			float4 _SpecularTint1;
			float4 _Splat1_ST;
			float4 _Control_ST;
			float4 _Splat2_ST;
			float _NormalScale;
			float _SpecularOcclusion;
			float _IndirectSpecularContribution1;
			float _RampOffset;
			float _SpecularIntensity;
			float _SpecularSize1;
			float _SpecularSmoothness1;
			float _RampScale;
			float _Occlusion1;
			float _AlphaClip;
			float _Cutoff;
			#ifdef ASE_TRANSMISSION
				float _TransmissionShadow;
			#endif
			#ifdef ASE_TRANSLUCENCY
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
			#ifdef ASE_TESSELLATION
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END

			#ifdef SCENEPICKINGPASS
				float4 _SelectionID;
			#endif

			#ifdef SCENESELECTIONPASS
				int _ObjectId;
				int _PassValue;
			#endif

			#ifdef UNITY_INSTANCING_ENABLED//ASE Terrain Instancing
				TEXTURE2D(_TerrainHeightmapTexture);//ASE Terrain Instancing
				TEXTURE2D( _TerrainNormalmapTexture);//ASE Terrain Instancing
				SAMPLER(sampler_TerrainNormalmapTexture);//ASE Terrain Instancing
			#endif//ASE Terrain Instancing
			UNITY_INSTANCING_BUFFER_START( Terrain )//ASE Terrain Instancing
				UNITY_DEFINE_INSTANCED_PROP( float4, _TerrainPatchInstanceData )//ASE Terrain Instancing
			UNITY_INSTANCING_BUFFER_END( Terrain)//ASE Terrain Instancing
			CBUFFER_START( UnityTerrain)//ASE Terrain Instancing
				#ifdef UNITY_INSTANCING_ENABLED//ASE Terrain Instancing
					float4 _TerrainHeightmapRecipSize;//ASE Terrain Instancing
					float4 _TerrainHeightmapScale;//ASE Terrain Instancing
				#endif//ASE Terrain Instancing
			CBUFFER_END//ASE Terrain Instancing


			void TerrainApplyMeshModification( inout float3 position, inout half3 normal, inout float4 texcoord )
			{
			#ifdef UNITY_INSTANCING_ENABLED
				float2 patchVertex = position.xy;
				float4 instanceData = UNITY_ACCESS_INSTANCED_PROP( Terrain, _TerrainPatchInstanceData );
				float2 sampleCoords = ( patchVertex.xy + instanceData.xy ) * instanceData.z;
				float height = UnpackHeightmap( _TerrainHeightmapTexture.Load( int3( sampleCoords, 0 ) ) );
				position.xz = sampleCoords* _TerrainHeightmapScale.xz;
				position.y = height* _TerrainHeightmapScale.y;
				#ifdef ENABLE_TERRAIN_PERPIXEL_NORMAL
					normal = float3(0, 1, 0);
				#else
					normal = _TerrainNormalmapTexture.Load(int3(sampleCoords, 0)).rgb* 2 - 1;
				#endif
				texcoord.xy = sampleCoords* _TerrainHeightmapRecipSize.zw;
			#endif
			}
			

			struct SurfaceDescription
			{
				float Alpha;
				float AlphaClipThreshold;
			};

			PackedVaryings VertexFunction(Attributes input  )
			{
				PackedVaryings output;
				ZERO_INITIALIZE(PackedVaryings, output);

				UNITY_SETUP_INSTANCE_ID(input);
				UNITY_TRANSFER_INSTANCE_ID(input, output);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(output);

				#if defined( ASE_INSTANCED_TERRAIN ) && !defined( ASE_TESSELLATION )
					TerrainApplyMeshModification( input.positionOS.xyz, input.normalOS, input.ase_texcoord );
				#endif
				
				output.ase_texcoord1 = input.ase_texcoord;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = input.positionOS.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = defaultVertexValue;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					input.positionOS.xyz = vertexValue;
				#else
					input.positionOS.xyz += vertexValue;
				#endif

				input.normalOS = input.normalOS;

				VertexPositionInputs vertexInput = GetVertexPositionInputs( input.positionOS.xyz );

				output.positionCS = vertexInput.positionCS;
				output.positionWS = vertexInput.positionWS;
				return output;
			}

			#if defined(ASE_TESSELLATION)
			struct VertexControl
			{
				float4 positionOS : INTERNALTESSPOS;
				half3 normalOS : NORMAL;
				half4 tangentOS : TANGENT;
				float4 ase_texcoord : TEXCOORD0;

				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( Attributes input )
			{
				VertexControl output;
				UNITY_SETUP_INSTANCE_ID(input);
				UNITY_TRANSFER_INSTANCE_ID(input, output);
				output.positionOS = input.positionOS;
				output.normalOS = input.normalOS;
				output.tangentOS = input.tangentOS;
				output.ase_texcoord = input.ase_texcoord;
				#if defined( ASE_INSTANCED_TERRAIN )
					TerrainApplyMeshModification( output.positionOS.xyz, output.normalOS, output.ase_texcoord );
				#endif
				
				return output;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> input)
			{
				TessellationFactors output;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(input[0].positionOS, input[1].positionOS, input[2].positionOS, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(input[0].positionOS, input[1].positionOS, input[2].positionOS, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(input[0].positionOS, input[1].positionOS, input[2].positionOS, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				output.edge[0] = tf.x; output.edge[1] = tf.y; output.edge[2] = tf.z; output.inside = tf.w;
				return output;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
				return patch[id];
			}

			[domain("tri")]
			PackedVaryings DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				Attributes output = (Attributes) 0;
				output.positionOS = patch[0].positionOS * bary.x + patch[1].positionOS * bary.y + patch[2].positionOS * bary.z;
				output.normalOS = patch[0].normalOS * bary.x + patch[1].normalOS * bary.y + patch[2].normalOS * bary.z;
				output.tangentOS = patch[0].tangentOS * bary.x + patch[1].tangentOS * bary.y + patch[2].tangentOS * bary.z;
				output.ase_texcoord = patch[0].ase_texcoord * bary.x + patch[1].ase_texcoord * bary.y + patch[2].ase_texcoord * bary.z;
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = output.positionOS.xyz - patch[i].normalOS * (dot(output.positionOS.xyz, patch[i].normalOS) - dot(patch[i].positionOS.xyz, patch[i].normalOS));
				float phongStrength = _TessPhongStrength;
				output.positionOS.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * output.positionOS.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], output);
				return VertexFunction(output);
			}
			#else
			PackedVaryings vert ( Attributes input )
			{
				return VertexFunction( input );
			}
			#endif

			half4 frag( PackedVaryings input
				#if defined( ASE_DEPTH_WRITE_ON )
				,out float outputDepth : ASE_SV_DEPTH
				#endif
				 ) : SV_Target
			{
				SurfaceDescription surfaceDescription = (SurfaceDescription)0;

				float3 PositionWS = input.positionWS;
				float3 PositionRWS = GetCameraRelativePositionWS( PositionWS );
				float4 ScreenPosNorm = float4( GetNormalizedScreenSpaceUV( input.positionCS ), input.positionCS.zw );
				float4 ClipPos = ComputeClipSpacePosition( ScreenPosNorm.xy, input.positionCS.z ) * input.positionCS.w;

				

				surfaceDescription.Alpha = 1;
				#if defined( _ALPHATEST_ON )
					surfaceDescription.AlphaClipThreshold = _Cutoff;
				#endif

				#if defined( ASE_DEPTH_WRITE_ON )
					input.positionCS.z = input.positionCS.z;
				#endif

				#ifdef _ALPHATEST_ON
					clip(surfaceDescription.Alpha - surfaceDescription.AlphaClipThreshold);
				#endif

				#if defined( ASE_DEPTH_WRITE_ON )
					outputDepth = input.positionCS.z;
				#endif

				return half4( _ObjectId, _PassValue, 1.0, 1.0 );
			}

			ENDHLSL
		}

		
		Pass
		{
			
			Name "ScenePickingPass"
			Tags { "LightMode"="Picking" }

			AlphaToMask Off

			HLSLPROGRAM

			#define _SPECULAR_SETUP 1
			#define _NORMAL_DROPOFF_TS 1
			#define ASE_FOG 1
			#pragma multi_compile_fragment _ DEBUG_DISPLAY
			#define _SPECULARHIGHLIGHTS_OFF
			#define ASE_LIGHTING_SIMPLE
			#define ASE_TERRAIN
			#define ASE_VERSION 19908
			#define ASE_SRP_VERSION 170100


			#pragma vertex vert
			#pragma fragment frag

			#if defined( _SPECULAR_SETUP ) && defined( ASE_LIGHTING_SIMPLE )
				#if defined( _SPECULARHIGHLIGHTS_OFF )
					#undef _SPECULAR_COLOR
				#else
					#define _SPECULAR_COLOR
				#endif
			#endif

		    #define SCENEPICKINGPASS 1

			#define ATTRIBUTES_NEED_NORMAL
			#define ATTRIBUTES_NEED_TANGENT
			#define SHADERPASS SHADERPASS_DEPTHONLY

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
            #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			#define ASE_INSTANCED_TERRAIN
			#define ASE_NEEDS_VERT_POSITION
			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_TEXTURE_COORDINATES0
			#pragma multi_compile_instancing
			#pragma instancing_options assumeuniformscaling nomatrices nolightprobe nolightmap
			#define TERRAIN_SPLAT_FIRSTPASS 1
			#pragma editor_sync_compilation
			#pragma multi_compile_local __ _ALPHATEST_ON
			#pragma shader_feature_local _MASKMAP


			#if defined(ASE_EARLY_Z_DEPTH_OPTIMIZE) && (SHADER_TARGET >= 45)
				#define ASE_SV_DEPTH SV_DepthLessEqual
				#define ASE_SV_POSITION_QUALIFIERS linear noperspective centroid
			#else
				#define ASE_SV_DEPTH SV_Depth
				#define ASE_SV_POSITION_QUALIFIERS
			#endif

			struct Attributes
			{
				float4 positionOS : POSITION;
				half3 normalOS : NORMAL;
				half4 tangentOS : TANGENT;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct PackedVaryings
			{
				ASE_SV_POSITION_QUALIFIERS float4 positionCS : SV_POSITION;
				float3 positionWS : TEXCOORD0;
				float4 ase_texcoord1 : TEXCOORD1;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _Splat0_ST;
			float4 _TerrainHolesTexture_ST;
			float4 _BaseTint;
			float4 _Splat3_ST;
			float4 _SpecularTint1;
			float4 _Splat1_ST;
			float4 _Control_ST;
			float4 _Splat2_ST;
			float _NormalScale;
			float _SpecularOcclusion;
			float _IndirectSpecularContribution1;
			float _RampOffset;
			float _SpecularIntensity;
			float _SpecularSize1;
			float _SpecularSmoothness1;
			float _RampScale;
			float _Occlusion1;
			float _AlphaClip;
			float _Cutoff;
			#ifdef ASE_TRANSMISSION
				float _TransmissionShadow;
			#endif
			#ifdef ASE_TRANSLUCENCY
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
			#ifdef ASE_TESSELLATION
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END

			#ifdef SCENEPICKINGPASS
				float4 _SelectionID;
			#endif

			#ifdef SCENESELECTIONPASS
				int _ObjectId;
				int _PassValue;
			#endif

			#ifdef UNITY_INSTANCING_ENABLED//ASE Terrain Instancing
				TEXTURE2D(_TerrainHeightmapTexture);//ASE Terrain Instancing
				TEXTURE2D( _TerrainNormalmapTexture);//ASE Terrain Instancing
				SAMPLER(sampler_TerrainNormalmapTexture);//ASE Terrain Instancing
			#endif//ASE Terrain Instancing
			UNITY_INSTANCING_BUFFER_START( Terrain )//ASE Terrain Instancing
				UNITY_DEFINE_INSTANCED_PROP( float4, _TerrainPatchInstanceData )//ASE Terrain Instancing
			UNITY_INSTANCING_BUFFER_END( Terrain)//ASE Terrain Instancing
			CBUFFER_START( UnityTerrain)//ASE Terrain Instancing
				#ifdef UNITY_INSTANCING_ENABLED//ASE Terrain Instancing
					float4 _TerrainHeightmapRecipSize;//ASE Terrain Instancing
					float4 _TerrainHeightmapScale;//ASE Terrain Instancing
				#endif//ASE Terrain Instancing
			CBUFFER_END//ASE Terrain Instancing


			void TerrainApplyMeshModification( inout float3 position, inout half3 normal, inout float4 texcoord )
			{
			#ifdef UNITY_INSTANCING_ENABLED
				float2 patchVertex = position.xy;
				float4 instanceData = UNITY_ACCESS_INSTANCED_PROP( Terrain, _TerrainPatchInstanceData );
				float2 sampleCoords = ( patchVertex.xy + instanceData.xy ) * instanceData.z;
				float height = UnpackHeightmap( _TerrainHeightmapTexture.Load( int3( sampleCoords, 0 ) ) );
				position.xz = sampleCoords* _TerrainHeightmapScale.xz;
				position.y = height* _TerrainHeightmapScale.y;
				#ifdef ENABLE_TERRAIN_PERPIXEL_NORMAL
					normal = float3(0, 1, 0);
				#else
					normal = _TerrainNormalmapTexture.Load(int3(sampleCoords, 0)).rgb* 2 - 1;
				#endif
				texcoord.xy = sampleCoords* _TerrainHeightmapRecipSize.zw;
			#endif
			}
			

			struct SurfaceDescription
			{
				float Alpha;
				float AlphaClipThreshold;
			};

			PackedVaryings VertexFunction( Attributes input  )
			{
				PackedVaryings output;
				ZERO_INITIALIZE(PackedVaryings, output);

				UNITY_SETUP_INSTANCE_ID(input);
				UNITY_TRANSFER_INSTANCE_ID(input, output);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(output);

				#if defined( ASE_INSTANCED_TERRAIN ) && !defined( ASE_TESSELLATION )
					TerrainApplyMeshModification( input.positionOS.xyz, input.normalOS, input.ase_texcoord );
				#endif
				
				output.ase_texcoord1 = input.ase_texcoord;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = input.positionOS.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = defaultVertexValue;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					input.positionOS.xyz = vertexValue;
				#else
					input.positionOS.xyz += vertexValue;
				#endif

				input.normalOS = input.normalOS;

				VertexPositionInputs vertexInput = GetVertexPositionInputs( input.positionOS.xyz );

				output.positionCS = vertexInput.positionCS;
				output.positionWS = vertexInput.positionWS;
				return output;
			}

			#if defined(ASE_TESSELLATION)
			struct VertexControl
			{
				float4 positionOS : INTERNALTESSPOS;
				half3 normalOS : NORMAL;
				half4 tangentOS : TANGENT;
				float4 ase_texcoord : TEXCOORD0;

				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( Attributes input )
			{
				VertexControl output;
				UNITY_SETUP_INSTANCE_ID(input);
				UNITY_TRANSFER_INSTANCE_ID(input, output);
				output.positionOS = input.positionOS;
				output.normalOS = input.normalOS;
				output.tangentOS = input.tangentOS;
				output.ase_texcoord = input.ase_texcoord;
				#if defined( ASE_INSTANCED_TERRAIN )
					TerrainApplyMeshModification( output.positionOS.xyz, output.normalOS, output.ase_texcoord );
				#endif
				
				return output;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> input)
			{
				TessellationFactors output;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(input[0].positionOS, input[1].positionOS, input[2].positionOS, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(input[0].positionOS, input[1].positionOS, input[2].positionOS, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(input[0].positionOS, input[1].positionOS, input[2].positionOS, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				output.edge[0] = tf.x; output.edge[1] = tf.y; output.edge[2] = tf.z; output.inside = tf.w;
				return output;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
				return patch[id];
			}

			[domain("tri")]
			PackedVaryings DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				Attributes output = (Attributes) 0;
				output.positionOS = patch[0].positionOS * bary.x + patch[1].positionOS * bary.y + patch[2].positionOS * bary.z;
				output.normalOS = patch[0].normalOS * bary.x + patch[1].normalOS * bary.y + patch[2].normalOS * bary.z;
				output.tangentOS = patch[0].tangentOS * bary.x + patch[1].tangentOS * bary.y + patch[2].tangentOS * bary.z;
				output.ase_texcoord = patch[0].ase_texcoord * bary.x + patch[1].ase_texcoord * bary.y + patch[2].ase_texcoord * bary.z;
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = output.positionOS.xyz - patch[i].normalOS * (dot(output.positionOS.xyz, patch[i].normalOS) - dot(patch[i].positionOS.xyz, patch[i].normalOS));
				float phongStrength = _TessPhongStrength;
				output.positionOS.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * output.positionOS.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], output);
				return VertexFunction(output);
			}
			#else
			PackedVaryings vert ( Attributes input )
			{
				return VertexFunction( input );
			}
			#endif

			half4 frag( PackedVaryings input
				#if defined( ASE_DEPTH_WRITE_ON )
				,out float outputDepth : ASE_SV_DEPTH
				#endif
				 ) : SV_Target
			{
				SurfaceDescription surfaceDescription = (SurfaceDescription)0;

				float3 PositionWS = input.positionWS;
				float3 PositionRWS = GetCameraRelativePositionWS( PositionWS );
				float4 ScreenPosNorm = float4( GetNormalizedScreenSpaceUV( input.positionCS ), input.positionCS.zw );
				float4 ClipPos = ComputeClipSpacePosition( ScreenPosNorm.xy, input.positionCS.z ) * input.positionCS.w;

				

				surfaceDescription.Alpha = 1;
				#if defined( _ALPHATEST_ON )
					surfaceDescription.AlphaClipThreshold = _Cutoff;
				#endif

				#if defined( ASE_DEPTH_WRITE_ON )
					input.positionCS.z = input.positionCS.z;
				#endif

				#ifdef _ALPHATEST_ON
					clip(surfaceDescription.Alpha - surfaceDescription.AlphaClipThreshold);
				#endif

				#if defined( ASE_DEPTH_WRITE_ON )
					outputDepth = input.positionCS.z;
				#endif

				return unity_SelectionID;
			}
			ENDHLSL
		}

		
		Pass
		{
			
			Name "MotionVectors"
			Tags { "LightMode"="MotionVectors" }

			ColorMask RG

			HLSLPROGRAM

			#define _SPECULAR_SETUP 1
			#define _NORMAL_DROPOFF_TS 1
			#define ASE_FOG 1
			#pragma multi_compile_fragment _ DEBUG_DISPLAY
			#define _SPECULARHIGHLIGHTS_OFF
			#define ASE_LIGHTING_SIMPLE
			#define ASE_TERRAIN
			#define ASE_VERSION 19908
			#define ASE_SRP_VERSION 170100


			#pragma vertex vert
			#pragma fragment frag

			#if defined( _SPECULAR_SETUP ) && defined( ASE_LIGHTING_SIMPLE )
				#if defined( _SPECULARHIGHLIGHTS_OFF )
					#undef _SPECULAR_COLOR
				#else
					#define _SPECULAR_COLOR
				#endif
			#endif

            #define SHADERPASS SHADERPASS_MOTION_VECTORS

            #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
			#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
		    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
		    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
		    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
		    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
		    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
		    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
            #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
		    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
		    #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			#if defined(LOD_FADE_CROSSFADE)
				#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/LODCrossFade.hlsl"
			#endif

			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/MotionVectorsCommon.hlsl"

			#define ASE_INSTANCED_TERRAIN
			#define ASE_NEEDS_VERT_POSITION
			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_TEXTURE_COORDINATES0
			#pragma multi_compile_instancing
			#pragma instancing_options assumeuniformscaling nomatrices nolightprobe nolightmap
			#define TERRAIN_SPLAT_FIRSTPASS 1
			#pragma editor_sync_compilation
			#pragma multi_compile_local __ _ALPHATEST_ON
			#pragma shader_feature_local _MASKMAP


			#if defined(ASE_EARLY_Z_DEPTH_OPTIMIZE) && (SHADER_TARGET >= 45)
				#define ASE_SV_DEPTH SV_DepthLessEqual
				#define ASE_SV_POSITION_QUALIFIERS linear noperspective centroid
			#else
				#define ASE_SV_DEPTH SV_Depth
				#define ASE_SV_POSITION_QUALIFIERS
			#endif

			struct Attributes
			{
				float4 positionOS : POSITION;
				float3 positionOld : TEXCOORD4;
				#if _ADD_PRECOMPUTED_VELOCITY
					float3 alembicMotionVector : TEXCOORD5;
				#endif
				half3 normalOS : NORMAL;
				half4 tangentOS : TANGENT;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct PackedVaryings
			{
				float4 positionCS : SV_POSITION;
				float4 positionCSNoJitter : TEXCOORD0;
				float4 previousPositionCSNoJitter : TEXCOORD1;
				float3 positionWS : TEXCOORD2;
				float4 ase_texcoord3 : TEXCOORD3;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _Splat0_ST;
			float4 _TerrainHolesTexture_ST;
			float4 _BaseTint;
			float4 _Splat3_ST;
			float4 _SpecularTint1;
			float4 _Splat1_ST;
			float4 _Control_ST;
			float4 _Splat2_ST;
			float _NormalScale;
			float _SpecularOcclusion;
			float _IndirectSpecularContribution1;
			float _RampOffset;
			float _SpecularIntensity;
			float _SpecularSize1;
			float _SpecularSmoothness1;
			float _RampScale;
			float _Occlusion1;
			float _AlphaClip;
			float _Cutoff;
			#ifdef ASE_TRANSMISSION
				float _TransmissionShadow;
			#endif
			#ifdef ASE_TRANSLUCENCY
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
			#ifdef ASE_TESSELLATION
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END

			#ifdef SCENEPICKINGPASS
				float4 _SelectionID;
			#endif

			#ifdef SCENESELECTIONPASS
				int _ObjectId;
				int _PassValue;
			#endif

			#ifdef UNITY_INSTANCING_ENABLED//ASE Terrain Instancing
				TEXTURE2D(_TerrainHeightmapTexture);//ASE Terrain Instancing
				TEXTURE2D( _TerrainNormalmapTexture);//ASE Terrain Instancing
				SAMPLER(sampler_TerrainNormalmapTexture);//ASE Terrain Instancing
			#endif//ASE Terrain Instancing
			UNITY_INSTANCING_BUFFER_START( Terrain )//ASE Terrain Instancing
				UNITY_DEFINE_INSTANCED_PROP( float4, _TerrainPatchInstanceData )//ASE Terrain Instancing
			UNITY_INSTANCING_BUFFER_END( Terrain)//ASE Terrain Instancing
			CBUFFER_START( UnityTerrain)//ASE Terrain Instancing
				#ifdef UNITY_INSTANCING_ENABLED//ASE Terrain Instancing
					float4 _TerrainHeightmapRecipSize;//ASE Terrain Instancing
					float4 _TerrainHeightmapScale;//ASE Terrain Instancing
				#endif//ASE Terrain Instancing
			CBUFFER_END//ASE Terrain Instancing


			void TerrainApplyMeshModification( inout float3 position, inout half3 normal, inout float4 texcoord )
			{
			#ifdef UNITY_INSTANCING_ENABLED
				float2 patchVertex = position.xy;
				float4 instanceData = UNITY_ACCESS_INSTANCED_PROP( Terrain, _TerrainPatchInstanceData );
				float2 sampleCoords = ( patchVertex.xy + instanceData.xy ) * instanceData.z;
				float height = UnpackHeightmap( _TerrainHeightmapTexture.Load( int3( sampleCoords, 0 ) ) );
				position.xz = sampleCoords* _TerrainHeightmapScale.xz;
				position.y = height* _TerrainHeightmapScale.y;
				#ifdef ENABLE_TERRAIN_PERPIXEL_NORMAL
					normal = float3(0, 1, 0);
				#else
					normal = _TerrainNormalmapTexture.Load(int3(sampleCoords, 0)).rgb* 2 - 1;
				#endif
				texcoord.xy = sampleCoords* _TerrainHeightmapRecipSize.zw;
			#endif
			}
			

			PackedVaryings VertexFunction( Attributes input  )
			{
				PackedVaryings output = (PackedVaryings)0;
				UNITY_SETUP_INSTANCE_ID(input);
				UNITY_TRANSFER_INSTANCE_ID(input, output);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(output);

				#if defined( ASE_INSTANCED_TERRAIN ) && !defined( ASE_TESSELLATION )
					TerrainApplyMeshModification( input.positionOS.xyz, input.normalOS, input.ase_texcoord );
				#endif
				
				output.ase_texcoord3 = input.ase_texcoord;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = input.positionOS.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = defaultVertexValue;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					input.positionOS.xyz = vertexValue;
				#else
					input.positionOS.xyz += vertexValue;
				#endif

				VertexPositionInputs vertexInput = GetVertexPositionInputs( input.positionOS.xyz );

				#if defined(APPLICATION_SPACE_WARP_MOTION)
					output.positionCSNoJitter = mul(_NonJitteredViewProjMatrix, mul(UNITY_MATRIX_M, input.positionOS));
					output.positionCS = output.positionCSNoJitter;
				#else
					output.positionCS = vertexInput.positionCS;
					output.positionCSNoJitter = mul(_NonJitteredViewProjMatrix, mul(UNITY_MATRIX_M, input.positionOS));
				#endif

				float4 prevPos = ( unity_MotionVectorsParams.x == 1 ) ? float4( input.positionOld, 1 ) : input.positionOS;

				#if _ADD_PRECOMPUTED_VELOCITY
					prevPos = prevPos - float4(input.alembicMotionVector, 0);
				#endif

				output.previousPositionCSNoJitter = mul( _PrevViewProjMatrix, mul( UNITY_PREV_MATRIX_M, prevPos ) );

				output.positionWS = vertexInput.positionWS;

				// removed in ObjectMotionVectors.hlsl found in unity 6000.0.23 and higher
				//ApplyMotionVectorZBias( output.positionCS );
				return output;
			}

			PackedVaryings vert ( Attributes input )
			{
				return VertexFunction( input );
			}

			half4 frag(	PackedVaryings input
				#if defined( ASE_DEPTH_WRITE_ON )
				,out float outputDepth : ASE_SV_DEPTH
				#endif
				 ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(input);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( input );

				float3 PositionWS = input.positionWS;
				float3 PositionRWS = GetCameraRelativePositionWS( PositionWS );
				float4 ScreenPosNorm = float4( GetNormalizedScreenSpaceUV( input.positionCS ), input.positionCS.zw );
				float4 ClipPos = ComputeClipSpacePosition( ScreenPosNorm.xy, input.positionCS.z ) * input.positionCS.w;

				

				float Alpha = 1;
				#if defined( _ALPHATEST_ON )
					float AlphaClipThreshold = _Cutoff;
				#endif

				#if defined( ASE_DEPTH_WRITE_ON )
					input.positionCS.z = input.positionCS.z;
				#endif

				#ifdef _ALPHATEST_ON
					clip(Alpha - AlphaClipThreshold);
				#endif

				#if defined(ASE_CHANGES_WORLD_POS)
					float3 positionOS = mul( GetWorldToObjectMatrix(),  float4( PositionWS, 1.0 ) ).xyz;
					float3 previousPositionWS = mul( GetPrevObjectToWorldMatrix(),  float4( positionOS, 1.0 ) ).xyz;
					input.positionCSNoJitter = mul( _NonJitteredViewProjMatrix, float4( PositionWS, 1.0 ) );
					input.previousPositionCSNoJitter = mul( _PrevViewProjMatrix, float4( previousPositionWS, 1.0 ) );
				#endif

				#if defined(LOD_FADE_CROSSFADE)
					LODFadeCrossFade( input.positionCS );
				#endif

				#if defined( ASE_DEPTH_WRITE_ON )
					outputDepth = input.positionCS.z;
				#endif

				#if defined(APPLICATION_SPACE_WARP_MOTION)
					return float4( CalcAswNdcMotionVectorFromCsPositions( input.positionCSNoJitter, input.previousPositionCSNoJitter ), 1 );
				#else
					return float4( CalcNdcMotionVectorFromCsPositions( input.positionCSNoJitter, input.previousPositionCSNoJitter ), 0, 0 );
				#endif
			}
			ENDHLSL
		}

	
	}
	
	CustomEditor "UnityEditor.ShaderGraphLitGUI"
	FallBack "Hidden/Shader Graph/FallbackError"
	
	Dependency "AddPassShader"="ToonScapes/URP/Terrain AddPass"
	Dependency "BaseMapShader"="Hidden/Universal Render Pipeline/Terrain/LitBase"

	Fallback "Hidden/Universal Render Pipeline/FallbackError"
}

/*ASEBEGIN
Version=19908
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;623;-6944,560;Inherit;False;1166.792;305.3181;;7;781;727;726;725;724;723;722;CEL Effect;0.7960785,0.7215686,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;625;-8096,960;Inherit;False;1092;325;;5;761;640;638;636;836;Normals;0.6382856,0.4745098,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;628;-8096,1728;Inherit;False;2236.144;877.4296;Direct;21;788;787;785;784;783;782;771;760;759;758;757;756;755;754;753;752;751;750;749;748;747;;1,0,0.390008,1;0;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;630;-8096,2624;Inherit;False;2236.144;596.6401;Indirect;7;820;772;769;746;665;643;642;;1,0,0.390008,1;0;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;632;-8096,560;Inherit;False;816;304;;5;732;731;730;729;728;Half Lambert;0.8078432,0.7294118,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;633;-8096,1392;Inherit;False;1044;323;;4;770;765;662;644;Specular Highlights;1,0,0.3882353,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;533;-2304,1296;Inherit;False;Smoothness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;536;-2304,1136;Inherit;False;Albedo;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;554;-2304,1216;Inherit;False;Normal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;636;-8000,1008;Inherit;False;554;Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;637;-7856,32;Inherit;False;TextureRamp;-1;True;1;0;SAMPLER2D;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.WorldNormalVector, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;638;-7376,1056;Inherit;False;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NormalizeNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;640;-7184,1056;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;642;-6832,3056;Float;False;Property;_IndirectSpecularContribution1;Indirect Specular Contribution;24;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;643;-6448,2912;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;644;-8048,1600;Inherit;False;733;HalfLambert;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;645;-3952,2032;Inherit;True;Property;_TextureRamp1;Texture Ramp 1;0;1;[Header];Create;True;1;Textures;0;0;False;1;Space(8);False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;False;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;646;-3440,1840;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;647;-3472,1968;Inherit;False;733;HalfLambert;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;648;-3888,1392;Inherit;False;Constant;_DefaultTint;Default Tint;19;0;Create;True;0;0;0;False;0;False;1,1,1,1;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;649;-3248,1840;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;651;-3600,1392;Inherit;False;768;SpecularHighlights;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;652;-2848,1616;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;654;-3440,2064;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;655;-3056,1840;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;656;-2624,1392;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;662;-8048,1520;Inherit;False;764;DirectSpecHighlights;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;663;-4208,2032;Inherit;False;637;TextureRamp;1;0;OBJECT;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;664;-5712,624;Inherit;False;CEL Effect;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;665;-7056,2928;Inherit;False;780;Normals;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;722;-6896,704;Inherit;False;True;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DotProductOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;723;-6624,624;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;724;-6208,624;Inherit;False;3;0;FLOAT;1;False;1;FLOAT;0.5;False;2;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;725;-5952,624;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;726;-6512,768;Inherit;False;742;RampOffset;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;727;-6512,688;Inherit;False;743;RampScale;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LightColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;728;-8048,608;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.LightAttenuation, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;729;-8048,752;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.IndirectDiffuseLighting, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;730;-7712,752;Inherit;False;Tangent;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;731;-7712,608;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;732;-7440,608;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;733;-7216,608;Inherit;False;HalfLambert;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;734;-4208,2112;Inherit;False;664;CEL Effect;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;736;-4624,2288;Inherit;False;SRP Additional Light;-1;;61167;6c86746ad131a0a408ca599df5f40861;3,6,1,351,1,23,0;6;2;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;345;FLOAT3;0,0,0;False;346;FLOAT3;0,0,0;False;347;FLOAT;0.5;False;32;FLOAT4;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;737;-4336,2288;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;738;-3952,2224;Inherit;True;Property;_TextureRamp2;Texture Ramp 1;0;1;[Header];Create;True;1;Textures;0;0;False;1;Space(8);False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;False;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ScaleAndOffsetNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;739;-4176,2288;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;740;-4560,2480;Inherit;False;742;RampOffset;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;741;-4560,2400;Inherit;False;743;RampScale;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;742;-7232,128;Inherit;False;RampOffset;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;743;-7232,32;Inherit;False;RampScale;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;744;-7552,32;Inherit;False;Property;_RampScale;Ramp Scale;15;0;Create;True;0;0;0;False;0;False;0.5;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;745;-7552,128;Inherit;False;Property;_RampOffset;Ramp Offset;16;0;Create;True;0;0;0;False;0;False;0.5;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;746;-6784,2848;Float;False;Constant;_Float5;Float 5;20;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;747;-7984,2384;Inherit;False;780;Normals;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.OneMinusNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;748;-7024,1984;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DotProductOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;749;-7712,2304;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;750;-6832,2128;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;751;-7216,1888;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleDivideOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;752;-6640,2128;Inherit;False;2;0;FLOAT3;0,0,0;False;1;COLOR;0.05,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SwizzleNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;753;-6832,1888;Inherit;False;FLOAT3;0;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;754;-6464,2128;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;755;-6224,2032;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;756;-6816,2272;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;757;-6944,2304;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;758;-7712,2448;Inherit;False;780;Normals;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;759;-8016,2304;Inherit;False;Blinn-Phong Half Vector;-1;;61169;91a149ac9d615be429126c95e20753ce;0;0;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;760;-7488,2448;Inherit;False;SRP Additional Light;-1;;61170;6c86746ad131a0a408ca599df5f40861;3,6,1,351,1,23,0;6;2;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;345;FLOAT3;0,0,0;False;346;FLOAT3;0,0,0;False;347;FLOAT;0.5;False;32;FLOAT4;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;761;-8048,1120;Inherit;False;Property;_NormalScale;Normal Scale;17;0;Create;True;0;0;0;False;0;False;1;1;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;763;-3312,1392;Inherit;False;Property;_EnableSpecularHighlights;Enable Specular Highlights;18;0;Create;True;0;0;0;False;2;Header(Highlights);Space(8);False;0;1;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;764;-5776,2032;Inherit;False;DirectSpecHighlights;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;765;-8048,1440;Inherit;False;793;IndirectSpecHighlights;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;770;-7680,1504;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;771;-7200,2448;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.IndirectSpecularLight, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;772;-6832,2928;Inherit;False;World;3;0;FLOAT3;0,0,0;False;1;FLOAT;0.5;False;2;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TexturePropertyNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;773;-8096,32;Inherit;True;Property;_TextureRamp3;Texture Ramp;14;3;[Header];[NoScaleOffset];[SingleLineTexture];Create;True;1;Textures;0;0;False;1;Space (8);False;None;None;False;white;Auto;Texture2D;False;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;774;-3312,1616;Inherit;False;Property;_EnableColorTint;Enable Color Tint;12;0;Create;True;0;0;0;False;2;Header(Color);Space(8);False;0;1;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;776;-2784,1520;Inherit;False;Property;_Occlusion1;Occlusion;25;1;[Header];Create;True;1;Surface Options;0;0;False;1;Space (8);False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;777;-3888,1616;Inherit;False;Property;_BaseTint;Base Tint;13;0;Create;True;0;0;0;False;1;Space(8);False;1,1,1,1;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.TFHCRemapNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;782;-7232,2272;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-1;False;4;FLOAT;-0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;783;-7584,2272;Float;False;Property;_SpecularSize1;Specular Size;20;0;Create;True;0;0;0;False;1;Space (8);False;0;-0.95;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;784;-7232,2160;Float;False;Property;_SpecularSmoothness1;Specular Smoothness;22;0;Create;True;0;0;0;False;0;False;0.01;0.04;0.001;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;787;-7600,1792;Float;False;Property;_SpecularTint1;Specular Tint;19;0;Create;True;0;0;0;False;1;Space(8);False;1,1,1,1;0.5773503,0.5773503,0.5773503,1;False;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;788;-7600,2192;Inherit;False;Property;_SpecularIntensity;Specular Intensity;21;0;Create;True;0;0;0;False;0;False;0.5;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;793;-5792,2912;Inherit;False;IndirectSpecHighlights;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;820;-7376,3120;Inherit;False;Property;_SpecularOcclusion;Specular Occlusion;23;0;Create;True;0;0;0;False;0;False;1;0;0;12;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;768;-6992,1504;Inherit;False;SpecularHighlights;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;780;-6944,1056;Inherit;False;Normals;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;660;-3952,1840;Inherit;False;536;Albedo;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;735;-4848,2288;Inherit;False;780;Normals;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;781;-6864,608;Inherit;False;780;Normals;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;836;-7648,1056;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;785;-7584,2000;Inherit;False;533;Smoothness;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;769;-7152,3008;Inherit;False;533;Smoothness;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;837;-2720,1136;Inherit;False;ToonScapes Terrain;0;;61173;839d5e6c5202c5f46a94cfc7415bf3bf;2,102,1,85,0;4;59;FLOAT4;0,0,0,0;False;60;FLOAT4;0,0,0,0;False;61;FLOAT3;0,0,0;False;58;FLOAT;0;False;3;FLOAT4;0;FLOAT3;14;FLOAT;45
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;824;-2304,1392;Float;False;False;-1;3;UnityEditor.ShaderGraphLitGUI;0;1;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;ExtraPrePass;0;0;ExtraPrePass;6;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;False;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Lit;True;5;True;14;all;0;False;True;1;1;False;;0;False;;0;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;False;True;0;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;825;-2304,1392;Float;False;True;-1;3;UnityEditor.ShaderGraphLitGUI;0;15;ToonScapes/URP/Terrain;94348b07e5e8bab40bd6c8a1e3df54cd;True;Forward;0;1;Forward;21;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;False;True;8;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=-100;UniversalMaterialType=SimpleLit;DisableBatching=False=DisableBatching;IgnoreProjector=True;TerrainCompatible=True;AlwaysRenderMotionVectors=false;True;5;True;14;all;0;True;True;1;1;False;;0;False;;0;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;False;True;5;LightMode=UniversalForward;DisableBatching=False=DisableBatching;TerrainCompatible=True;IgnoreProjector=True;AlwaysRenderMotionVectors=false;False;False;3;Include;;False;;Native;False;0;0;;Define;TERRAIN_SPLAT_FIRSTPASS 1;False;;Custom;False;0;0;;Pragma;editor_sync_compilation;False;;Custom;False;0;0;;Hidden/Universal Render Pipeline/FallbackError;2;AddPassShader=ToonScapes/URP/Terrain AddPass;BaseMapShader=Hidden/Universal Render Pipeline/Terrain/LitBase;0;Standard;51;Category;1;639050776678617959;  Instanced Terrain Normals;2;639050776812461118;Lighting Model;1;639049498661425621;Workflow;0;0;Surface;0;0;  Keep Alpha;0;0;  Refraction Model;0;0;  Blend;0;0;Two Sided;1;0;Alpha Clipping;0;639049499873708845;  Use Shadow Threshold;0;0;Fragment Normal Space;0;0;Forward Only;0;0;Transmission;0;0;  Transmission Shadow;0.5,True,_ASETransmissionShadow;0;Translucency;0;0;  Translucency Strength;1,True,_ASETranslucencyStrength;0;  Normal Distortion;0.5,True,_ASETranslucencyNormalDistortion;0;  Scattering;2,True,_ASETranslucencyScattering;0;  Direct;0.9,True,_ASETranslucencyDirect;0;  Ambient;0.1,True,_ASETranslucencyAmbient;0;  Shadow;0.5,True,_ASETranslucencyShadow;0;Cast Shadows;1;0;Receive Shadows;2;0;Specular Highlights;0;639049495664100248;Environment Reflections;2;0;Receive SSAO;1;0;Motion Vectors;1;0;  Add Precomputed Velocity;0;0;  XR Motion Vectors;0;0;GPU Instancing;1;0;LOD CrossFade;0;639050777684504611;Built-in Fog;1;0;_FinalColorxAlpha;0;0;Meta Pass;1;0;Override Baked GI;0;0;Extra Pre Pass;0;0;Tessellation;0;0;  Phong;0;0;  Strength;0.5,True,_TessellationPhong;0;  Type;0;0;  Tess;16,True,_TessellationStrength;0;  Min;10,True,_TessellationDistanceMin;0;  Max;25,True,_TessellationDistanceMax;0;  Edge Length;16,False,;0;  Max Displacement;25,False,;0;Write Depth;0;0;  Early Z;0;0;Vertex Position;1;0;Debug Display;1;0;Clear Coat;0;0;0;12;False;True;True;True;True;True;True;True;True;True;True;False;True;;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;826;-2288,1376;Float;False;False;-1;3;UnityEditor.ShaderGraphLitGUI;0;1;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;ShadowCaster;0;2;ShadowCaster;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;False;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Lit;True;5;True;14;all;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;False;False;True;False;False;False;False;0;False;;False;False;False;False;False;False;False;False;False;True;1;False;;True;3;False;;False;False;True;1;LightMode=ShadowCaster;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;827;-2288,1376;Float;False;False;-1;3;UnityEditor.ShaderGraphLitGUI;0;1;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;DepthOnly;0;3;DepthOnly;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;False;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Lit;True;5;True;14;all;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;False;False;True;True;False;False;False;0;False;;False;False;False;False;False;False;False;False;False;True;1;False;;False;False;False;True;1;LightMode=DepthOnly;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;828;-2288,1376;Float;False;False;-1;3;UnityEditor.ShaderGraphLitGUI;0;1;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;Meta;0;4;Meta;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;False;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Lit;True;5;True;14;all;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=Meta;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;829;-2288,1376;Float;False;False;-1;3;UnityEditor.ShaderGraphLitGUI;0;1;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;Universal2D;0;5;Universal2D;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;False;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Lit;True;5;True;14;all;0;False;True;1;1;False;;0;False;;0;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;False;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;False;True;1;LightMode=Universal2D;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;830;-2288,1376;Float;False;False;-1;3;UnityEditor.ShaderGraphLitGUI;0;1;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;DepthNormals;0;6;DepthNormals;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;False;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Lit;True;5;True;14;all;0;False;True;1;1;False;;0;False;;0;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;False;;True;3;False;;False;False;True;1;LightMode=DepthNormals;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;831;-2288,1376;Float;False;False;-1;3;UnityEditor.ShaderGraphLitGUI;0;1;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;GBuffer;0;7;GBuffer;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;False;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Lit;True;5;True;14;all;0;False;True;1;1;False;;0;False;;0;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;False;True;1;LightMode=UniversalGBuffer;False;True;12;d3d11;gles;metal;vulkan;xboxone;xboxseries;playstation;ps4;ps5;switch;switch2;webgpu;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;832;-2288,1376;Float;False;False;-1;3;UnityEditor.ShaderGraphLitGUI;0;1;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;SceneSelectionPass;0;8;SceneSelectionPass;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;False;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Lit;True;5;True;14;all;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=SceneSelectionPass;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;833;-2288,1376;Float;False;False;-1;3;UnityEditor.ShaderGraphLitGUI;0;1;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;ScenePickingPass;0;9;ScenePickingPass;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;False;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Lit;True;5;True;14;all;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=Picking;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;834;-2288,1376;Float;False;False;-1;3;UnityEditor.ShaderGraphLitGUI;0;1;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;MotionVectors;0;10;MotionVectors;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;False;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Lit;True;5;True;14;all;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;False;False;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=MotionVectors;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;835;-2288,1376;Float;False;False;-1;3;UnityEditor.ShaderGraphLitGUI;0;1;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;XRMotionVectors;0;11;XRMotionVectors;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;False;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Lit;True;5;True;14;all;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;True;1;False;;255;False;;1;False;;7;False;;3;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;False;False;False;False;True;1;LightMode=XRMotionVectors;False;False;0;;0;0;Standard;0;False;0
WireConnection;533;0;837;45
WireConnection;536;0;837;0
WireConnection;554;0;837;14
WireConnection;637;0;773;0
WireConnection;638;0;836;0
WireConnection;640;0;638;0
WireConnection;643;0;746;0
WireConnection;643;1;772;0
WireConnection;643;2;642;0
WireConnection;645;0;663;0
WireConnection;645;1;734;0
WireConnection;646;0;660;0
WireConnection;646;1;645;0
WireConnection;649;0;646;0
WireConnection;649;1;647;0
WireConnection;652;0;774;0
WireConnection;652;1;655;0
WireConnection;654;0;660;0
WireConnection;654;1;738;0
WireConnection;655;0;649;0
WireConnection;655;1;654;0
WireConnection;656;0;763;0
WireConnection;656;1;652;0
WireConnection;664;0;725;0
WireConnection;723;0;781;0
WireConnection;723;1;722;0
WireConnection;724;0;723;0
WireConnection;724;1;727;0
WireConnection;724;2;726;0
WireConnection;725;0;724;0
WireConnection;731;0;728;0
WireConnection;731;1;729;0
WireConnection;732;0;731;0
WireConnection;732;1;730;0
WireConnection;733;0;732;0
WireConnection;736;11;735;0
WireConnection;737;0;736;0
WireConnection;738;0;663;0
WireConnection;738;1;739;0
WireConnection;739;0;737;0
WireConnection;739;1;741;0
WireConnection;739;2;740;0
WireConnection;742;0;745;0
WireConnection;743;0;744;0
WireConnection;748;0;751;0
WireConnection;749;0;759;0
WireConnection;749;1;747;0
WireConnection;750;0;748;0
WireConnection;750;1;784;0
WireConnection;751;0;787;0
WireConnection;751;1;785;0
WireConnection;751;2;788;0
WireConnection;752;0;756;0
WireConnection;752;1;750;0
WireConnection;753;0;751;0
WireConnection;754;0;752;0
WireConnection;755;0;753;0
WireConnection;755;1;754;0
WireConnection;756;0;782;0
WireConnection;756;1;757;0
WireConnection;757;0;749;0
WireConnection;757;1;771;0
WireConnection;760;11;758;0
WireConnection;763;0;651;0
WireConnection;764;0;755;0
WireConnection;770;0;765;0
WireConnection;770;1;662;0
WireConnection;770;2;644;0
WireConnection;771;0;760;0
WireConnection;772;0;665;0
WireConnection;772;1;769;0
WireConnection;772;2;820;0
WireConnection;774;1;648;0
WireConnection;774;0;777;0
WireConnection;782;0;783;0
WireConnection;793;0;643;0
WireConnection;768;0;770;0
WireConnection;780;0;640;0
WireConnection;836;0;636;0
WireConnection;836;1;761;0
WireConnection;825;0;656;0
WireConnection;825;5;776;0
ASEEND*/
//CHKSM=97A88877001441EED3D67DC00CBC34A34DB8DAAF