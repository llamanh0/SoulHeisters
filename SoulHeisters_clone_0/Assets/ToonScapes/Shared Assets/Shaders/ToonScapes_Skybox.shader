// Made with Amplify Shader Editor v1.9.9.5
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ToonScapes/URP/Skybox"
{
	Properties
	{
		[Header(Day Time Colors)][Space (8)] _ZenithColorDay( "Zenith Color Day", Color ) = ( 0, 0, 0, 1 )
		_EquatorColorDay( "Equator Color Day", Color ) = ( 1, 1, 1, 1 )
		_NadirColorDay( "Nadir Color Day", Color ) = ( 1, 1, 1, 1 )
		[Header(Zenith Colors)][Space (8)] _ZenithColorTwilight( "Zenith Color Twilight", Color ) = ( 0, 0, 0, 1 )
		_EquatorColorTwilight( "Equator Color Twilight", Color ) = ( 1, 1, 1, 1 )
		_NadirColorTwilight( "Nadir Color Twilight", Color ) = ( 1, 1, 1, 1 )
		[Header(Night Time Colors)][Space (8)] _ZenithColorNight( "Zenith Color Night", Color ) = ( 0, 0, 0, 1 )
		_EquatorColorNight( "Equator Color Night", Color ) = ( 1, 1, 1, 1 )
		_NadirColorNight( "Nadir Color Night", Color ) = ( 1, 1, 1, 1 )
		[Header(Background)][NoScaleOffset][Space(8)] _BackgroundCubemap( "Background Cubemap", CUBE ) = "white" {}
		[IntRange] _BackgroundRotation( "Background Rotation", Range( 0, 360 ) ) = 0
		_BackgroundRotationSpeed( "Background Rotation Speed", Float ) = 1
		[Space(8)] _BackgroundTint1( "Background Tint", Color ) = ( 1, 1, 1, 0 )
		_BackgroundGradientBlend( "Background Gradient Blend", Range( 0, 1 ) ) = 0.5
		_BackgroundOpacity( "Background Opacity", Range( 0, 1 ) ) = 1
		_BackgroundExposure( "Background Exposure", Range( 0, 1 ) ) = 0.165
		[Space(8)] _SpecularTint3( "Background Specular Tint", Color ) = ( 1, 1, 1, 0 )
		_BackgroundSpecularAngle( "Background Specular Angle", Float ) = 1
		_BackgroundSpecularIntensity( "Background Specular Intensity", Float ) = 1
		[Space(8)] _BackgroundSubsurfaceAmount( "Background Subsurface Amount", Range( 0, 1 ) ) = 0
		_BackgroundSubsurfaceSharpness( "Background Subsurface Sharpness", Float ) = 1
		[Header(Midground)][NoScaleOffset][Space(8)] _MidgroundCubemap( "Midground Cubemap", CUBE ) = "white" {}
		[IntRange] _MidgroundRotation( "Midground Rotation", Range( 0, 360 ) ) = 0
		_MidgroundRotationSpeed( "Midground Rotation Speed", Float ) = 1
		[Space(8)] _MidgroundTint1( "Midground Tint", Color ) = ( 1, 1, 1, 0 )
		_MidgroundGradientBlend( "Midground Gradient Blend", Range( 0, 1 ) ) = 0.5
		_MidgroundOpacity( "Midground Opacity", Range( 0, 1 ) ) = 1
		_MidgroundExposure( "Midground Exposure", Range( 0, 1 ) ) = 0.165
		[Space(8)] _SpecularTint2( "Midground Specular Tint", Color ) = ( 1, 1, 1, 0 )
		_MidgroundSpecularAngle( "Midground Specular Angle", Float ) = 1
		_MidgroundSpecularIntensity( "Midground Specular Intensity", Float ) = 1
		[Space(8)] _MidgroundSubsurfaceAmount( "Midground Subsurface Amount", Range( 0, 1 ) ) = 0
		_MidgroundSubsurfaceSharpness( "Midground Subsurface Sharpness", Float ) = 1
		[Header(Foreground)][NoScaleOffset][Space(8)] _ForegroundCubemap( "Foreground Cubemap", CUBE ) = "white" {}
		[IntRange] _ForegroundRotation( "Foreground Rotation", Range( 0, 360 ) ) = 0
		_ForegroundRotationSpeed( "Foreground Rotation Speed", Float ) = 1
		[Space(8)] _ForegroundTint1( "Foreground Tint", Color ) = ( 1, 1, 1, 0 )
		_ForegroundGradientBlend( "Foreground Gradient Blend", Range( 0, 1 ) ) = 0.5
		_ForegroundOpacity( "Foreground Opacity", Range( 0, 1 ) ) = 1
		_ForegroundExposure( "Foreground Exposure", Range( 0, 1 ) ) = 0.165
		[Space(8)] _SpecularTint1( "Foreground Specular Tint", Color ) = ( 1, 1, 1, 0 )
		_ForegroundSpecularAngle( "Foreground Specular Angle", Float ) = 1
		_ForegroundSpecularIntensity( "Foreground Specular Intensity", Float ) = 1
		[Space(8)] _ForegroundSubsurfaceAmount( "Foreground Subsurface Amount", Range( 0, 1 ) ) = 0
		_ForegroundSubsurfaceSharpness( "Foreground Subsurface Sharpness", Float ) = 1
		[Header(Noise)][NoScaleOffset][Space(8)] _NoiseCubemap( "Noise Cubemap", CUBE ) = "white" {}
		[Space(8)] _BackgroundDistortionAmount( "Background Distortion Amount", Float ) = 0
		_BackgroundDistortionSpeed( "Background Distortion Speed", Float ) = 1.25
		_BackgroundDistortionDirection( "Background Distortion Direction", Vector ) = ( 0, 0, 1, 0 )
		[IntRange] _BackgroundCoverageMaskRotation( "Background Coverage Mask Rotation", Range( 0, 360 ) ) = 0
		_BackgroundCoverageMaskSpeed( "Background Coverage Mask Speed", Float ) = 1.25
		_BackgroundCoverageStrength( "Background Coverage Strength", Range( 0, 1 ) ) = 0.75
		[Space(8)] _MidgroundDistortionAmount( "Midground Distortion Amount", Float ) = 0
		_MidgroundDistortionSpeed( "Midground Distortion Speed", Float ) = 1.25
		_MidgroundDistortionDirection( "Midground Distortion Direction", Vector ) = ( 0, 0, 1, 0 )
		[IntRange] _MidgroundCoverageMaskRotation( "Midground Coverage Mask Rotation", Range( 0, 360 ) ) = 0
		_MidgroundCoverageMaskSpeed( "Midground Coverage Mask Speed", Float ) = 1.25
		_MidgroundCoverageStrength( "Midground Coverage Strength", Range( 0, 1 ) ) = 0.75
		[Space(8)] _ForegroundDistortionAmount( "Foreground Distortion Amount", Float ) = 0
		_ForegroundDistortionSpeed( "Foreground Distortion Speed", Float ) = 1.25
		_ForegroundDistortionDirection( "Foreground Distortion Direction", Vector ) = ( 0, 0, 1, 0 )
		[IntRange] _ForegroundCoverageMaskRotation( "Foreground Coverage Mask Rotation", Range( 0, 360 ) ) = 0
		_ForegroundCoverageMaskSpeed( "Foreground Coverage Mask Speed", Float ) = 1.25
		_ForegroundCoverageStrength( "Foreground Coverage Strength", Range( 0, 1 ) ) = 0.75
		[Header(Fog)][Space (8)][Toggle( _ENABLEFOG_ON )] _EnableFog( "Enable Fog", Float ) = 0
		_FogHeight1( "Fog Height", Range( 0, 1 ) ) = 1
		[HideInInspector] _Tex_HDR2( "DecodeInstructions", Vector ) = ( 0, 0, 0, 0 )
		[HideInInspector] _Tex_HDR1( "DecodeInstructions", Vector ) = ( 0, 0, 0, 0 )
		[HideInInspector] _Tex_HDR( "DecodeInstructions", Vector ) = ( 0, 0, 0, 0 )
		[Header(Sun)][Space(8)][Toggle( _ENABLESUN_ON )] _EnableSun( "Enable Sun", Float ) = 0
		[Space(8)] _SunTint( "Sun Tint", Color ) = ( 1, 1, 1, 0 )
		_SunScale( "Sun Scale", Range( 0, 1 ) ) = 0.3
		_SunSharpness( "Sun Sharpness", Float ) = 1
		_SunRimIntensity( "Sun Rim Intensity", Range( 0, 1 ) ) = 0.5
		_SunRimSharpness( "Sun Rim Sharpness", Float ) = 1
		_SunIntensity( "Sun Intensity", Float ) = 1
		_SunDistortion( "Sun Distortion", Float ) = 2
		[Header(Moon)][Space(8)][Toggle( _ENABLEMOON_ON )] _EnableMoon( "Enable Moon", Float ) = 0
		[NoScaleOffset][Space(8)] _MoonTexture( "Moon Texture", 2D ) = "white" {}
		_MoonColor( "Moon Color", Color ) = ( 1, 1, 1, 0 )
		_MoonDistance( "Moon Distance", Float ) = 2
		_MoonSharpness( "Moon Sharpness", Float ) = 0
		_MoonIntensity( "Moon Intensity", Float ) = 1
		_MoonOffset( "Moon Offset", Vector ) = ( 0, 0, 0, 0 )
		[IntRange] _MoonOffsetRotation( "Moon Offset Rotation", Range( 0, 360 ) ) = 0
		[KeywordEnum( LightDirection,LightDirectionOpposite )] _MoonDirection( "Moon Direction", Float ) = 0
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Background"  "Queue" = "Background+0" "IgnoreProjector" = "True" "ForceNoShadowCasting" = "True" "IsEmissive" = "true"  }
		Cull Off
		CGPROGRAM
		#include "UnityCG.cginc"
		#include "UnityStandardBRDF.cginc"
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma shader_feature_local _ENABLEFOG_ON
		#pragma shader_feature_local _ENABLEMOON_ON
		#pragma shader_feature_local _ENABLESUN_ON
		#pragma shader_feature_local _MOONDIRECTION_LIGHTDIRECTION _MOONDIRECTION_LIGHTDIRECTIONOPPOSITE
		#define ASE_VERSION 19905
		#pragma surface surf Unlit keepalpha noshadow noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd 
		struct Input
		{
			float3 worldPos;
		};

		uniform half4 _Tex_HDR1;
		uniform half4 _Tex_HDR;
		uniform half4 _Tex_HDR2;
		uniform float4 _NadirColorNight;
		uniform float4 _EquatorColorNight;
		uniform float4 _ZenithColorNight;
		uniform float4 _NadirColorTwilight;
		uniform float4 _EquatorColorTwilight;
		uniform float4 _ZenithColorTwilight;
		uniform float4 _NadirColorDay;
		uniform float4 _EquatorColorDay;
		uniform float4 _ZenithColorDay;
		uniform float _BackgroundSubsurfaceSharpness;
		uniform samplerCUBE _BackgroundCubemap;
		uniform half _BackgroundRotationSpeed;
		uniform half _BackgroundRotation;
		uniform samplerCUBE _NoiseCubemap;
		uniform float _BackgroundDistortionSpeed;
		uniform float _BackgroundDistortionAmount;
		uniform float3 _BackgroundDistortionDirection;
		uniform float _BackgroundExposure;
		uniform float _BackgroundOpacity;
		uniform float _BackgroundSubsurfaceAmount;
		uniform float _BackgroundSpecularAngle;
		uniform float4 _SpecularTint3;
		uniform float _BackgroundSpecularIntensity;
		uniform float4 _BackgroundTint1;
		uniform float _BackgroundGradientBlend;
		uniform half _BackgroundCoverageMaskRotation;
		uniform float _BackgroundCoverageMaskSpeed;
		uniform float _BackgroundCoverageStrength;
		uniform float _MidgroundSubsurfaceSharpness;
		uniform samplerCUBE _MidgroundCubemap;
		uniform half _MidgroundRotationSpeed;
		uniform half _MidgroundRotation;
		uniform float _MidgroundDistortionSpeed;
		uniform float _MidgroundDistortionAmount;
		uniform float3 _MidgroundDistortionDirection;
		uniform float _MidgroundExposure;
		uniform float _MidgroundOpacity;
		uniform float _MidgroundSubsurfaceAmount;
		uniform float _MidgroundSpecularAngle;
		uniform float4 _SpecularTint2;
		uniform float _MidgroundSpecularIntensity;
		uniform float4 _MidgroundTint1;
		uniform float _MidgroundGradientBlend;
		uniform half _MidgroundCoverageMaskRotation;
		uniform float _MidgroundCoverageMaskSpeed;
		uniform float _MidgroundCoverageStrength;
		uniform float _ForegroundSubsurfaceSharpness;
		uniform samplerCUBE _ForegroundCubemap;
		uniform half _ForegroundRotationSpeed;
		uniform half _ForegroundRotation;
		uniform float _ForegroundDistortionSpeed;
		uniform float _ForegroundDistortionAmount;
		uniform float3 _ForegroundDistortionDirection;
		uniform float _ForegroundExposure;
		uniform float _ForegroundOpacity;
		uniform float _ForegroundSubsurfaceAmount;
		uniform float _ForegroundSpecularAngle;
		uniform float4 _SpecularTint1;
		uniform float _ForegroundSpecularIntensity;
		uniform float4 _ForegroundTint1;
		uniform float _ForegroundGradientBlend;
		uniform half _ForegroundCoverageMaskRotation;
		uniform float _ForegroundCoverageMaskSpeed;
		uniform float _ForegroundCoverageStrength;
		uniform float _SunScale;
		uniform float _SunDistortion;
		uniform float _SunSharpness;
		uniform float _SunRimSharpness;
		uniform float _SunRimIntensity;
		uniform float _SunIntensity;
		uniform float4 _SunTint;
		uniform sampler2D _MoonTexture;
		uniform half _MoonOffsetRotation;
		uniform float _MoonDistance;
		uniform float2 _MoonOffset;
		uniform float _MoonSharpness;
		uniform float _MoonIntensity;
		uniform float4 _MoonColor;
		uniform half _FogHeight1;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float3 ase_positionWS = i.worldPos;
			float3 ase_viewVectorWS = ( _WorldSpaceCameraPos.xyz - ase_positionWS );
			float3 ase_viewDirWS = normalize( ase_viewVectorWS );
			float3 normalizeResult97 = normalize( ase_viewDirWS );
			float HeightFactor104 = ( 1.0 -  (0.0 + ( normalizeResult97.y - -1.0 ) * ( 1.0 - 0.0 ) / ( 1.0 - -1.0 ) ) );
			float4 lerpResult119 = lerp( _NadirColorNight , _EquatorColorNight , saturate( ( HeightFactor104 * 2 ) ));
			float4 lerpResult120 = lerp( lerpResult119 , _ZenithColorNight , saturate( ( ( HeightFactor104 - 0.5 ) * 2 ) ));
			float4 NightGradient132 = lerpResult120;
			float4 lerpResult1376 = lerp( _NadirColorTwilight , _EquatorColorTwilight , saturate( ( HeightFactor104 * 2 ) ));
			float4 lerpResult1379 = lerp( lerpResult1376 , _ZenithColorTwilight , saturate( ( ( HeightFactor104 - 0.5 ) * 2 ) ));
			float4 TwilightGradient1380 = lerpResult1379;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_lightDirWS = 0;
			#else //aseld
			float3 ase_lightDirWS = Unity_SafeNormalize( UnityWorldSpaceLightDir( ase_positionWS ) );
			#endif //aseld
			float smoothstepResult1389 = smoothstep( 0.1 , 0.9 , ( ( ase_lightDirWS.y * 0.5 ) + 0.5 ));
			float temp_output_1396_0 = ( smoothstepResult1389 * 2 );
			float4 lerpResult133 = lerp( NightGradient132 , TwilightGradient1380 , saturate( temp_output_1396_0 ));
			float4 lerpResult108 = lerp( _NadirColorDay , _EquatorColorDay , saturate( ( HeightFactor104 * 2 ) ));
			float4 lerpResult110 = lerp( lerpResult108 , _ZenithColorDay , saturate( ( ( HeightFactor104 - 0.5 ) * 2 ) ));
			float4 DayGradient131 = lerpResult110;
			float4 lerpResult1383 = lerp( lerpResult133 , DayGradient131 , saturate( ( temp_output_1396_0 * ( smoothstepResult1389 - 0.5 ) ) ));
			float4 GradientColor93 = lerpResult1383;
			float3 ase_viewDirSafeWS = Unity_SafeNormalize( ase_viewVectorWS );
			float3 normalizeResult516 = normalize( ase_viewDirSafeWS );
			float3 normalizeResult517 = normalize( ase_lightDirWS );
			float dotResult518 = dot( normalizeResult516 , ( normalizeResult517 * -1.0 ) );
			float saferPower521 = abs( saturate( dotResult518 ) );
			float3 appendResult640 = (float3(cos( radians( ( ( _Time.y * _BackgroundRotationSpeed ) + _BackgroundRotation ) ) ) , 0.0 , ( sin( radians( ( ( _Time.y * _BackgroundRotationSpeed ) + _BackgroundRotation ) ) ) * -1.0 )));
			float lerpResult14 = lerp( 1.0 , ( unity_OrthoParams.y / unity_OrthoParams.x ) , unity_OrthoParams.w);
			half CAMERA_MODE17 = lerpResult14;
			float3 appendResult642 = (float3(0.0 , CAMERA_MODE17 , 0.0));
			float3 appendResult641 = (float3(sin( radians( ( ( _Time.y * _BackgroundRotationSpeed ) + _BackgroundRotation ) ) ) , 0.0 , cos( radians( ( ( _Time.y * _BackgroundRotationSpeed ) + _BackgroundRotation ) ) )));
			float3 normalizeResult646 = normalize( ase_positionWS );
			float3 appendResult619 = (float3(cos( radians( ( _BackgroundRotation + ( _BackgroundDistortionSpeed * _Time.y ) ) ) ) , 0.0 , ( sin( radians( ( _BackgroundRotation + ( _BackgroundDistortionSpeed * _Time.y ) ) ) ) * -1.0 )));
			float3 appendResult621 = (float3(0.0 , CAMERA_MODE17 , 0.0));
			float3 appendResult620 = (float3(sin( radians( ( _BackgroundRotation + ( _BackgroundDistortionSpeed * _Time.y ) ) ) ) , 0.0 , cos( radians( ( _BackgroundRotation + ( _BackgroundDistortionSpeed * _Time.y ) ) ) )));
			float3 normalizeResult624 = normalize( ase_positionWS );
			float4 texCUBENode631 = texCUBE( _NoiseCubemap, mul( float3x3( appendResult619, appendResult621, appendResult620 ), normalizeResult624 ) );
			float3 temp_output_648_0 = ( ( ( texCUBENode631.b - 0.5 ) * _BackgroundDistortionAmount ) * _BackgroundDistortionDirection );
			float3 normalizeResult663 = normalize( ( mul( float3x3( appendResult640, appendResult642, appendResult641 ), normalizeResult646 ) + temp_output_648_0 ) );
			float4 texCUBENode653 = texCUBE( _BackgroundCubemap, normalizeResult663 );
			half CubeEdgeMask_3660 = ( unity_ColorSpaceDouble.g * texCUBENode653.g * _BackgroundExposure * _BackgroundOpacity );
			float clampResult524 = clamp( ( pow( saferPower521 , _BackgroundSubsurfaceSharpness ) * CubeEdgeMask_3660 ) , 0.0 , _BackgroundSubsurfaceAmount );
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			float4 SubsurfDynamic_3529 = ( clampResult524 * ase_lightColor );
			float3 normalizeResult697 = normalize( ase_viewDirSafeWS );
			float3 appendResult1574 = (float3(ase_lightDirWS.x , ( ase_lightDirWS.y * -1.0 ) , ase_lightDirWS.z));
			float3 normalizeResult701 = normalize( appendResult1574 );
			float dotResult706 = dot( ( ( normalizeResult697 * -1.0 ) * _BackgroundSpecularAngle ) , ( normalizeResult701 * -1.0 ) );
			float saferPower709 = abs( saturate( dotResult706 ) );
			float CubeSpecMask_3659 = ( unity_ColorSpaceDouble.b * texCUBENode653.b * _BackgroundExposure * _BackgroundOpacity );
			float4 SpecularEmission_3719 = ( ( ( pow( saferPower709 , 2.5 ) * CubeSpecMask_3659 ) * ase_lightColor * _SpecularTint3 ) * _BackgroundSpecularIntensity );
			half CubeLumeMask_3661 = ( unity_ColorSpaceDouble.r * texCUBENode653.r * _BackgroundExposure );
			float4 lerpResult1002 = lerp( ( CubeLumeMask_3661 * ase_lightColor * _BackgroundTint1 ) , GradientColor93 , _BackgroundGradientBlend);
			float3 appendResult1151 = (float3(cos( radians( ( _BackgroundCoverageMaskRotation + ( _BackgroundCoverageMaskSpeed * _Time.y ) ) ) ) , 0.0 , ( sin( radians( ( _BackgroundCoverageMaskRotation + ( _BackgroundCoverageMaskSpeed * _Time.y ) ) ) ) * -1.0 )));
			float3 appendResult1153 = (float3(0.0 , CAMERA_MODE17 , 0.0));
			float3 appendResult1152 = (float3(sin( radians( ( _BackgroundCoverageMaskRotation + ( _BackgroundCoverageMaskSpeed * _Time.y ) ) ) ) , 0.0 , cos( radians( ( _BackgroundCoverageMaskRotation + ( _BackgroundCoverageMaskSpeed * _Time.y ) ) ) )));
			float3 normalizeResult1155 = normalize( ase_positionWS );
			float3 Noise_3_UV1174 = temp_output_648_0;
			float lerpResult1194 = lerp( 1.0 , ( 1.0 - texCUBE( _NoiseCubemap, ( mul( float3x3( appendResult1151, appendResult1153, appendResult1152 ), normalizeResult1155 ) + ( Noise_3_UV1174 * 5 ) ) ).a ) , ( _BackgroundCoverageStrength * 1.1 ));
			float CubeAlphaMask_3662 = ( texCUBENode653.a * _BackgroundOpacity );
			float Layer3_Alpha1164 = saturate( ( lerpResult1194 * CubeAlphaMask_3662 ) );
			float4 lerpResult979 = lerp( GradientColor93 , ( SubsurfDynamic_3529 + SpecularEmission_3719 + ( ( lerpResult1002 / max( Layer3_Alpha1164 , 1E-05 ) ) * Layer3_Alpha1164 ) ) , Layer3_Alpha1164);
			float3 normalizeResult500 = normalize( ase_viewDirSafeWS );
			float3 normalizeResult501 = normalize( ase_lightDirWS );
			float dotResult502 = dot( normalizeResult500 , ( normalizeResult501 * -1.0 ) );
			float saferPower506 = abs( saturate( dotResult502 ) );
			float3 appendResult574 = (float3(cos( radians( ( ( _Time.y * _MidgroundRotationSpeed ) + _MidgroundRotation ) ) ) , 0.0 , ( sin( radians( ( ( _Time.y * _MidgroundRotationSpeed ) + _MidgroundRotation ) ) ) * -1.0 )));
			float3 appendResult576 = (float3(0.0 , CAMERA_MODE17 , 0.0));
			float3 appendResult575 = (float3(sin( radians( ( ( _Time.y * _MidgroundRotationSpeed ) + _MidgroundRotation ) ) ) , 0.0 , cos( radians( ( ( _Time.y * _MidgroundRotationSpeed ) + _MidgroundRotation ) ) )));
			float3 normalizeResult580 = normalize( ase_positionWS );
			float3 appendResult553 = (float3(cos( radians( ( _MidgroundRotation + ( _MidgroundDistortionSpeed * _Time.y ) ) ) ) , 0.0 , ( sin( radians( ( _MidgroundRotation + ( _MidgroundDistortionSpeed * _Time.y ) ) ) ) * -1.0 )));
			float3 appendResult555 = (float3(0.0 , CAMERA_MODE17 , 0.0));
			float3 appendResult554 = (float3(sin( radians( ( _MidgroundRotation + ( _MidgroundDistortionSpeed * _Time.y ) ) ) ) , 0.0 , cos( radians( ( _MidgroundRotation + ( _MidgroundDistortionSpeed * _Time.y ) ) ) )));
			float3 normalizeResult558 = normalize( ase_positionWS );
			float4 texCUBENode565 = texCUBE( _NoiseCubemap, mul( float3x3( appendResult553, appendResult555, appendResult554 ), normalizeResult558 ) );
			float3 temp_output_582_0 = ( ( ( texCUBENode565.g - 0.5 ) * _MidgroundDistortionAmount ) * _MidgroundDistortionDirection );
			float3 normalizeResult597 = normalize( ( mul( float3x3( appendResult574, appendResult576, appendResult575 ), normalizeResult580 ) + temp_output_582_0 ) );
			float4 texCUBENode587 = texCUBE( _MidgroundCubemap, normalizeResult597 );
			half CubeEdgeMask_2594 = ( unity_ColorSpaceDouble.g * texCUBENode587.g * _MidgroundExposure * _MidgroundOpacity );
			float clampResult510 = clamp( ( pow( saferPower506 , _MidgroundSubsurfaceSharpness ) * CubeEdgeMask_2594 ) , 0.0 , _MidgroundSubsurfaceAmount );
			float4 SubsurfDynamic_2513 = ( clampResult510 * ase_lightColor );
			float3 normalizeResult673 = normalize( ase_viewDirSafeWS );
			float3 appendResult1577 = (float3(ase_lightDirWS.x , ( ase_lightDirWS.y * -1.0 ) , ase_lightDirWS.z));
			float3 normalizeResult677 = normalize( appendResult1577 );
			float dotResult682 = dot( ( ( normalizeResult673 * -1.0 ) * _MidgroundSpecularAngle ) , ( normalizeResult677 * -1.0 ) );
			float saferPower685 = abs( saturate( dotResult682 ) );
			float CubeSpecMask_2593 = ( unity_ColorSpaceDouble.b * texCUBENode587.b * _MidgroundExposure * _MidgroundOpacity );
			float4 SpecularEmission_2695 = ( ( ( pow( saferPower685 , 2.5 ) * CubeSpecMask_2593 ) * ase_lightColor * _SpecularTint2 ) * _MidgroundSpecularIntensity );
			half CubeLumeMask_2595 = ( unity_ColorSpaceDouble.r * texCUBENode587.r * _MidgroundExposure );
			float4 lerpResult1003 = lerp( ( CubeLumeMask_2595 * ase_lightColor * _MidgroundTint1 ) , GradientColor93 , _MidgroundGradientBlend);
			float3 appendResult1122 = (float3(cos( radians( ( _MidgroundCoverageMaskRotation + ( _MidgroundCoverageMaskSpeed * _Time.y ) ) ) ) , 0.0 , ( sin( radians( ( _MidgroundCoverageMaskRotation + ( _MidgroundCoverageMaskSpeed * _Time.y ) ) ) ) * -1.0 )));
			float3 appendResult1124 = (float3(0.0 , CAMERA_MODE17 , 0.0));
			float3 appendResult1123 = (float3(sin( radians( ( _MidgroundCoverageMaskRotation + ( _MidgroundCoverageMaskSpeed * _Time.y ) ) ) ) , 0.0 , cos( radians( ( _MidgroundCoverageMaskRotation + ( _MidgroundCoverageMaskSpeed * _Time.y ) ) ) )));
			float3 normalizeResult1126 = normalize( ase_positionWS );
			float3 Noise_2_UV1173 = temp_output_582_0;
			float lerpResult1190 = lerp( 1.0 , ( 1.0 - texCUBE( _NoiseCubemap, ( mul( float3x3( appendResult1122, appendResult1124, appendResult1123 ), normalizeResult1126 ) + ( Noise_2_UV1173 * 5 ) ) ).a ) , ( _MidgroundCoverageStrength * 1.1 ));
			float CubeAlphaMask_2596 = ( texCUBENode587.a * _MidgroundOpacity );
			float Layer2_Alpha1135 = saturate( ( lerpResult1190 * CubeAlphaMask_2596 ) );
			float4 lerpResult983 = lerp( lerpResult979 , ( SubsurfDynamic_2513 + SpecularEmission_2695 + ( ( lerpResult1003 / max( Layer2_Alpha1135 , 1E-05 ) ) * Layer2_Alpha1135 ) ) , Layer2_Alpha1135);
			float3 normalizeResult378 = normalize( ase_viewDirSafeWS );
			float3 normalizeResult380 = normalize( ase_lightDirWS );
			float dotResult381 = dot( normalizeResult378 , ( normalizeResult380 * -1.0 ) );
			float saferPower387 = abs( saturate( dotResult381 ) );
			float3 appendResult27 = (float3(cos( radians( ( ( _Time.y * _ForegroundRotationSpeed ) + _ForegroundRotation ) ) ) , 0.0 , ( sin( radians( ( ( _Time.y * _ForegroundRotationSpeed ) + _ForegroundRotation ) ) ) * -1.0 )));
			float3 appendResult29 = (float3(0.0 , CAMERA_MODE17 , 0.0));
			float3 appendResult30 = (float3(sin( radians( ( ( _Time.y * _ForegroundRotationSpeed ) + _ForegroundRotation ) ) ) , 0.0 , cos( radians( ( ( _Time.y * _ForegroundRotationSpeed ) + _ForegroundRotation ) ) )));
			float3 normalizeResult33 = normalize( ase_positionWS );
			float3 appendResult321 = (float3(cos( radians( ( _ForegroundRotation + ( _ForegroundDistortionSpeed * _Time.y ) ) ) ) , 0.0 , ( sin( radians( ( _ForegroundRotation + ( _ForegroundDistortionSpeed * _Time.y ) ) ) ) * -1.0 )));
			float3 appendResult323 = (float3(0.0 , CAMERA_MODE17 , 0.0));
			float3 appendResult322 = (float3(sin( radians( ( _ForegroundRotation + ( _ForegroundDistortionSpeed * _Time.y ) ) ) ) , 0.0 , cos( radians( ( _ForegroundRotation + ( _ForegroundDistortionSpeed * _Time.y ) ) ) )));
			float3 normalizeResult326 = normalize( ase_positionWS );
			float4 texCUBENode274 = texCUBE( _NoiseCubemap, mul( float3x3( appendResult321, appendResult323, appendResult322 ), normalizeResult326 ) );
			float3 temp_output_305_0 = ( ( ( texCUBENode274.r - 0.5 ) * _ForegroundDistortionAmount ) * _ForegroundDistortionDirection );
			float3 normalizeResult306 = normalize( ( mul( float3x3( appendResult27, appendResult29, appendResult30 ), normalizeResult33 ) + temp_output_305_0 ) );
			float4 texCUBENode51 = texCUBE( _ForegroundCubemap, normalizeResult306 );
			half CubeEdgeMask_1390 = ( unity_ColorSpaceDouble.g * texCUBENode51.g * _ForegroundExposure * _ForegroundOpacity );
			float clampResult417 = clamp( ( pow( saferPower387 , _ForegroundSubsurfaceSharpness ) * CubeEdgeMask_1390 ) , 0.0 , _ForegroundSubsurfaceAmount );
			float4 SubsurfDynamic_1385 = ( clampResult417 * ase_lightColor );
			float3 normalizeResult435 = normalize( ase_viewDirSafeWS );
			float3 appendResult1582 = (float3(ase_lightDirWS.x , ( ase_lightDirWS.y * -1.0 ) , ase_lightDirWS.z));
			float3 normalizeResult436 = normalize( appendResult1582 );
			float dotResult443 = dot( ( ( normalizeResult435 * -1.0 ) * _ForegroundSpecularAngle ) , ( normalizeResult436 * -1.0 ) );
			float saferPower447 = abs( saturate( dotResult443 ) );
			float CubeSpecMask_1392 = ( unity_ColorSpaceDouble.b * texCUBENode51.b * _ForegroundExposure * _ForegroundOpacity );
			float4 SpecularEmission_1455 = ( ( ( pow( saferPower447 , 2.5 ) * CubeSpecMask_1392 ) * ase_lightColor * _SpecularTint1 ) * _ForegroundSpecularIntensity );
			half CubeLumeMask_165 = ( unity_ColorSpaceDouble.r * texCUBENode51.r * _ForegroundExposure );
			float4 lerpResult1004 = lerp( ( CubeLumeMask_165 * ase_lightColor * _ForegroundTint1 ) , GradientColor93 , _ForegroundGradientBlend);
			float3 appendResult1090 = (float3(cos( radians( ( _ForegroundCoverageMaskRotation + ( _ForegroundCoverageMaskSpeed * _Time.y ) ) ) ) , 0.0 , ( sin( radians( ( _ForegroundCoverageMaskRotation + ( _ForegroundCoverageMaskSpeed * _Time.y ) ) ) ) * -1.0 )));
			float3 appendResult1092 = (float3(0.0 , CAMERA_MODE17 , 0.0));
			float3 appendResult1091 = (float3(sin( radians( ( _ForegroundCoverageMaskRotation + ( _ForegroundCoverageMaskSpeed * _Time.y ) ) ) ) , 0.0 , cos( radians( ( _ForegroundCoverageMaskRotation + ( _ForegroundCoverageMaskSpeed * _Time.y ) ) ) )));
			float3 normalizeResult1094 = normalize( ase_positionWS );
			float3 Noise_1_UV1171 = temp_output_305_0;
			float lerpResult1185 = lerp( 1.0 , ( 1.0 - texCUBE( _NoiseCubemap, ( mul( float3x3( appendResult1090, appendResult1092, appendResult1091 ), normalizeResult1094 ) + ( Noise_1_UV1171 * 5 ) ) ).a ) , ( _ForegroundCoverageStrength * 1.1 ));
			float CubeAlphaMask_1164 = ( texCUBENode51.a * _ForegroundOpacity );
			float Layer1_Alpha1082 = saturate( ( lerpResult1185 * CubeAlphaMask_1164 ) );
			float4 lerpResult988 = lerp( lerpResult983 , ( SubsurfDynamic_1385 + SpecularEmission_1455 + ( ( lerpResult1004 / max( Layer1_Alpha1082 , 1E-05 ) ) * Layer1_Alpha1082 ) ) , Layer1_Alpha1082);
			float3 normalizeResult143 = normalize( ase_viewDirWS );
			float3 normalizeResult146 = normalize( ase_lightDirWS );
			float dotResult144 = dot( normalizeResult143 , ( normalizeResult146 * -1.0 ) );
			float _NoiseR1362 = texCUBENode274.r;
			float saferPower420 = abs( saturate( dotResult144 ) );
			float4 SunEmission155 = ( ( ( pow( ( 1.0 - saturate( ( ( ( 1.0 - dotResult144 ) / max(  (0.0 + ( _SunScale - 0.0 ) * ( 0.025 - 0.0 ) / ( 1.0 - 0.0 ) ) , 1E-05 ) ) + ( ( _NoiseR1362 - 0.5 ) * _SunDistortion ) ) ) ) , _SunSharpness ) + ( saturate( pow( saferPower420 , _SunRimSharpness ) ) * _SunRimIntensity ) ) * ( _SunIntensity * _SunTint * ase_lightColor ) ) * saturate( normalizeResult146.y ) );
			float _CubeAlphaMaskCombined802 = max( max( Layer1_Alpha1082 , Layer2_Alpha1135 ) , Layer3_Alpha1164 );
			float saferPower1036 = abs( ( 1.0 - _CubeAlphaMaskCombined802 ) );
			float temp_output_1036_0 = pow( saferPower1036 , 2.0 );
			#ifdef _ENABLESUN_ON
				float4 staticSwitch1583 = ( lerpResult988 + ( SunEmission155 * temp_output_1036_0 ) );
			#else
				float4 staticSwitch1583 = lerpResult988;
			#endif
			float3 normalizeResult1224 = normalize( ase_lightDirWS );
			float3 temp_output_1226_0 = ( normalizeResult1224 * -1.0 );
			#if defined( _MOONDIRECTION_LIGHTDIRECTION )
				float3 staticSwitch1588 = normalizeResult1224;
			#elif defined( _MOONDIRECTION_LIGHTDIRECTIONOPPOSITE )
				float3 staticSwitch1588 = temp_output_1226_0;
			#else
				float3 staticSwitch1588 = normalizeResult1224;
			#endif
			float3 temp_output_1229_0 = cross( staticSwitch1588 , float3( 0, 1, 0 ) );
			float3 appendResult1554 = (float3(cos( radians( _MoonOffsetRotation ) ) , 0.0 , ( sin( radians( _MoonOffsetRotation ) ) * -1.0 )));
			float3 appendResult1556 = (float3(0.0 , CAMERA_MODE17 , 0.0));
			float3 appendResult1555 = (float3(sin( radians( _MoonOffsetRotation ) ) , 0.0 , cos( radians( _MoonOffsetRotation ) )));
			float3 normalizeResult1558 = normalize( ase_positionWS );
			float3 _SkyDirection1197 = mul( float3x3( appendResult1554, appendResult1556, appendResult1555 ), normalizeResult1558 );
			float3 normalizeResult1245 = normalize( _SkyDirection1197 );
			float dotResult1232 = dot( temp_output_1229_0 , normalizeResult1245 );
			float dotResult1233 = dot( cross( temp_output_1229_0 , temp_output_1226_0 ) , normalizeResult1245 );
			float2 appendResult1216 = (float2(( ( ( ( dotResult1232 * _MoonDistance ) + _MoonOffset.x ) * 0.5 ) + 0.5 ) , ( ( ( ( dotResult1233 * _MoonDistance ) + _MoonOffset.y ) * 0.5 ) + 0.5 )));
			float dotResult1205 = dot( normalizeResult1245 , staticSwitch1588 );
			float saferPower1207 = abs( saturate( ( dotResult1205 * -1 ) ) );
			float4 _Moon1219 = ( ( ( tex2D( _MoonTexture, appendResult1216 ) * saturate( pow( saferPower1207 , _MoonSharpness ) ) ) * _MoonIntensity ) * _MoonColor );
			#ifdef _ENABLEMOON_ON
				float4 staticSwitch1584 = ( ( temp_output_1036_0 * _Moon1219 ) + staticSwitch1583 );
			#else
				float4 staticSwitch1584 = staticSwitch1583;
			#endif
			float3 normalizeResult1062 = normalize( ase_positionWS );
			float temp_output_1566_0 = ( ( ( -1.0 * normalizeResult1062.y ) + 1.0 ) * 0.5 );
			float temp_output_1070_0 =  (0.0 + ( ( 1.0 - temp_output_1566_0 ) - 0.0 ) * ( 1.0 - 0.0 ) / ( _FogHeight1 - 0.0 ) );
			float temp_output_1073_0 = saturate( temp_output_1070_0 );
			half Fog66 = temp_output_1073_0;
			float4 lerpResult70 = lerp( unity_FogColor , staticSwitch1584 , Fog66);
			#ifdef _ENABLEFOG_ON
				float4 staticSwitch72 = lerpResult70;
			#else
				float4 staticSwitch72 = staticSwitch1584;
			#endif
			o.Emission = staticSwitch72.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Universal Render Pipeline/Unlit"
}
/*ASEBEGIN
Version=19905
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;598;-2112,1872;Inherit;False;3396;1155;;54;650;649;648;647;646;645;644;643;642;641;640;639;638;637;636;635;634;633;632;631;630;629;628;627;626;625;624;623;622;621;620;619;618;617;616;615;614;613;612;611;610;609;608;606;605;604;603;601;600;599;665;667;1400;1494;Cubemap_3 Noise & Rotation;0,0.4980392,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;532;-2112,608;Inherit;False;3396;1155;;54;584;583;582;581;580;579;578;577;576;575;574;573;572;571;570;569;568;567;566;565;564;563;562;561;560;559;558;557;556;555;554;553;552;551;550;549;548;547;546;545;544;543;542;540;539;538;537;535;534;533;664;666;1401;1493;Cubemap_2 Noise & Rotation;0,0.4980392,1,1;0;0
Node;AmplifyShaderEditor.SimpleTimeNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;600;-2064,2480;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;599;-2064,2576;Inherit;False;Property;_BackgroundDistortionSpeed;Background Distortion Speed;48;0;Create;True;0;0;0;False;0;False;1.25;-1.31;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;431;-2112,-656;Inherit;False;3396;1155;;54;311;310;309;4;312;328;3;329;2;5;313;314;7;315;316;317;318;319;320;9;321;322;323;324;12;325;326;15;16;18;19;20;21;22;25;27;30;29;26;32;33;303;37;327;274;494;300;308;302;298;305;304;1362;1402;Cubemap_1 Noise & Rotation;0,0.4980392,1,1;0;0
Node;AmplifyShaderEditor.SimpleTimeNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;534;-2064,1216;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;533;-2064,1312;Inherit;False;Property;_MidgroundDistortionSpeed;Midground Distortion Speed;54;0;Create;True;0;0;0;False;0;False;1.25;-1.31;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;601;-1856,2464;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;310;-2064,-48;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;311;-2064,48;Inherit;False;Property;_ForegroundDistortionSpeed;Foreground Distortion Speed;60;0;Create;True;0;0;0;False;0;False;1.25;-1.31;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;535;-1856,1200;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;603;-1648,2464;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;309;-1856,-64;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;537;-1648,1200;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RadiansOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;604;-1520,2464;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1181;1566,2622;Inherit;False;3845.813;1853.638;;105;1170;1163;1169;1168;1194;1134;1080;1190;1185;1162;1195;1193;1133;1081;1187;1160;1191;1189;1188;1186;1167;1192;1079;1131;1130;1077;1159;1178;1129;1076;1175;1158;1177;1128;1176;1096;1179;1127;1126;1095;1094;1180;1157;1125;1124;1123;1122;1093;1092;1091;1090;1156;1155;1121;1120;1119;1118;1117;1116;1103;1089;1088;1087;1086;1085;1152;1154;1153;1151;1115;1114;1084;1083;1113;1102;1148;1149;1150;1147;1146;1145;1112;1101;1144;1143;1142;1111;1100;1141;1136;1110;1104;1099;1140;1109;1108;1098;1097;1165;1139;1138;1137;1527;1528;1529;Coverage Masks;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1338;-2096,7792;Inherit;False;3995.427;2004.82;;81;1225;1224;1227;1226;1200;1588;1199;1542;1543;1540;1561;1560;1559;1558;1557;1556;1555;1554;1553;1552;1551;1550;1549;1548;1547;1546;1545;1544;1539;1319;1318;1323;1217;1204;1562;1563;1218;1275;1228;1223;1303;1207;1342;1302;1201;1256;1216;1301;1293;1261;1242;1241;1300;1294;1287;1284;1205;1243;1239;1240;1299;1295;1238;1237;1283;1236;1235;1234;1280;1202;1233;1232;1277;1231;1245;1279;1229;1278;1334;1337;1335;Moon;1,1,0,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;312;-1648,-64;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RadiansOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;538;-1520,1200;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;609;-1024,2608;Half;False;Constant;_Float34;Float 26;50;0;Create;True;0;0;0;False;0;False;-1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;610;-1024,2544;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RelayNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;606;-1344,2464;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;605;-2064,1920;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;665;-2064,2016;Half;False;Property;_BackgroundRotationSpeed;Background Rotation Speed;12;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;6;-2096,-1616;Inherit;False;891.8574;203.0713;Switch between Perspective / Orthographic camera;4;14;11;10;8;Camera Mode;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleTimeNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1137;1760,3920;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1138;1616,4016;Inherit;False;Property;_BackgroundCoverageMaskSpeed;Background Coverage Mask Speed;51;0;Create;True;0;0;0;False;0;False;1.25;-1.31;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1539;-1296,9536;Half;False;Property;_MoonOffsetRotation;Moon Offset Rotation;87;1;[IntRange];Create;True;0;0;0;False;0;False;0;24;0;360;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;667;-2064,2256;Half;False;Property;_BackgroundRotation;Background Rotation;11;1;[IntRange];Create;True;0;0;0;False;0;False;0;24;0;360;0;1;FLOAT;0
Node;AmplifyShaderEditor.RadiansOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;328;-1520,-64;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RelayNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;540;-1344,1200;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;543;-1024,1344;Half;False;Constant;_Float30;Float 26;50;0;Create;True;0;0;0;False;0;False;-1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;544;-1024,1280;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;539;-2064,656;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;664;-2064,752;Half;False;Property;_MidgroundRotationSpeed;Midground Rotation Speed;24;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;612;-832,2544;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;613;-1024,2704;Inherit;False;17;CAMERA_MODE;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;614;-1024,2784;Half;False;Constant;_Float35;Float 27;50;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CosOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;615;-1024,2928;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;616;-1024,2864;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CosOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;617;-1024,2480;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;608;-1856,1920;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1108;1760,3344;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1109;1616,3440;Inherit;False;Property;_MidgroundCoverageMaskSpeed;Midground Coverage Mask Speed;57;0;Create;True;0;0;0;False;0;False;1.25;-1.31;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OrthoParams, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;8;-2048,-1568;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1139;1968,3904;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1165;1840,3824;Half;False;Property;_BackgroundCoverageMaskRotation;Background Coverage Mask Rotation;50;1;[IntRange];Create;True;0;0;0;False;0;False;0;24;0;360;0;1;FLOAT;0
Node;AmplifyShaderEditor.RadiansOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1544;-752,9232;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;666;-2064,976;Half;False;Property;_MidgroundRotation;Midground Rotation;23;1;[IntRange];Create;True;0;0;0;False;0;False;0;24;0;360;0;1;FLOAT;0
Node;AmplifyShaderEditor.RelayNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;329;-1344,-64;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;313;-1024,80;Half;False;Constant;_Float28;Float 26;50;0;Create;True;0;0;0;False;0;False;-1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;314;-1024,16;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;546;-832,1280;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;547;-1024,1440;Inherit;False;17;CAMERA_MODE;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;548;-1024,1520;Half;False;Constant;_Float31;Float 27;50;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CosOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;549;-1024,1664;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;550;-1024,1600;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CosOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;551;-1024,1216;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;3;-2064,-608;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;2;-2064,-512;Half;False;Property;_ForegroundRotationSpeed;Foreground Rotation Speed;36;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;542;-1856,656;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1097;1760,2768;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;619;-640,2480;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;620;-640,2880;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;621;-640,2688;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldPosInputsNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;622;-400,2704;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1098;1616,2864;Inherit;False;Property;_ForegroundCoverageMaskSpeed;Foreground Coverage Mask Speed;63;0;Create;True;0;0;0;False;0;False;1.25;-1.31;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;611;-1648,1920;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1110;1968,3328;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1136;1840,3248;Half;False;Property;_MidgroundCoverageMaskRotation;Midground Coverage Mask Rotation;56;1;[IntRange];Create;True;0;0;0;False;0;False;0;24;0;360;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;10;-1600,-1568;Half;False;Constant;_Float7;Float 7;47;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;11;-1744,-1568;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1140;2176,3904;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;480;-240,-1616;Inherit;True;Property;_NoiseCubemap;Noise Cubemap;46;2;[Header];[NoScaleOffset];Create;True;1;Noise;0;0;False;1;Space(8);False;None;None;False;white;LockedToCube;Cube;False;-1;0;2;SAMPLERCUBE;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RelayNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1545;-576,9232;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1546;-256,9376;Half;False;Constant;_Float46;Float 26;50;0;Create;True;0;0;0;False;0;False;-1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1547;-256,9312;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;4;-2064,-304;Half;False;Property;_ForegroundRotation;Foreground Rotation;35;1;[IntRange];Create;True;0;0;0;False;0;False;0;24;0;360;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;315;-832,16;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;316;-1024,176;Inherit;False;17;CAMERA_MODE;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;317;-1024,256;Half;False;Constant;_Float29;Float 27;50;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CosOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;318;-1024,400;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;319;-1024,336;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CosOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;320;-1024,-48;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;553;-640,1216;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;554;-640,1616;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;555;-640,1424;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldPosInputsNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;556;-400,1440;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;5;-1856,-608;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;545;-1648,656;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1099;1968,2752;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;624;-224,2704;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.MatrixFromVectors, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;625;-400,2480;Inherit;False;FLOAT3x3;0;4;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;1;FLOAT3x3;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1104;1840,2672;Half;False;Property;_ForegroundCoverageMaskRotation;Foreground Coverage Mask Rotation;62;1;[IntRange];Create;True;0;0;0;False;0;False;0;24;0;360;0;1;FLOAT;0
Node;AmplifyShaderEditor.RadiansOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;618;-1520,1920;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1111;2176,3328;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;140;-2096,3136;Inherit;False;1044;579;;9;92;98;89;90;91;88;95;97;96;Height Factor;1,0,0.2470588,1;0;0
Node;AmplifyShaderEditor.LerpOp, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;14;-1408,-1568;Inherit;False;3;0;FLOAT;1;False;1;FLOAT;0.5;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RadiansOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1141;2304,3904;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;488;0,-1616;Inherit;False;_CubemapNoise;-1;True;1;0;SAMPLERCUBE;0;False;1;SAMPLERCUBE;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1548;-64,9312;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1549;-256,9472;Inherit;False;17;CAMERA_MODE;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1550;-256,9552;Half;False;Constant;_Float49;Float 27;50;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CosOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1551;-256,9696;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1552;-256,9632;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CosOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1553;-256,9248;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;321;-640,-48;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;322;-640,352;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;323;-640,160;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldPosInputsNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;324;-400,176;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NormalizeNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;558;-224,1440;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.MatrixFromVectors, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;559;-400,1216;Inherit;False;FLOAT3x3;0;4;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;1;FLOAT3x3;0
Node;AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;7;-1648,-608;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RadiansOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;552;-1520,656;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1100;2176,2752;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;628;-64,2480;Inherit;False;2;2;0;FLOAT3x3;0,0,0,1,1,1,1,0,1;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;629;-48,2224;Inherit;False;488;_CubemapNoise;1;0;OBJECT;;False;1;SAMPLERCUBE;0
Node;AmplifyShaderEditor.RelayNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;623;-1344,1920;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;626;-1024,2064;Half;False;Constant;_Float36;Float 26;50;0;Create;True;0;0;0;False;0;False;-1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;627;-1024,2000;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RadiansOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1112;2304,3328;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;96;-2048,3296;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;17;-1136,-1568;Half;False;CAMERA_MODE;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RelayNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1142;2480,3904;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1143;2800,4048;Half;False;Constant;_Float42;Float 26;50;0;Create;True;0;0;0;False;0;False;-1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1144;2800,3984;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1554;128,9248;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1555;128,9648;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1556;128,9456;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldPosInputsNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1557;368,9472;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NormalizeNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;326;-224,176;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.MatrixFromVectors, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;325;-400,-48;Inherit;False;FLOAT3x3;0;4;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;1;FLOAT3x3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;562;-64,1216;Inherit;False;2;2;0;FLOAT3x3;0,0,0,1,1,1,1,0,1;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;563;-48,960;Inherit;False;488;_CubemapNoise;1;0;OBJECT;;False;1;SAMPLERCUBE;0
Node;AmplifyShaderEditor.RadiansOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;9;-1520,-608;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RelayNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;557;-1344,656;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;560;-1024,800;Half;False;Constant;_Float32;Float 26;50;0;Create;True;0;0;0;False;0;False;-1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;561;-1024,736;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RadiansOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1101;2304,2752;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;630;288,2464;Inherit;False;Constant;_Float12;Float 10;22;0;Create;True;0;0;0;False;0;False;0.5;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;631;192,2224;Inherit;True;Property;_NoiseTex3;NoiseTex1;11;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;None;4f0fc98df3791f448bfae38a27a9e849;True;0;False;white;LockedToCube;False;Object;-1;Auto;Cube;False;8;0;SAMPLERCUBE;;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;632;-832,2000;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;633;-1024,2160;Inherit;False;17;CAMERA_MODE;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;634;-1024,2240;Half;False;Constant;_Float37;Float 27;50;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CosOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;635;-1024,2384;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;636;-1024,2320;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CosOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;637;-1024,1936;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RelayNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1113;2480,3328;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1114;2800,3472;Half;False;Constant;_Float40;Float 26;50;0;Create;True;0;0;0;False;0;False;-1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1115;2800,3408;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;97;-1840,3296;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1145;2992,3984;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1146;2800,4144;Inherit;False;17;CAMERA_MODE;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1147;2800,4224;Half;False;Constant;_Float43;Float 27;50;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CosOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1150;2800,3920;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1149;2800,4304;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CosOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1148;2800,4368;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1558;544,9472;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.MatrixFromVectors, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1559;368,9248;Inherit;False;FLOAT3x3;0;4;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;1;FLOAT3x3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;327;-64,-48;Inherit;False;2;2;0;FLOAT3x3;0,0,0,1,1,1,1,0,1;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;494;-48,-304;Inherit;False;488;_CubemapNoise;1;0;OBJECT;;False;1;SAMPLERCUBE;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;564;288,1200;Inherit;False;Constant;_Float11;Float 10;22;0;Create;True;0;0;0;False;0;False;0.5;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;565;192,960;Inherit;True;Property;_NoiseTex2;NoiseTex1;11;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;None;4f0fc98df3791f448bfae38a27a9e849;True;0;False;white;LockedToCube;False;Object;-1;Auto;Cube;False;8;0;SAMPLERCUBE;;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.RelayNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;12;-1344,-608;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;15;-1024,-464;Half;False;Constant;_Float26;Float 26;50;0;Create;True;0;0;0;False;0;False;-1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;16;-1024,-528;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;566;-832,736;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;567;-1024,896;Inherit;False;17;CAMERA_MODE;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;568;-1024,976;Half;False;Constant;_Float33;Float 27;50;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CosOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;569;-1024,1120;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;570;-1024,1056;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CosOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;571;-1024,672;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RelayNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1102;2480,2752;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1083;2800,2896;Half;False;Constant;_Float38;Float 26;50;0;Create;True;0;0;0;False;0;False;-1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1084;2800,2832;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;638;528,2272;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;639;480,2464;Inherit;False;Property;_BackgroundDistortionAmount;Background Distortion Amount;47;0;Create;True;0;0;0;False;1;Space(8);False;0;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;640;-640,1936;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;641;-640,2336;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;642;-640,2144;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldPosInputsNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;643;-400,2160;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1116;2992,3408;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1117;2800,3568;Inherit;False;17;CAMERA_MODE;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1118;2800,3648;Half;False;Constant;_Float41;Float 27;50;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CosOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1119;2800,3792;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1120;2800,3728;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CosOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1121;2800,3344;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;98;-1664,3296;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;89;-1712,3440;Inherit;False;Constant;_Float2;Float 2;17;0;Create;True;0;0;0;False;0;False;-1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;90;-1712,3520;Inherit;False;Constant;_Float3;Float 3;17;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;91;-1712,3600;Inherit;False;Constant;_Float4;Float 4;17;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;497;5632,-672;Inherit;False;2228.769;1542.498;;72;715;714;713;691;453;712;711;710;690;689;454;452;718;709;688;687;686;449;474;450;708;707;694;685;451;447;706;684;683;448;446;705;682;443;703;702;701;681;716;699;679;678;677;495;439;436;698;697;692;676;675;496;434;442;696;674;673;441;435;672;433;438;1575;1574;700;1576;1577;1578;1579;1580;1581;1582;Highlights;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;160;-2096,6784;Inherit;False;3289.63;888.4248;;40;1333;154;150;1320;1332;152;149;1331;425;248;151;153;423;407;424;426;148;408;420;422;460;404;403;405;394;144;170;143;146;171;142;145;1358;1356;1363;1357;1350;1415;1416;1417;Sun;1,1,0,1;0;0
Node;AmplifyShaderEditor.DynamicAppendNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1151;3184,3920;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1153;3184,4128;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldPosInputsNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1154;3424,4144;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1152;3184,4320;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1174;1328,2272;Inherit;False;Noise_3_UV;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1335;896,9200;Inherit;False;292;163;Sky Direction;1;1197;;1,0,0.4980392,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1560;720,9248;Inherit;False;2;2;0;FLOAT3x3;0,0,0,1,1,1,1,0,1;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1227;-2016,8240;Inherit;False;True;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1225;-1728,8064;Inherit;False;Constant;_Negative7;Negative;21;0;Create;True;0;0;0;False;0;False;-1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;308;288,-64;Inherit;False;Constant;_Float10;Float 10;22;0;Create;True;0;0;0;False;0;False;0.5;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;274;192,-304;Inherit;True;Property;_NoiseTex1;NoiseTex1;11;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;None;4f0fc98df3791f448bfae38a27a9e849;True;0;False;white;LockedToCube;False;Object;-1;Auto;Cube;False;8;0;SAMPLERCUBE;;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SimpleSubtractOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;572;528,1008;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;573;480,1200;Inherit;False;Property;_MidgroundDistortionAmount;Midground Distortion Amount;53;0;Create;True;0;0;0;False;1;Space(8);False;0;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;18;-832,-528;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;19;-1024,-368;Inherit;False;17;CAMERA_MODE;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;20;-1024,-288;Half;False;Constant;_Float27;Float 27;50;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CosOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;21;-1024,-144;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;22;-1024,-208;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CosOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;25;-1024,-592;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;574;-640,672;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;575;-640,1072;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;576;-640,880;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldPosInputsNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;577;-400,896;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1085;2992,2832;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1086;2800,2992;Inherit;False;17;CAMERA_MODE;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1087;2800,3072;Half;False;Constant;_Float39;Float 27;50;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CosOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1088;2800,3216;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1089;2800,3152;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CosOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1103;2800,2768;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;644;704,2272;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;645;704,2400;Inherit;False;Property;_BackgroundDistortionDirection;Background Distortion Direction;49;0;Create;True;0;0;0;False;0;False;0,0,1;0.1,0,0.1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NormalizeNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;646;-224,2160;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.MatrixFromVectors, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;647;-400,1936;Inherit;False;FLOAT3x3;0;4;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;1;FLOAT3x3;0
Node;AmplifyShaderEditor.DynamicAppendNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1122;3184,3344;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1123;3184,3744;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1124;3184,3552;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldPosInputsNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1125;3424,3568;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TFHCRemapNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;88;-1440,3296;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1173;1328,1008;Inherit;False;Noise_2_UV;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1576;5776,752;Inherit;False;Constant;_Float54;Float 54;86;0;Create;True;0;0;0;False;0;False;-1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;145;-2032,7072;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NormalizeNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1155;3600,4144;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.MatrixFromVectors, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1156;3424,3920;Inherit;False;FLOAT3x3;0;4;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;1;FLOAT3x3;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1180;3776,4048;Inherit;False;1174;Noise_3_UV;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1197;944,9248;Inherit;False;_SkyDirection;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1226;-1456,8240;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalizeNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1224;-1728,8240;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;300;528,-256;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;298;480,-64;Inherit;False;Property;_ForegroundDistortionAmount;Foreground Distortion Amount;59;0;Create;True;0;0;0;False;1;Space(8);False;0;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;578;704,1008;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;579;704,1136;Inherit;False;Property;_MidgroundDistortionDirection;Midground Distortion Direction;55;0;Create;True;0;0;0;False;0;False;0,0,1;0.1,0,0.1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;27;-640,-592;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;30;-640,-192;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;29;-640,-384;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldPosInputsNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;26;-400,-368;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NormalizeNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;580;-224,896;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.MatrixFromVectors, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;581;-400,672;Inherit;False;FLOAT3x3;0;4;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;1;FLOAT3x3;0
Node;AmplifyShaderEditor.DynamicAppendNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1090;3184,2768;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1091;3184,3168;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1092;3184,2976;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldPosInputsNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1093;3424,2992;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;648;928,2272;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1171;1328,-256;Inherit;False;Noise_1_UV;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;649;-48,1936;Inherit;False;2;2;0;FLOAT3x3;0,0,0,1,1,1,1,0,1;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalizeNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1126;3600,3568;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.MatrixFromVectors, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1127;3424,3344;Inherit;False;FLOAT3x3;0;4;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;1;FLOAT3x3;0
Node;AmplifyShaderEditor.OneMinusNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;95;-1232,3296;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1177;3776,3472;Inherit;False;1173;Noise_2_UV;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;696;5680,384;Inherit;False;World;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;427;3552,-656;Inherit;False;1718.411;1444.259;;48;383;507;511;527;526;525;524;523;522;521;518;517;516;515;503;512;510;508;506;502;501;500;499;476;475;417;418;384;387;388;381;380;378;379;1424;1422;1425;1426;1423;1427;1428;1429;1430;1532;1531;1533;1535;1534;Fake Subsurface Effect;1,1,1,1;0;0
Node;AmplifyShaderEditor.TexturePropertyNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;485;-736,-1616;Inherit;True;Property;_BackgroundCubemap;Background Cubemap;10;2;[Header];[NoScaleOffset];Create;True;1;Background;0;0;False;1;Space(8);False;None;None;False;white;LockedToCube;Cube;False;-1;0;2;SAMPLERCUBE;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;700;5680,592;Inherit;False;True;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1575;5952,736;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1579;5776,272;Inherit;False;Constant;_Float55;Float 54;86;0;Create;True;0;0;0;False;0;False;-1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;142;-2000,6912;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;171;-1792,7152;Inherit;False;Constant;_Negative;Negative;21;0;Create;True;0;0;0;False;0;False;-1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;146;-1792,7072;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1157;3776,3920;Inherit;False;2;2;0;FLOAT3x3;0,0,0,1,1,1,1,0,1;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ScaleNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1527;3968,4048;Inherit;False;5;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1199;-832,8000;Inherit;False;1197;_SkyDirection;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1588;-1264,8064;Inherit;False;Property;_MoonDirection;Moon Direction;88;0;Create;True;0;0;0;False;0;False;0;0;0;True;;KeywordEnum;2;LightDirection;LightDirectionOpposite;Create;True;True;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector3Node, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1200;-1104,7888;Inherit;False;Constant;_FixedDirection;Fixed Direction;77;0;Create;True;0;0;0;False;0;False;0,1,0;0,1,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;302;704,-256;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;304;704,-128;Inherit;False;Property;_ForegroundDistortionDirection;Foreground Distortion Direction;61;0;Create;True;0;0;0;False;0;False;0,0,1;0.1,0,0.1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;582;928,1008;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalizeNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;33;-224,-368;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.MatrixFromVectors, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;32;-400,-592;Inherit;False;FLOAT3x3;0;4;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;1;FLOAT3x3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;583;-48,672;Inherit;False;2;2;0;FLOAT3x3;0,0,0,1,1,1,1,0,1;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TexturePropertyNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;483;-736,-1840;Inherit;True;Property;_MidgroundCubemap;Midground Cubemap;22;2;[Header];[NoScaleOffset];Create;True;1;Midground;0;0;False;1;Space(8);False;None;None;False;white;LockedToCube;Cube;False;-1;0;2;SAMPLERCUBE;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.NormalizeNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1094;3600,2992;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.MatrixFromVectors, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1095;3424,2768;Inherit;False;FLOAT3x3;0;4;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;1;FLOAT3x3;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1176;3776,2896;Inherit;False;1171;Noise_1_UV;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;672;5680,-96;Inherit;False;World;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;650;1136,1936;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;141;-2096,3824;Inherit;False;1603.987;2843.074;;55;1393;1395;1389;1386;1385;1396;1390;1384;133;1387;1365;135;134;1383;110;1379;120;82;116;108;1378;1377;1376;83;129;119;113;115;74;106;1375;1374;1373;1372;75;107;128;124;111;109;1371;1370;127;122;112;114;105;1369;1368;1367;126;125;123;1364;1394;Sky Gradients;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1128;3776,3344;Inherit;False;2;2;0;FLOAT3x3;0,0,0,1,1,1,1,0,1;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ScaleNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1528;3968,3472;Inherit;False;5;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;698;5888,464;Inherit;False;Constant;_Negative5;Negative;21;0;Create;True;0;0;0;False;0;False;-1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;697;5888,384;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;515;3616,576;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;484;-496,-1616;Inherit;False;_Cubemap3;-1;True;1;0;SAMPLERCUBE;;False;1;SAMPLERCUBE;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;104;-1008,3296;Inherit;False;HeightFactor;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;676;5680,112;Inherit;False;True;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1574;6144,592;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1578;5952,256;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1580;5760,-208;Inherit;False;Constant;_Float56;Float 54;86;0;Create;True;0;0;0;False;0;False;-1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1058;1568,1872;Inherit;False;1044;643;;9;653;654;652;656;657;658;655;1056;1057;Cubemap_3 Mask Split;1,1,1,1;0;0
Node;AmplifyShaderEditor.NormalizeNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;143;-1792,6912;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;170;-1616,7072;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;394;-1792,6992;Inherit;False;Property;_SunScale;Sun Scale;74;0;Create;True;0;0;0;False;0;False;0.3;0.001;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1362;528,-352;Inherit;False;_NoiseR;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1158;3712,3840;Inherit;False;488;_CubemapNoise;1;0;OBJECT;;False;1;SAMPLERCUBE;0
Node;AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1179;4112,3920;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CrossProductOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1229;-768,7888;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalizeNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1245;-544,7952;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CrossProductOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1231;-544,8048;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;305;928,-256;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TexturePropertyNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;479;-736,-2064;Inherit;True;Property;_ForegroundCubemap;Foreground Cubemap;34;2;[Header];[NoScaleOffset];Create;True;1;Foreground;0;0;False;1;Space(8);False;None;None;False;white;LockedToCube;Cube;False;-1;0;2;SAMPLERCUBE;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;37;-48,-592;Inherit;False;2;2;0;FLOAT3x3;0,0,0,1,1,1,1,0,1;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;584;1136,672;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;482;-496,-1840;Inherit;False;_Cubemap2;-1;True;1;0;SAMPLERCUBE;;False;1;SAMPLERCUBE;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1059;1568,608;Inherit;False;1044;643;;9;587;588;590;591;592;589;1052;586;1053;Cubemap_2 Mask Split;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1096;3776,2768;Inherit;False;2;2;0;FLOAT3x3;0,0,0,1,1,1,1,0,1;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ScaleNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1529;3968,2896;Inherit;False;5;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;433;5680,-576;Inherit;False;World;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NormalizeNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;673;5888,-96;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;674;5888,-16;Inherit;False;Constant;_Negative3;Negative;21;0;Create;True;0;0;0;False;0;False;-1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;670;1344,1872;Inherit;False;484;_Cubemap3;1;0;OBJECT;;False;1;SAMPLERCUBE;0
Node;AmplifyShaderEditor.NormalizeNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;663;1360,1952;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1129;3712,3264;Inherit;False;488;_CubemapNoise;1;0;OBJECT;;False;1;SAMPLERCUBE;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1367;-2048,5792;Inherit;False;104;HeightFactor;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1178;4112,3344;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;699;6064,384;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;499;3616,96;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NormalizeNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;517;3856,576;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1423;3856,656;Inherit;False;Constant;_Negative8;Negative;21;0;Create;True;0;0;0;False;0;False;-1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1534;3616,384;Inherit;False;World;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;125;-1776,5136;Inherit;False;104;HeightFactor;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;126;-1776,5216;Inherit;False;Constant;_Float6;Float 5;19;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1368;-1776,5872;Inherit;False;104;HeightFactor;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1369;-1776,5952;Inherit;False;Constant;_Float45;Float 5;19;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;123;-2048,5056;Inherit;False;104;HeightFactor;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;716;6048,496;Inherit;False;Property;_BackgroundSpecularAngle;Background Specular Angle;18;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;434;5680,-368;Inherit;False;True;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NormalizeNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;701;6320,592;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;702;6320,672;Inherit;False;Constant;_Negative6;Negative;21;0;Create;True;0;0;0;False;0;False;-1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1577;6144,112;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1581;5936,-224;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;144;-1424,6912;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1350;-1152,7024;Inherit;False;1362;_NoiseR;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1358;-1152,7152;Inherit;False;Constant;_Float19;Float 19;83;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1417;-1424,7104;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;0.025;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1159;4256,3840;Inherit;True;Property;_NoiseTex6;NoiseTex1;11;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;None;4f0fc98df3791f448bfae38a27a9e849;True;0;False;white;LockedToCube;False;Object;-1;Auto;Cube;False;8;0;SAMPLERCUBE;;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1056;2432,2352;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1160;4256,4048;Inherit;False;Property;_BackgroundCoverageStrength;Background Coverage Strength;52;0;Create;True;0;0;0;False;0;False;0.75;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1232;-272,7888;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1233;-272,8000;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1202;-336,8096;Inherit;False;Property;_MoonDistance;Moon Distance;83;0;Create;True;0;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;303;1136,-592;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;481;-496,-2064;Inherit;False;_Cubemap1;-1;True;1;0;SAMPLERCUBE;;False;1;SAMPLERCUBE;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1060;1552,-656;Inherit;False;1060;643;;9;51;55;139;389;63;73;391;1054;1055;Cubemap_1 Mask Split;1,1,1,1;0;0
Node;AmplifyShaderEditor.NormalizeNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;597;1360,688;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;669;1344,608;Inherit;False;482;_Cubemap2;1;0;OBJECT;;False;1;SAMPLERCUBE;0
Node;AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1175;4112,2768;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1076;3712,2688;Inherit;False;488;_CubemapNoise;1;0;OBJECT;;False;1;SAMPLERCUBE;0
Node;AmplifyShaderEditor.NormalizeNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;435;5888,-576;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;441;5888,-496;Inherit;False;Constant;_Negative2;Negative;21;0;Create;True;0;0;0;False;0;False;-1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;675;6064,-96;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;653;1616,1936;Inherit;True;Property;_Tex2;Cubemap (HDR);9;1;[NoScaleOffset];Create;False;0;0;0;False;0;False;-1;None;47267f1c47854894b873ffb58ac0d7ab;True;0;False;black;LockedToCube;False;Object;-1;Auto;Cube;False;8;0;SAMPLERCUBE;;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1052;2432,1088;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1130;4256,3264;Inherit;True;Property;_NoiseTex5;NoiseTex1;11;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;None;4f0fc98df3791f448bfae38a27a9e849;True;0;False;white;LockedToCube;False;Object;-1;Auto;Cube;False;8;0;SAMPLERCUBE;;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;705;6496,592;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;703;6384,384;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1364;-2048,6240;Inherit;False;True;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1394;-1952,6400;Inherit;False;Constant;_Float48;Float 48;87;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorSpaceDouble, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;654;1824,2144;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NormalizeNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;516;3856,384;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;379;3616,-384;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NormalizeNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;501;3856,96;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1427;3856,176;Inherit;False;Constant;_Negative9;Negative;21;0;Create;True;0;0;0;False;0;False;-1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1422;4016,576;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1535;3616,-96;Inherit;False;World;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;114;-1776,4400;Inherit;False;104;HeightFactor;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;112;-1776,4480;Inherit;False;Constant;_Float5;Float 5;19;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;122;-1824,5056;Inherit;False;2;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1370;-1824,5792;Inherit;False;2;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;127;-1552,5136;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1371;-1552,5872;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;652;1968,2320;Inherit;False;Property;_BackgroundExposure;Background Exposure;16;0;Create;True;0;0;0;False;0;False;0.165;0.25;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1057;1968,2400;Inherit;False;Property;_BackgroundOpacity;Background Opacity;15;0;Create;True;0;0;0;False;0;False;1;0.25;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1131;4256,3472;Inherit;False;Property;_MidgroundCoverageStrength;Midground Coverage Strength;58;0;Create;True;0;0;0;False;0;False;0.75;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;692;6048,16;Inherit;False;Property;_MidgroundSpecularAngle;Midground Specular Angle;30;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;105;-2048,4320;Inherit;False;104;HeightFactor;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;677;6320,112;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;678;6320,192;Inherit;False;Constant;_Negative4;Negative;21;0;Create;True;0;0;0;False;0;False;-1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1582;6128,-368;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.OneMinusNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;403;-1296,6912;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1357;-928,7008;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1416;-928,7232;Inherit;False;Property;_SunDistortion;Sun Distortion;79;0;Create;True;0;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;405;-1280,6992;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;1E-05;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1192;4576,3952;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;662;2624,2352;Inherit;False;CubeAlphaMask_3;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1193;4576,4048;Inherit;False;1.1;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1195;4576,3840;Inherit;False;Constant;_Float18;Float 0;76;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1234;-80,7888;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1235;-80,8000;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1236;-112,8112;Inherit;False;Property;_MoonOffset;Moon Offset;86;0;Create;True;0;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;668;1344,-656;Inherit;False;481;_Cubemap1;1;0;OBJECT;;False;1;SAMPLERCUBE;0
Node;AmplifyShaderEditor.NormalizeNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;306;1360,-576;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;587;1616,672;Inherit;True;Property;_Tex1;Cubemap (HDR);8;1;[NoScaleOffset];Create;False;0;0;0;False;0;False;-1;None;47267f1c47854894b873ffb58ac0d7ab;True;0;False;black;LockedToCube;False;Object;-1;Auto;Cube;False;8;0;SAMPLERCUBE;;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1053;1968,1136;Inherit;False;Property;_MidgroundOpacity;Midground Opacity;27;0;Create;True;0;0;0;False;0;False;1;0.25;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1054;2432,-176;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1077;4256,2688;Inherit;True;Property;_NoiseTex4;NoiseTex1;11;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;None;4f0fc98df3791f448bfae38a27a9e849;True;0;False;white;LockedToCube;False;Object;-1;Auto;Cube;False;8;0;SAMPLERCUBE;;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1079;4256,2896;Inherit;False;Property;_ForegroundCoverageStrength;Foreground Coverage Strength;64;0;Create;True;0;0;0;False;0;False;0.75;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;442;6064,-576;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;681;6496,112;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;679;6384,-96;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;596;2624,1088;Inherit;False;CubeAlphaMask_2;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1188;4576,3376;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1189;4576,3472;Inherit;False;1.1;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1191;4576,3264;Inherit;False;Constant;_Float1;Float 0;76;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;655;2432,2208;Inherit;False;4;4;0;FLOAT;1;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;706;6752,384;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1393;-1776,6272;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorSpaceDouble, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;588;1824,880;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;656;2432,2064;Inherit;False;4;4;0;FLOAT;1;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;518;4192,384;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;500;3856,-96;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalizeNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;380;3856,-384;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1429;3856,-304;Inherit;False;Constant;_Negative10;Negative;21;0;Create;True;0;0;0;False;0;False;-1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1428;4016,96;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1533;3616,-576;Inherit;False;World;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ScaleNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;109;-1824,4320;Inherit;False;2;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;124;-1680,5056;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1372;-1680,5792;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1374;-1824,5408;Inherit;False;Property;_NadirColorTwilight;Nadir Color Twilight;6;0;Create;True;0;0;0;False;0;False;1,1,1,1;0,0,0,1;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1375;-1824,5600;Inherit;False;Property;_EquatorColorTwilight;Equator Color Twilight;5;0;Create;True;0;0;0;False;0;False;1,1,1,1;0.1833519,0,0.5566037,1;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SimpleSubtractOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;111;-1552,4400;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;128;-1408,5136;Inherit;False;2;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1373;-1408,5872;Inherit;False;2;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;107;-1824,4672;Inherit;False;Property;_NadirColorNight;Nadir Color Night;9;0;Create;True;0;0;0;False;0;False;1,1,1,1;0,0,0,1;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;75;-1824,4864;Inherit;False;Property;_EquatorColorNight;Equator Color Night;8;0;Create;True;0;0;0;False;0;False;1,1,1,1;0.1833519,0,0.5566037,1;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;586;1968,1056;Inherit;False;Property;_MidgroundExposure;Midground Exposure;28;0;Create;True;0;0;0;False;0;False;0.165;0.25;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;496;6048,-464;Inherit;False;Property;_ForegroundSpecularAngle;Foreground Specular Angle;42;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;436;6320,-368;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;439;6320,-288;Inherit;False;Constant;_Negative1;Negative;21;0;Create;True;0;0;0;False;0;False;-1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;404;-1136,6912;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1415;-716.5945,7128.372;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1194;4864,4000;Inherit;False;3;0;FLOAT;1;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1162;4544,4160;Inherit;False;662;CubeAlphaMask_3;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1237;112,7888;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1238;112,8048;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;51;1600,-608;Inherit;True;Property;_Tex;Cubemap (HDR);10;1;[NoScaleOffset];Create;False;0;0;0;False;0;False;-1;None;47267f1c47854894b873ffb58ac0d7ab;True;0;False;black;LockedToCube;False;Object;-1;Auto;Cube;False;8;0;SAMPLERCUBE;;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1055;1968,-128;Inherit;False;Property;_ForegroundOpacity;Foreground Opacity;39;0;Create;True;0;0;0;False;0;False;1;0.25;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;164;2624,-176;Inherit;False;CubeAlphaMask_1;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1167;4576,2800;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1186;4576,2688;Inherit;False;Constant;_Float0;Float 0;76;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1187;4576,2896;Inherit;False;1.1;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;671;-2112,-1296;Inherit;False;1915.954;540.3046;;19;1072;1075;1074;1073;1071;1070;1069;1068;1067;1066;1065;1064;1063;1062;1061;1564;1565;1566;1568;Fog Effect;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;438;6496,-368;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;495;6384,-576;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;589;2432,944;Inherit;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;682;6752,-96;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1133;4544,3584;Inherit;False;596;CubeAlphaMask_2;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1395;-1616,6288;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1190;4864,3424;Inherit;False;3;0;FLOAT;1;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;659;2624,2208;Inherit;False;CubeSpecMask_3;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;707;6896,384;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;657;2432,1920;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorSpaceDouble, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;55;1808,-400;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;590;2432,800;Inherit;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;660;2624,2064;Half;False;CubeEdgeMask_3;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;502;4192,-96;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1424;4368,384;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;378;3856,-576;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1430;4016,-384;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;106;-1824,3936;Inherit;False;Property;_NadirColorDay;Nadir Color Day;3;0;Create;True;0;0;0;False;0;False;1,1,1,1;0.009583672,0,0.3018867,1;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;74;-1824,4128;Inherit;False;Property;_EquatorColorDay;Equator Color Day;2;0;Create;True;0;0;0;False;0;False;1,1,1,1;0,1,0.9887413,1;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SaturateNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;115;-1680,4320;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;113;-1408,4400;Inherit;False;2;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;119;-1408,4672;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;129;-1264,5136;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;83;-1408,4864;Inherit;False;Property;_ZenithColorNight;Zenith Color Night;7;1;[Header];Create;True;1;Night Time Colors;0;0;False;1;Space (8);False;0,0,0,1;0,0.04576007,0.3867924,1;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.LerpOp, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1376;-1408,5408;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1377;-1264,5872;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1378;-1408,5600;Inherit;False;Property;_ZenithColorTwilight;Zenith Color Twilight;4;1;[Header];Create;True;1;Zenith Colors;0;0;False;1;Space (8);False;0,0,0,1;0,0.04576007,0.3867924,1;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;139;1968,-208;Inherit;False;Property;_ForegroundExposure;Foreground Exposure;40;0;Create;True;0;0;0;False;0;False;0.165;0.25;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;527;4192,512;Inherit;False;Property;_BackgroundSubsurfaceSharpness;Background Subsurface Sharpness;21;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;708;6752,496;Inherit;False;Constant;_BackgroundSpecularSharpness;Background Specular Sharpness;20;0;Create;True;0;0;0;False;0;False;2.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;460;-1264,7376;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;422;-1296,7456;Inherit;False;Property;_SunRimSharpness;Sun Rim Sharpness;77;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1356;-576,6912;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1163;5056,4112;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1205;-336,8256;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1240;272,8000;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1239;272,7888;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1243;272,8112;Inherit;False;Constant;_Float20;Float 19;81;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1081;4544,3008;Inherit;False;164;CubeAlphaMask_1;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1185;4864,2848;Inherit;False;3;0;FLOAT;1;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1061;-2064,-1232;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;391;2432,-320;Inherit;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;443;6752,-576;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;593;2624,944;Inherit;False;CubeSpecMask_2;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;683;6896,-96;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1389;-1488,6368;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.1;False;2;FLOAT;0.9;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1386;-1488,6560;Inherit;False;Constant;_Float47;Float 47;86;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1349;-7136,-3120;Inherit;False;2306.031;2080.704;;55;995;996;999;1505;1504;1503;1502;1501;1500;1499;1498;1497;988;983;992;991;987;986;979;990;1013;985;1010;981;1345;980;1011;1012;1032;1009;1008;1005;1006;1028;950;1033;1004;951;1003;1029;1024;1035;1034;1001;1000;1030;1031;998;997;1025;1002;1027;1026;994;993;Layer Blending;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;591;2432,656;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1134;5056,3536;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;709;7072,384;Inherit;False;True;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;718;6896,592;Inherit;False;659;CubeSpecMask_3;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;661;2624,1920;Half;False;CubeLumeMask_3;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;389;2432,-464;Inherit;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;594;2624,800;Half;False;CubeEdgeMask_2;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;381;4192,-576;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1425;4368,-96;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;521;4544,384;Inherit;False;True;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;108;-1408,3936;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;116;-1264,4400;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;82;-1408,4128;Inherit;False;Property;_ZenithColorDay;Zenith Color Day;1;1;[Header];Create;True;1;Day Time Colors;0;0;False;1;Space (8);False;0,0,0,1;0,0.2358491,0.5660378,1;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.LerpOp, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;120;-1024,4672;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1379;-1024,5408;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;503;4192,32;Inherit;False;Property;_MidgroundSubsurfaceSharpness;Midground Subsurface Sharpness;33;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;522;4496,512;Inherit;False;660;CubeEdgeMask_3;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;684;6752,16;Inherit;False;Constant;_MidgroundSpecularSharpness;Midground Specular Sharpness;33;0;Create;True;0;0;0;False;0;False;2.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;420;-1088,7376;Inherit;False;True;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1363;-432,6912;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1339;2016,-1120;Inherit;False;596;355;;5;798;799;797;800;801;Combined Alpha Mask;1,1,1,1;0;0
Node;AmplifyShaderEditor.SaturateNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1170;5232,4112;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1261;-96,8256;Inherit;False;-1;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1340;-240,-1840;Inherit;True;Property;_MoonTexture;Moon Texture;81;1;[NoScaleOffset];Create;True;1;Moon;0;0;False;1;Space(8);False;None;None;False;white;LockedToTexture2D;Texture2D;False;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1341;0,-1840;Inherit;False;_MoonTex;-1;True;1;0;SAMPLER2D;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1241;464,7888;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1242;464,8048;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1080;5056,2960;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1062;-1888,-1232;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;392;2624,-320;Inherit;False;CubeSpecMask_1;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;446;6896,-576;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;685;7072,-96;Inherit;False;True;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;694;6896,112;Inherit;False;593;CubeSpecMask_2;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;63;2432,-608;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1380;-416,5408;Inherit;False;TwilightGradient;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ScaleNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1396;-1280,6368;Inherit;False;2;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1385;-1280,6528;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;595;2624,656;Half;False;CubeLumeMask_2;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1169;5232,3536;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;710;7248,384;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;390;2624,-464;Half;False;CubeEdgeMask_1;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;523;4720,384;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1426;4368,-576;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;506;4544,-96;Inherit;False;True;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;110;-1024,3936;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;388;4192,-448;Inherit;False;Property;_ForegroundSubsurfaceSharpness;Foreground Subsurface Sharpness;45;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;507;4496,32;Inherit;False;594;CubeEdgeMask_2;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LightColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;711;7184,496;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;712;7152,624;Inherit;False;Property;_SpecularTint3;Background Specular Tint;17;0;Create;False;0;0;0;False;1;Space(8);False;1,1,1,0;1,1,1,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1532;4192,608;Inherit;False;Property;_BackgroundSubsurfaceAmount;Background Subsurface Amount;20;0;Create;True;0;0;0;False;1;Space(8);False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;448;6752,-464;Inherit;False;Constant;_ForegroundSpecularSharpness;Foreground Specular Sharpness;46;0;Create;True;0;0;0;False;0;False;2.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;426;-912,7376;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;424;-1040,7488;Inherit;False;Property;_SunRimIntensity;Sun Rim Intensity;76;0;Create;True;0;0;0;False;0;False;0.5;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;408;-256,6912;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;148;-288,7136;Inherit;False;Property;_SunSharpness;Sun Sharpness;75;0;Create;True;0;0;0;False;0;False;1;1.44;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;798;2064,-976;Inherit;False;1135;Layer2_Alpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;799;2064,-1072;Inherit;False;1082;Layer1_Alpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1164;5456,4112;Inherit;False;Layer3_Alpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;995;-7072,-2800;Inherit;False;661;CubeLumeMask_3;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LightColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1498;-7072,-2704;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1499;-7072,-2560;Inherit;False;Property;_BackgroundTint1;Background Tint;13;0;Create;False;0;0;0;False;1;Space(8);False;1,1,1,0;1,1,1,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;132;-416,4672;Inherit;False;NightGradient;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1256;272,8256;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1201;240,8352;Inherit;False;Property;_MoonSharpness;Moon Sharpness;84;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1216;656,7888;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1342;640,8000;Inherit;False;1341;_MoonTex;1;0;OBJECT;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SaturateNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1168;5232,2960;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1063;-1744,-1232;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1572;-1852.213,-1382.378;Inherit;False;Constant;_Float53;Float 53;86;0;Create;True;0;0;0;False;0;False;-1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;447;7072,-576;Inherit;False;True;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;451;6896,-368;Inherit;False;392;CubeSpecMask_1;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;686;7248,-96;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;65;2624,-608;Half;False;CubeLumeMask_1;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;131;-416,3936;Inherit;False;DayGradient;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;134;-1168,6208;Inherit;False;132;NightGradient;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;135;-1168,6288;Inherit;False;1380;TwilightGradient;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1365;-1104,6368;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1387;-1104,6528;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1135;5456,3536;Inherit;False;Layer2_Alpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LightColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;525;4864,608;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;713;7472,384;Inherit;False;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;508;4720,-96;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;387;4544,-576;Inherit;False;True;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;524;4896,384;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;383;4496,-448;Inherit;False;390;CubeEdgeMask_1;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;714;7408,736;Inherit;False;Property;_BackgroundSpecularIntensity;Background Specular Intensity;19;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LightColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;687;7184,16;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;688;7152,144;Inherit;False;Property;_SpecularTint2;Midground Specular Tint;29;0;Create;False;0;0;0;False;1;Space(8);False;1,1,1,0;1,1,1,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1531;4192,128;Inherit;False;Property;_MidgroundSubsurfaceAmount;Midground Subsurface Amount;32;0;Create;True;0;0;0;False;1;Space(8);False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;407;-32,7024;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LightColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;248;-80,7424;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;153;-48,7200;Inherit;False;Property;_SunIntensity;Sun Intensity;78;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;423;-704,7376;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;797;2064,-880;Inherit;False;1164;Layer3_Alpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;800;2336,-1040;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;993;-6480,-2720;Inherit;False;93;GradientColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1026;-6448,-2560;Inherit;False;1164;Layer3_Alpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1027;-6416,-2480;Inherit;False;Constant;_Float8;Float 8;68;0;Create;True;0;0;0;False;0;False;1E-05;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1497;-6784,-2800;Inherit;False;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;996;-7072,-2160;Inherit;False;595;CubeLumeMask_2;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LightColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1500;-7072,-2064;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;994;-6544,-2640;Inherit;False;Property;_BackgroundGradientBlend;Background Gradient Blend;14;0;Create;True;0;0;0;False;0;False;0.5;0.67;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1501;-7072,-1920;Inherit;False;Property;_MidgroundTint1;Midground Tint;25;0;Create;False;0;0;0;False;1;Space(8);False;1,1,1,0;1,1,1,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.PowerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1207;592,8256;Inherit;False;True;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;151;-320,7344;Inherit;False;Property;_SunTint;Sun Tint;73;0;Create;True;1;Sun;0;0;False;1;Space(8);False;1,1,1,0;1,1,1,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1223;864,7888;Inherit;True;Property;_TextureSample0;Texture Sample 0;79;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;False;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1082;5456,2960;Inherit;False;Layer1_Alpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1565;-1808,-1088;Inherit;False;Constant;_Float51;Float 51;86;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1571;-1680,-1392;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;450;7248,-576;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LightColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;511;4864,128;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;689;7472,-96;Inherit;False;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;133;-896,6320;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1384;-960,6448;Inherit;False;131;DayGradient;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1390;-896,6528;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;526;5088,384;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;715;7680,384;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;384;4720,-576;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;510;4896,-96;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;690;7408,256;Inherit;False;Property;_MidgroundSpecularIntensity;Midground Specular Intensity;31;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LightColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;474;7184,-464;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;449;7152,-336;Inherit;False;Property;_SpecularTint1;Foreground Specular Tint;41;0;Create;False;0;0;0;False;1;Space(8);False;1,1,1,0;1,1,1,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;418;4192,-352;Inherit;False;Property;_ForegroundSubsurfaceAmount;Foreground Subsurface Amount;44;0;Create;True;0;0;0;False;1;Space(8);False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1331;-1584,7184;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;425;176,7024;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;149;144,7200;Inherit;False;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMaxOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;801;2464,-992;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1002;-6224,-2800;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMaxOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1025;-6192,-2560;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;997;-6480,-2080;Inherit;False;93;GradientColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1031;-6480,-1920;Inherit;False;1135;Layer2_Alpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1030;-6416,-1840;Inherit;False;Constant;_Float9;Float 8;68;0;Create;True;0;0;0;False;0;False;1E-05;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1502;-6784,-2160;Inherit;False;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;999;-7072,-1504;Inherit;False;65;CubeLumeMask_1;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LightColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1503;-7072,-1408;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1504;-7072,-1264;Inherit;False;Property;_ForegroundTint1;Foreground Tint;37;0;Create;False;0;0;0;False;1;Space(8);False;1,1,1,0;1,1,1,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;998;-6544,-2000;Inherit;False;Property;_MidgroundGradientBlend;Midground Gradient Blend;26;0;Create;True;0;0;0;False;0;False;0.5;0.67;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1228;800,8256;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1564;-1600,-1136;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1567;-1632.528,-975.6162;Inherit;False;Constant;_Float52;Float 52;86;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LightColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;475;4864,-352;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;452;7472,-576;Inherit;False;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;512;5088,-96;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;691;7680,-96;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1398;-466,6270;Inherit;False;292;163;;1;93;Final Gradient Lerp;1,0,0.4980392,1;0;0
Node;AmplifyShaderEditor.LerpOp, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1383;-704,6320;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;529;5328,384;Inherit;False;SubsurfDynamic_3;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;417;4896,-576;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;454;7408,-224;Inherit;False;Property;_ForegroundSpecularIntensity;Foreground Specular Intensity;43;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;719;7904,384;Inherit;False;SpecularEmission_3;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1332;-1296,7552;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;152;352,7024;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;802;2624,-992;Inherit;False;_CubeAlphaMaskCombined;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1000;-6480,-1424;Inherit;False;93;GradientColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1034;-6480,-1264;Inherit;False;1082;Layer1_Alpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1035;-6416,-1184;Inherit;False;Constant;_Float13;Float 8;68;0;Create;True;0;0;0;False;0;False;1E-05;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1024;-6032,-2800;Inherit;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMaxOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1029;-6192,-1920;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1003;-6224,-2160;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;951;-6192,-2448;Inherit;False;1164;Layer3_Alpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1505;-6784,-1504;Inherit;False;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1001;-6544,-1344;Inherit;False;Property;_ForegroundGradientBlend;Foreground Gradient Blend;38;0;Create;True;0;0;0;False;0;False;0.5;0.67;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1218;1392,7888;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1563;1200,8016;Inherit;False;Property;_MoonIntensity;Moon Intensity;85;0;Create;True;0;0;0;False;0;False;1;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1566;-1475.528,-1060.616;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;476;5088,-576;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;453;7680,-576;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;695;7904,-96;Inherit;False;SpecularEmission_2;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;513;5328,-96;Inherit;False;SubsurfDynamic_2;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;93;-416,6320;Inherit;False;GradientColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1320;992,7520;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1004;-6224,-1504;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMaxOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1033;-6192,-1264;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;950;-5872,-2800;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleDivideOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1028;-6032,-2160;Inherit;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1006;-6160,-2880;Inherit;False;719;SpecularEmission_3;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1005;-6128,-2960;Inherit;False;529;SubsurfDynamic_3;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;985;-6192,-1808;Inherit;False;1135;Layer2_Alpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1018;-5344,-960;Inherit;False;802;_CubeAlphaMaskCombined;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1562;1552,7888;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1204;1392,8128;Inherit;False;Property;_MoonColor;Moon Color;82;0;Create;True;0;0;0;False;0;False;1,1,1,0;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1068;-1296,-1120;Half;False;Constant;_Float15;Float 15;55;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1066;-1296,-1008;Half;False;Constant;_Float16;Float 16;55;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1064;-2064,-1008;Half;False;Property;_FogHeight1;Fog Height;68;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1569;-1360,-1344;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;455;7904,-576;Inherit;False;SpecularEmission_1;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;385;5328,-576;Inherit;False;SubsurfDynamic_1;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;155;1264,7520;Inherit;False;SunEmission;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1008;-6128,-2320;Inherit;False;513;SubsurfDynamic_2;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1009;-6160,-2240;Inherit;False;695;SpecularEmission_2;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleDivideOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1032;-6032,-1504;Inherit;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;980;-5776,-3040;Inherit;False;93;GradientColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1345;-5680,-2960;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;981;-5680,-2816;Inherit;False;1164;Layer3_Alpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;986;-5872,-2160;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;990;-6192,-1152;Inherit;False;1082;Layer1_Alpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1020;-5024,-960;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1037;-5024,-880;Inherit;False;Constant;_Float14;Float 14;68;0;Create;True;0;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1217;1712,7888;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCRemapNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1070;-1104,-1232;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1012;-6160,-1584;Inherit;False;455;SpecularEmission_1;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1011;-6128,-1664;Inherit;False;385;SubsurfDynamic_1;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1010;-5680,-2320;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;979;-5440,-3040;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;987;-5504,-2144;Inherit;False;1135;Layer2_Alpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;991;-5872,-1504;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1019;-4800,-1216;Inherit;False;155;SunEmission;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1036;-4800,-960;Inherit;False;True;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1219;1952,7888;Inherit;False;_Moon;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1073;-656,-1232;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1013;-5680,-1664;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;992;-5504,-1488;Inherit;False;1082;Layer1_Alpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;983;-5232,-2320;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1021;-4480,-1216;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1221;-4560,-880;Inherit;False;1219;_Moon;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;247;-3520,-1008;Inherit;False;580;323;;3;70;67;68;Fog;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;66;-128,-1232;Half;False;Fog;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;988;-5024,-1664;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1022;-4224,-1216;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1220;-4320,-960;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1222;-3696,-960;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FogAndAmbientColorsNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;68;-3456,-896;Inherit;False;unity_FogColor;0;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;67;-3424,-800;Inherit;False;66;Fog;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1583;-4000,-1216;Inherit;False;Property;_EnableSun;Enable Sun;72;0;Create;True;0;0;0;False;2;Header(Sun);Space(8);False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1337;-176,8512;Inherit;False;228;675;Fade Zones;6;1286;1288;1285;1296;1297;1289;;1,0,0.4980392,1;0;0
Node;AmplifyShaderEditor.LerpOp, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;70;-3104,-960;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1584;-3520,-1216;Inherit;False;Property;_EnableMoon;Enable Moon;80;0;Create;True;0;0;0;False;2;Header(Moon);Space(8);False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.BreakToComponentsNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1278;-816,8384;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.DynamicAppendNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1279;-672,8352;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LengthOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1277;-496,8352;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ATan2OpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1280;-336,8400;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1288;-128,8752;Inherit;False;Constant;_Float23;Float 23;83;0;Create;True;0;0;0;False;0;False;125;125;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1297;-128,9072;Inherit;False;Constant;_Float44;Float 44;86;0;Create;True;0;0;0;False;0;False;305;305;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1286;-128,8656;Inherit;False;Constant;_Float22;Float 22;82;0;Create;True;0;0;0;False;0;False;55;55;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1296;-128,8976;Inherit;False;Constant;_Float25;Float 25;85;0;Create;True;0;0;0;False;0;False;235;235;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DegreesOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1283;80,8400;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1285;-128,8560;Inherit;False;Constant;_Float21;Float 21;81;0;Create;True;0;0;0;False;0;False;15;15;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1289;-128,8880;Inherit;False;Constant;_Float24;Float 24;84;0;Create;True;0;0;0;False;0;False;195;195;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1295;336,8688;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1299;336,9008;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1284;336,8528;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1287;336,8848;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1294;512,8688;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1300;512,9008;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1293;688,8528;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1301;688,8848;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1302;880,8528;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1303;1024,8528;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1072;-848,-912;Half;False;Property;_FogFill;Fog Fill;67;0;Create;True;0;0;0;False;0;False;0.5;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1074;-656,-1120;Half;False;Constant;_Float17;Float 17;55;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1075;-400,-1200;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1065;-2064,-912;Half;False;Property;_FogSmoothness1;Fog Smoothness;66;0;Create;True;0;0;0;False;1;Space(8);False;0.01;0.01;0.01;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1069;-1040,-912;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1071;-848,-1232;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1573;-1459.437,-820.1047;Inherit;False;104;HeightFactor;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1568;-1456,-1168;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1067;-1296,-1232;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1494;528,2176;Inherit;False;_NoiseB;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;592;1616,880;Half;False;Property;_Tex_HDR1;DecodeInstructions;70;1;[HideInInspector];Create;False;0;0;0;True;0;False;0,0,0,0;1,1,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector4Node, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;73;1600,-400;Half;False;Property;_Tex_HDR;DecodeInstructions;71;1;[HideInInspector];Create;False;0;0;0;True;0;False;0,0,0,0;1,1,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1493;528,912;Inherit;False;_NoiseG;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;658;1616,2144;Half;False;Property;_Tex_HDR2;DecodeInstructions;69;1;[HideInInspector];Create;False;0;0;0;True;0;False;0,0,0,0;1,1,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;72;-2816,-1216;Float;False;Property;_EnableFog;Enable Fog;65;0;Create;True;0;0;0;False;2;Header(Fog);Space (8);False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.BreakToComponentsNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1323;-1008,8528;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SaturateNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1318;-848,8528;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1561;-1232,9440;Inherit;False;Constant;_Float50;Float 50;89;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1540;-1296,9232;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1543;-880,9232;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1542;-1088,9232;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1319;-624,8528;Inherit;False;_SunFade;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1275;1200,8128;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;0;-2496,-1264;Float;False;True;-1;2;;0;0;Unlit;ToonScapes/URP/Skybox;False;False;False;False;True;True;True;True;True;True;True;True;False;False;True;True;False;False;False;False;False;Off;0;False;;0;False;;False;0;False;;0;False;;False;0;Custom;0.5;True;False;0;True;Background;;Background;All;14;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;False;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;Universal Render Pipeline/Unlit;0;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1538;-880,-1616;Inherit;False;100;100;Comment;0;3;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1537;-880,-1840;Inherit;False;100;100;Comment;0;2;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1536;-880,-2064;Inherit;False;100;100;Comment;0;1;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;150;-16,6912;Inherit;False;100;100;SunMask;0;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;92;-1424,3184;Inherit;False;126.3361;100;Gradient Factor;0;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;154;368,6912;Inherit;False;100;100;SunEmission;0;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1333;1008,7408;Inherit;False;100;100;SunFade;0;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1334;608,8144;Inherit;False;100;100;MoonMask;0;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1399;4256,2480;Inherit;False;264.6436;100;;0;Alpha;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1400;192,2576;Inherit;False;264.6436;100;;0;Blue;0,0.4980392,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1401;192,1312;Inherit;False;264.6436;100;;0;Green;0,1,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1402;192,48;Inherit;False;264.6436;100;;0;Red;1,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1403;2864,-624;Inherit;False;264.6436;100;;0;Red;1,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1404;2864,-480;Inherit;False;264.6436;100;;0;Green;0,1,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1405;2864,-336;Inherit;False;264.6436;100;;0;Blue;0,0.4980392,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1406;2864,-192;Inherit;False;264.6436;100;;0;Alpha;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1407;2864,640;Inherit;False;264.6436;100;;0;Red;1,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1408;2864,784;Inherit;False;264.6436;100;;0;Green;0,1,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1409;2864,928;Inherit;False;264.6436;100;;0;Blue;0,0.4980392,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1410;2864,1072;Inherit;False;264.6436;100;;0;Alpha;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1411;2864,1904;Inherit;False;264.6436;100;;0;Red;1,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1412;2864,2048;Inherit;False;264.6436;100;;0;Green;0,1,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1413;2864,2192;Inherit;False;264.6436;100;;0;Blue;0,0.4980392,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1414;2864,2336;Inherit;False;264.6436;100;;0;Alpha;1,1,1,1;0;0
WireConnection;601;0;599;0
WireConnection;601;1;600;0
WireConnection;535;0;533;0
WireConnection;535;1;534;0
WireConnection;603;0;667;0
WireConnection;603;1;601;0
WireConnection;309;0;311;0
WireConnection;309;1;310;0
WireConnection;537;0;666;0
WireConnection;537;1;535;0
WireConnection;604;0;603;0
WireConnection;312;0;4;0
WireConnection;312;1;309;0
WireConnection;538;0;537;0
WireConnection;610;0;606;0
WireConnection;606;0;604;0
WireConnection;328;0;312;0
WireConnection;540;0;538;0
WireConnection;544;0;540;0
WireConnection;612;0;610;0
WireConnection;612;1;609;0
WireConnection;615;0;606;0
WireConnection;616;0;606;0
WireConnection;617;0;606;0
WireConnection;608;0;605;0
WireConnection;608;1;665;0
WireConnection;1139;0;1138;0
WireConnection;1139;1;1137;0
WireConnection;1544;0;1539;0
WireConnection;329;0;328;0
WireConnection;314;0;329;0
WireConnection;546;0;544;0
WireConnection;546;1;543;0
WireConnection;549;0;540;0
WireConnection;550;0;540;0
WireConnection;551;0;540;0
WireConnection;542;0;539;0
WireConnection;542;1;664;0
WireConnection;619;0;617;0
WireConnection;619;1;614;0
WireConnection;619;2;612;0
WireConnection;620;0;616;0
WireConnection;620;1;614;0
WireConnection;620;2;615;0
WireConnection;621;0;614;0
WireConnection;621;1;613;0
WireConnection;621;2;614;0
WireConnection;611;0;608;0
WireConnection;611;1;667;0
WireConnection;1110;0;1109;0
WireConnection;1110;1;1108;0
WireConnection;11;0;8;2
WireConnection;11;1;8;1
WireConnection;1140;0;1165;0
WireConnection;1140;1;1139;0
WireConnection;1545;0;1544;0
WireConnection;1547;0;1545;0
WireConnection;315;0;314;0
WireConnection;315;1;313;0
WireConnection;318;0;329;0
WireConnection;319;0;329;0
WireConnection;320;0;329;0
WireConnection;553;0;551;0
WireConnection;553;1;548;0
WireConnection;553;2;546;0
WireConnection;554;0;550;0
WireConnection;554;1;548;0
WireConnection;554;2;549;0
WireConnection;555;0;548;0
WireConnection;555;1;547;0
WireConnection;555;2;548;0
WireConnection;5;0;3;0
WireConnection;5;1;2;0
WireConnection;545;0;542;0
WireConnection;545;1;666;0
WireConnection;1099;0;1098;0
WireConnection;1099;1;1097;0
WireConnection;624;0;622;0
WireConnection;625;0;619;0
WireConnection;625;1;621;0
WireConnection;625;2;620;0
WireConnection;618;0;611;0
WireConnection;1111;0;1136;0
WireConnection;1111;1;1110;0
WireConnection;14;0;10;0
WireConnection;14;1;11;0
WireConnection;14;2;8;4
WireConnection;1141;0;1140;0
WireConnection;488;0;480;0
WireConnection;1548;0;1547;0
WireConnection;1548;1;1546;0
WireConnection;1551;0;1545;0
WireConnection;1552;0;1545;0
WireConnection;1553;0;1545;0
WireConnection;321;0;320;0
WireConnection;321;1;317;0
WireConnection;321;2;315;0
WireConnection;322;0;319;0
WireConnection;322;1;317;0
WireConnection;322;2;318;0
WireConnection;323;0;317;0
WireConnection;323;1;316;0
WireConnection;323;2;317;0
WireConnection;558;0;556;0
WireConnection;559;0;553;0
WireConnection;559;1;555;0
WireConnection;559;2;554;0
WireConnection;7;0;5;0
WireConnection;7;1;4;0
WireConnection;552;0;545;0
WireConnection;1100;0;1104;0
WireConnection;1100;1;1099;0
WireConnection;628;0;625;0
WireConnection;628;1;624;0
WireConnection;623;0;618;0
WireConnection;627;0;623;0
WireConnection;1112;0;1111;0
WireConnection;17;0;14;0
WireConnection;1142;0;1141;0
WireConnection;1144;0;1142;0
WireConnection;1554;0;1553;0
WireConnection;1554;1;1550;0
WireConnection;1554;2;1548;0
WireConnection;1555;0;1552;0
WireConnection;1555;1;1550;0
WireConnection;1555;2;1551;0
WireConnection;1556;0;1550;0
WireConnection;1556;1;1549;0
WireConnection;1556;2;1550;0
WireConnection;326;0;324;0
WireConnection;325;0;321;0
WireConnection;325;1;323;0
WireConnection;325;2;322;0
WireConnection;562;0;559;0
WireConnection;562;1;558;0
WireConnection;9;0;7;0
WireConnection;557;0;552;0
WireConnection;561;0;557;0
WireConnection;1101;0;1100;0
WireConnection;631;0;629;0
WireConnection;631;1;628;0
WireConnection;632;0;627;0
WireConnection;632;1;626;0
WireConnection;635;0;623;0
WireConnection;636;0;623;0
WireConnection;637;0;623;0
WireConnection;1113;0;1112;0
WireConnection;1115;0;1113;0
WireConnection;97;0;96;0
WireConnection;1145;0;1144;0
WireConnection;1145;1;1143;0
WireConnection;1150;0;1142;0
WireConnection;1149;0;1142;0
WireConnection;1148;0;1142;0
WireConnection;1558;0;1557;0
WireConnection;1559;0;1554;0
WireConnection;1559;1;1556;0
WireConnection;1559;2;1555;0
WireConnection;327;0;325;0
WireConnection;327;1;326;0
WireConnection;565;0;563;0
WireConnection;565;1;562;0
WireConnection;12;0;9;0
WireConnection;16;0;12;0
WireConnection;566;0;561;0
WireConnection;566;1;560;0
WireConnection;569;0;557;0
WireConnection;570;0;557;0
WireConnection;571;0;557;0
WireConnection;1102;0;1101;0
WireConnection;1084;0;1102;0
WireConnection;638;0;631;3
WireConnection;638;1;630;0
WireConnection;640;0;637;0
WireConnection;640;1;634;0
WireConnection;640;2;632;0
WireConnection;641;0;636;0
WireConnection;641;1;634;0
WireConnection;641;2;635;0
WireConnection;642;0;634;0
WireConnection;642;1;633;0
WireConnection;642;2;634;0
WireConnection;1116;0;1115;0
WireConnection;1116;1;1114;0
WireConnection;1119;0;1113;0
WireConnection;1120;0;1113;0
WireConnection;1121;0;1113;0
WireConnection;98;0;97;0
WireConnection;1151;0;1150;0
WireConnection;1151;1;1147;0
WireConnection;1151;2;1145;0
WireConnection;1153;0;1147;0
WireConnection;1153;1;1146;0
WireConnection;1153;2;1147;0
WireConnection;1152;0;1149;0
WireConnection;1152;1;1147;0
WireConnection;1152;2;1148;0
WireConnection;1174;0;648;0
WireConnection;1560;0;1559;0
WireConnection;1560;1;1558;0
WireConnection;274;0;494;0
WireConnection;274;1;327;0
WireConnection;572;0;565;2
WireConnection;572;1;564;0
WireConnection;18;0;16;0
WireConnection;18;1;15;0
WireConnection;21;0;12;0
WireConnection;22;0;12;0
WireConnection;25;0;12;0
WireConnection;574;0;571;0
WireConnection;574;1;568;0
WireConnection;574;2;566;0
WireConnection;575;0;570;0
WireConnection;575;1;568;0
WireConnection;575;2;569;0
WireConnection;576;0;568;0
WireConnection;576;1;567;0
WireConnection;576;2;568;0
WireConnection;1085;0;1084;0
WireConnection;1085;1;1083;0
WireConnection;1088;0;1102;0
WireConnection;1089;0;1102;0
WireConnection;1103;0;1102;0
WireConnection;644;0;638;0
WireConnection;644;1;639;0
WireConnection;646;0;643;0
WireConnection;647;0;640;0
WireConnection;647;1;642;0
WireConnection;647;2;641;0
WireConnection;1122;0;1121;0
WireConnection;1122;1;1118;0
WireConnection;1122;2;1116;0
WireConnection;1123;0;1120;0
WireConnection;1123;1;1118;0
WireConnection;1123;2;1119;0
WireConnection;1124;0;1118;0
WireConnection;1124;1;1117;0
WireConnection;1124;2;1118;0
WireConnection;88;0;98;1
WireConnection;88;1;89;0
WireConnection;88;2;91;0
WireConnection;88;3;90;0
WireConnection;88;4;91;0
WireConnection;1173;0;582;0
WireConnection;1155;0;1154;0
WireConnection;1156;0;1151;0
WireConnection;1156;1;1153;0
WireConnection;1156;2;1152;0
WireConnection;1197;0;1560;0
WireConnection;1226;0;1224;0
WireConnection;1226;1;1225;0
WireConnection;1224;0;1227;0
WireConnection;300;0;274;1
WireConnection;300;1;308;0
WireConnection;578;0;572;0
WireConnection;578;1;573;0
WireConnection;27;0;25;0
WireConnection;27;1;20;0
WireConnection;27;2;18;0
WireConnection;30;0;22;0
WireConnection;30;1;20;0
WireConnection;30;2;21;0
WireConnection;29;0;20;0
WireConnection;29;1;19;0
WireConnection;29;2;20;0
WireConnection;580;0;577;0
WireConnection;581;0;574;0
WireConnection;581;1;576;0
WireConnection;581;2;575;0
WireConnection;1090;0;1103;0
WireConnection;1090;1;1087;0
WireConnection;1090;2;1085;0
WireConnection;1091;0;1089;0
WireConnection;1091;1;1087;0
WireConnection;1091;2;1088;0
WireConnection;1092;0;1087;0
WireConnection;1092;1;1086;0
WireConnection;1092;2;1087;0
WireConnection;648;0;644;0
WireConnection;648;1;645;0
WireConnection;1171;0;305;0
WireConnection;649;0;647;0
WireConnection;649;1;646;0
WireConnection;1126;0;1125;0
WireConnection;1127;0;1122;0
WireConnection;1127;1;1124;0
WireConnection;1127;2;1123;0
WireConnection;95;0;88;0
WireConnection;1575;0;700;2
WireConnection;1575;1;1576;0
WireConnection;146;0;145;0
WireConnection;1157;0;1156;0
WireConnection;1157;1;1155;0
WireConnection;1527;0;1180;0
WireConnection;1588;1;1224;0
WireConnection;1588;0;1226;0
WireConnection;302;0;300;0
WireConnection;302;1;298;0
WireConnection;582;0;578;0
WireConnection;582;1;579;0
WireConnection;33;0;26;0
WireConnection;32;0;27;0
WireConnection;32;1;29;0
WireConnection;32;2;30;0
WireConnection;583;0;581;0
WireConnection;583;1;580;0
WireConnection;1094;0;1093;0
WireConnection;1095;0;1090;0
WireConnection;1095;1;1092;0
WireConnection;1095;2;1091;0
WireConnection;650;0;649;0
WireConnection;650;1;648;0
WireConnection;1128;0;1127;0
WireConnection;1128;1;1126;0
WireConnection;1528;0;1177;0
WireConnection;697;0;696;0
WireConnection;484;0;485;0
WireConnection;104;0;95;0
WireConnection;1574;0;700;1
WireConnection;1574;1;1575;0
WireConnection;1574;2;700;3
WireConnection;1578;0;676;2
WireConnection;1578;1;1579;0
WireConnection;143;0;142;0
WireConnection;170;0;146;0
WireConnection;170;1;171;0
WireConnection;1362;0;274;1
WireConnection;1179;0;1157;0
WireConnection;1179;1;1527;0
WireConnection;1229;0;1588;0
WireConnection;1229;1;1200;0
WireConnection;1245;0;1199;0
WireConnection;1231;0;1229;0
WireConnection;1231;1;1226;0
WireConnection;305;0;302;0
WireConnection;305;1;304;0
WireConnection;37;0;32;0
WireConnection;37;1;33;0
WireConnection;584;0;583;0
WireConnection;584;1;582;0
WireConnection;482;0;483;0
WireConnection;1096;0;1095;0
WireConnection;1096;1;1094;0
WireConnection;1529;0;1176;0
WireConnection;673;0;672;0
WireConnection;663;0;650;0
WireConnection;1178;0;1128;0
WireConnection;1178;1;1528;0
WireConnection;699;0;697;0
WireConnection;699;1;698;0
WireConnection;517;0;515;0
WireConnection;701;0;1574;0
WireConnection;1577;0;676;1
WireConnection;1577;1;1578;0
WireConnection;1577;2;676;3
WireConnection;1581;0;434;2
WireConnection;1581;1;1580;0
WireConnection;144;0;143;0
WireConnection;144;1;170;0
WireConnection;1417;0;394;0
WireConnection;1159;0;1158;0
WireConnection;1159;1;1179;0
WireConnection;1056;0;653;4
WireConnection;1056;1;1057;0
WireConnection;1232;0;1229;0
WireConnection;1232;1;1245;0
WireConnection;1233;0;1231;0
WireConnection;1233;1;1245;0
WireConnection;303;0;37;0
WireConnection;303;1;305;0
WireConnection;481;0;479;0
WireConnection;597;0;584;0
WireConnection;1175;0;1096;0
WireConnection;1175;1;1529;0
WireConnection;435;0;433;0
WireConnection;675;0;673;0
WireConnection;675;1;674;0
WireConnection;653;0;670;0
WireConnection;653;1;663;0
WireConnection;1052;0;587;4
WireConnection;1052;1;1053;0
WireConnection;1130;0;1129;0
WireConnection;1130;1;1178;0
WireConnection;705;0;701;0
WireConnection;705;1;702;0
WireConnection;703;0;699;0
WireConnection;703;1;716;0
WireConnection;516;0;1534;0
WireConnection;501;0;499;0
WireConnection;1422;0;517;0
WireConnection;1422;1;1423;0
WireConnection;122;0;123;0
WireConnection;1370;0;1367;0
WireConnection;127;0;125;0
WireConnection;127;1;126;0
WireConnection;1371;0;1368;0
WireConnection;1371;1;1369;0
WireConnection;677;0;1577;0
WireConnection;1582;0;434;1
WireConnection;1582;1;1581;0
WireConnection;1582;2;434;3
WireConnection;403;0;144;0
WireConnection;1357;0;1350;0
WireConnection;1357;1;1358;0
WireConnection;405;0;1417;0
WireConnection;1192;0;1159;4
WireConnection;662;0;1056;0
WireConnection;1193;0;1160;0
WireConnection;1234;0;1232;0
WireConnection;1234;1;1202;0
WireConnection;1235;0;1233;0
WireConnection;1235;1;1202;0
WireConnection;306;0;303;0
WireConnection;587;0;669;0
WireConnection;587;1;597;0
WireConnection;1054;0;51;4
WireConnection;1054;1;1055;0
WireConnection;1077;0;1076;0
WireConnection;1077;1;1175;0
WireConnection;442;0;435;0
WireConnection;442;1;441;0
WireConnection;681;0;677;0
WireConnection;681;1;678;0
WireConnection;679;0;675;0
WireConnection;679;1;692;0
WireConnection;596;0;1052;0
WireConnection;1188;0;1130;4
WireConnection;1189;0;1131;0
WireConnection;655;0;654;3
WireConnection;655;1;653;3
WireConnection;655;2;652;0
WireConnection;655;3;1057;0
WireConnection;706;0;703;0
WireConnection;706;1;705;0
WireConnection;1393;0;1364;2
WireConnection;1393;1;1394;0
WireConnection;656;0;654;2
WireConnection;656;1;653;2
WireConnection;656;2;652;0
WireConnection;656;3;1057;0
WireConnection;518;0;516;0
WireConnection;518;1;1422;0
WireConnection;500;0;1535;0
WireConnection;380;0;379;0
WireConnection;1428;0;501;0
WireConnection;1428;1;1427;0
WireConnection;109;0;105;0
WireConnection;124;0;122;0
WireConnection;1372;0;1370;0
WireConnection;111;0;114;0
WireConnection;111;1;112;0
WireConnection;128;0;127;0
WireConnection;1373;0;1371;0
WireConnection;436;0;1582;0
WireConnection;404;0;403;0
WireConnection;404;1;405;0
WireConnection;1415;0;1357;0
WireConnection;1415;1;1416;0
WireConnection;1194;0;1195;0
WireConnection;1194;1;1192;0
WireConnection;1194;2;1193;0
WireConnection;1237;0;1234;0
WireConnection;1237;1;1236;1
WireConnection;1238;0;1235;0
WireConnection;1238;1;1236;2
WireConnection;51;0;668;0
WireConnection;51;1;306;0
WireConnection;164;0;1054;0
WireConnection;1167;0;1077;4
WireConnection;1187;0;1079;0
WireConnection;438;0;436;0
WireConnection;438;1;439;0
WireConnection;495;0;442;0
WireConnection;495;1;496;0
WireConnection;589;0;588;3
WireConnection;589;1;587;3
WireConnection;589;2;586;0
WireConnection;589;3;1053;0
WireConnection;682;0;679;0
WireConnection;682;1;681;0
WireConnection;1395;0;1393;0
WireConnection;1395;1;1394;0
WireConnection;1190;0;1191;0
WireConnection;1190;1;1188;0
WireConnection;1190;2;1189;0
WireConnection;659;0;655;0
WireConnection;707;0;706;0
WireConnection;657;0;654;1
WireConnection;657;1;653;1
WireConnection;657;2;652;0
WireConnection;590;0;588;2
WireConnection;590;1;587;2
WireConnection;590;2;586;0
WireConnection;590;3;1053;0
WireConnection;660;0;656;0
WireConnection;502;0;500;0
WireConnection;502;1;1428;0
WireConnection;1424;0;518;0
WireConnection;378;0;1533;0
WireConnection;1430;0;380;0
WireConnection;1430;1;1429;0
WireConnection;115;0;109;0
WireConnection;113;0;111;0
WireConnection;119;0;107;0
WireConnection;119;1;75;0
WireConnection;119;2;124;0
WireConnection;129;0;128;0
WireConnection;1376;0;1374;0
WireConnection;1376;1;1375;0
WireConnection;1376;2;1372;0
WireConnection;1377;0;1373;0
WireConnection;460;0;144;0
WireConnection;1356;0;404;0
WireConnection;1356;1;1415;0
WireConnection;1163;0;1194;0
WireConnection;1163;1;1162;0
WireConnection;1205;0;1245;0
WireConnection;1205;1;1588;0
WireConnection;1240;0;1238;0
WireConnection;1239;0;1237;0
WireConnection;1185;0;1186;0
WireConnection;1185;1;1167;0
WireConnection;1185;2;1187;0
WireConnection;391;0;55;3
WireConnection;391;1;51;3
WireConnection;391;2;139;0
WireConnection;391;3;1055;0
WireConnection;443;0;495;0
WireConnection;443;1;438;0
WireConnection;593;0;589;0
WireConnection;683;0;682;0
WireConnection;1389;0;1395;0
WireConnection;591;0;588;1
WireConnection;591;1;587;1
WireConnection;591;2;586;0
WireConnection;1134;0;1190;0
WireConnection;1134;1;1133;0
WireConnection;709;0;707;0
WireConnection;709;1;708;0
WireConnection;661;0;657;0
WireConnection;389;0;55;2
WireConnection;389;1;51;2
WireConnection;389;2;139;0
WireConnection;389;3;1055;0
WireConnection;594;0;590;0
WireConnection;381;0;378;0
WireConnection;381;1;1430;0
WireConnection;1425;0;502;0
WireConnection;521;0;1424;0
WireConnection;521;1;527;0
WireConnection;108;0;106;0
WireConnection;108;1;74;0
WireConnection;108;2;115;0
WireConnection;116;0;113;0
WireConnection;120;0;119;0
WireConnection;120;1;83;0
WireConnection;120;2;129;0
WireConnection;1379;0;1376;0
WireConnection;1379;1;1378;0
WireConnection;1379;2;1377;0
WireConnection;420;0;460;0
WireConnection;420;1;422;0
WireConnection;1363;0;1356;0
WireConnection;1170;0;1163;0
WireConnection;1261;0;1205;0
WireConnection;1341;0;1340;0
WireConnection;1241;0;1239;0
WireConnection;1241;1;1243;0
WireConnection;1242;0;1240;0
WireConnection;1242;1;1243;0
WireConnection;1080;0;1185;0
WireConnection;1080;1;1081;0
WireConnection;1062;0;1061;0
WireConnection;392;0;391;0
WireConnection;446;0;443;0
WireConnection;685;0;683;0
WireConnection;685;1;684;0
WireConnection;63;0;55;1
WireConnection;63;1;51;1
WireConnection;63;2;139;0
WireConnection;1380;0;1379;0
WireConnection;1396;0;1389;0
WireConnection;1385;0;1389;0
WireConnection;1385;1;1386;0
WireConnection;595;0;591;0
WireConnection;1169;0;1134;0
WireConnection;710;0;709;0
WireConnection;710;1;718;0
WireConnection;390;0;389;0
WireConnection;523;0;521;0
WireConnection;523;1;522;0
WireConnection;1426;0;381;0
WireConnection;506;0;1425;0
WireConnection;506;1;503;0
WireConnection;110;0;108;0
WireConnection;110;1;82;0
WireConnection;110;2;116;0
WireConnection;426;0;420;0
WireConnection;408;0;1363;0
WireConnection;1164;0;1170;0
WireConnection;132;0;120;0
WireConnection;1256;0;1261;0
WireConnection;1216;0;1241;0
WireConnection;1216;1;1242;0
WireConnection;1168;0;1080;0
WireConnection;1063;0;1062;0
WireConnection;447;0;446;0
WireConnection;447;1;448;0
WireConnection;686;0;685;0
WireConnection;686;1;694;0
WireConnection;65;0;63;0
WireConnection;131;0;110;0
WireConnection;1365;0;1396;0
WireConnection;1387;0;1396;0
WireConnection;1387;1;1385;0
WireConnection;1135;0;1169;0
WireConnection;713;0;710;0
WireConnection;713;1;711;0
WireConnection;713;2;712;0
WireConnection;508;0;506;0
WireConnection;508;1;507;0
WireConnection;387;0;1426;0
WireConnection;387;1;388;0
WireConnection;524;0;523;0
WireConnection;524;2;1532;0
WireConnection;407;0;408;0
WireConnection;407;1;148;0
WireConnection;423;0;426;0
WireConnection;423;1;424;0
WireConnection;800;0;799;0
WireConnection;800;1;798;0
WireConnection;1497;0;995;0
WireConnection;1497;1;1498;0
WireConnection;1497;2;1499;0
WireConnection;1207;0;1256;0
WireConnection;1207;1;1201;0
WireConnection;1223;0;1342;0
WireConnection;1223;1;1216;0
WireConnection;1082;0;1168;0
WireConnection;1571;0;1572;0
WireConnection;1571;1;1063;1
WireConnection;450;0;447;0
WireConnection;450;1;451;0
WireConnection;689;0;686;0
WireConnection;689;1;687;0
WireConnection;689;2;688;0
WireConnection;133;0;134;0
WireConnection;133;1;135;0
WireConnection;133;2;1365;0
WireConnection;1390;0;1387;0
WireConnection;526;0;524;0
WireConnection;526;1;525;0
WireConnection;715;0;713;0
WireConnection;715;1;714;0
WireConnection;384;0;387;0
WireConnection;384;1;383;0
WireConnection;510;0;508;0
WireConnection;510;2;1531;0
WireConnection;1331;0;146;0
WireConnection;425;0;407;0
WireConnection;425;1;423;0
WireConnection;149;0;153;0
WireConnection;149;1;151;0
WireConnection;149;2;248;0
WireConnection;801;0;800;0
WireConnection;801;1;797;0
WireConnection;1002;0;1497;0
WireConnection;1002;1;993;0
WireConnection;1002;2;994;0
WireConnection;1025;0;1026;0
WireConnection;1025;1;1027;0
WireConnection;1502;0;996;0
WireConnection;1502;1;1500;0
WireConnection;1502;2;1501;0
WireConnection;1228;0;1207;0
WireConnection;1564;0;1571;0
WireConnection;1564;1;1565;0
WireConnection;452;0;450;0
WireConnection;452;1;474;0
WireConnection;452;2;449;0
WireConnection;512;0;510;0
WireConnection;512;1;511;0
WireConnection;691;0;689;0
WireConnection;691;1;690;0
WireConnection;1383;0;133;0
WireConnection;1383;1;1384;0
WireConnection;1383;2;1390;0
WireConnection;529;0;526;0
WireConnection;417;0;384;0
WireConnection;417;2;418;0
WireConnection;719;0;715;0
WireConnection;1332;0;1331;1
WireConnection;152;0;425;0
WireConnection;152;1;149;0
WireConnection;802;0;801;0
WireConnection;1024;0;1002;0
WireConnection;1024;1;1025;0
WireConnection;1029;0;1031;0
WireConnection;1029;1;1030;0
WireConnection;1003;0;1502;0
WireConnection;1003;1;997;0
WireConnection;1003;2;998;0
WireConnection;1505;0;999;0
WireConnection;1505;1;1503;0
WireConnection;1505;2;1504;0
WireConnection;1218;0;1223;0
WireConnection;1218;1;1228;0
WireConnection;1566;0;1564;0
WireConnection;1566;1;1567;0
WireConnection;476;0;417;0
WireConnection;476;1;475;0
WireConnection;453;0;452;0
WireConnection;453;1;454;0
WireConnection;695;0;691;0
WireConnection;513;0;512;0
WireConnection;93;0;1383;0
WireConnection;1320;0;152;0
WireConnection;1320;1;1332;0
WireConnection;1004;0;1505;0
WireConnection;1004;1;1000;0
WireConnection;1004;2;1001;0
WireConnection;1033;0;1034;0
WireConnection;1033;1;1035;0
WireConnection;950;0;1024;0
WireConnection;950;1;951;0
WireConnection;1028;0;1003;0
WireConnection;1028;1;1029;0
WireConnection;1562;0;1218;0
WireConnection;1562;1;1563;0
WireConnection;1569;0;1566;0
WireConnection;455;0;453;0
WireConnection;385;0;476;0
WireConnection;155;0;1320;0
WireConnection;1032;0;1004;0
WireConnection;1032;1;1033;0
WireConnection;1345;0;1005;0
WireConnection;1345;1;1006;0
WireConnection;1345;2;950;0
WireConnection;986;0;1028;0
WireConnection;986;1;985;0
WireConnection;1020;0;1018;0
WireConnection;1217;0;1562;0
WireConnection;1217;1;1204;0
WireConnection;1070;0;1569;0
WireConnection;1070;1;1068;0
WireConnection;1070;2;1064;0
WireConnection;1070;3;1068;0
WireConnection;1070;4;1066;0
WireConnection;1010;0;1008;0
WireConnection;1010;1;1009;0
WireConnection;1010;2;986;0
WireConnection;979;0;980;0
WireConnection;979;1;1345;0
WireConnection;979;2;981;0
WireConnection;991;0;1032;0
WireConnection;991;1;990;0
WireConnection;1036;0;1020;0
WireConnection;1036;1;1037;0
WireConnection;1219;0;1217;0
WireConnection;1073;0;1070;0
WireConnection;1013;0;1011;0
WireConnection;1013;1;1012;0
WireConnection;1013;2;991;0
WireConnection;983;0;979;0
WireConnection;983;1;1010;0
WireConnection;983;2;987;0
WireConnection;1021;0;1019;0
WireConnection;1021;1;1036;0
WireConnection;66;0;1073;0
WireConnection;988;0;983;0
WireConnection;988;1;1013;0
WireConnection;988;2;992;0
WireConnection;1022;0;988;0
WireConnection;1022;1;1021;0
WireConnection;1220;0;1036;0
WireConnection;1220;1;1221;0
WireConnection;1222;0;1220;0
WireConnection;1222;1;1583;0
WireConnection;1583;1;988;0
WireConnection;1583;0;1022;0
WireConnection;70;0;68;0
WireConnection;70;1;1584;0
WireConnection;70;2;67;0
WireConnection;1584;1;1583;0
WireConnection;1584;0;1222;0
WireConnection;1278;0;1588;0
WireConnection;1279;0;1278;0
WireConnection;1279;1;1278;2
WireConnection;1277;0;1279;0
WireConnection;1280;0;1277;0
WireConnection;1280;1;1278;1
WireConnection;1283;0;1280;0
WireConnection;1295;0;1283;0
WireConnection;1295;1;1286;0
WireConnection;1295;2;1288;0
WireConnection;1299;0;1283;0
WireConnection;1299;1;1296;0
WireConnection;1299;2;1297;0
WireConnection;1284;0;1283;0
WireConnection;1284;1;1285;0
WireConnection;1284;2;1286;0
WireConnection;1287;0;1283;0
WireConnection;1287;1;1289;0
WireConnection;1287;2;1296;0
WireConnection;1294;0;1295;0
WireConnection;1300;0;1299;0
WireConnection;1293;0;1284;0
WireConnection;1293;1;1294;0
WireConnection;1301;0;1287;0
WireConnection;1301;1;1300;0
WireConnection;1302;0;1293;0
WireConnection;1302;1;1301;0
WireConnection;1303;0;1302;0
WireConnection;1075;0;1073;0
WireConnection;1075;1;1074;0
WireConnection;1075;2;1072;0
WireConnection;1069;0;1065;0
WireConnection;1071;0;1070;0
WireConnection;1071;1;1069;0
WireConnection;1568;0;1566;0
WireConnection;1067;0;1063;1
WireConnection;1494;0;631;3
WireConnection;1493;0;565;2
WireConnection;72;1;1584;0
WireConnection;72;0;70;0
WireConnection;1323;0;1224;0
WireConnection;1318;0;1323;1
WireConnection;1543;0;1542;0
WireConnection;1543;1;1539;0
WireConnection;1542;0;1540;0
WireConnection;1319;0;1318;0
WireConnection;1275;1;1303;0
WireConnection;0;2;72;0
ASEEND*/
//CHKSM=202FAC0422AD51B96DCF7CEE6E434E784D0314F8