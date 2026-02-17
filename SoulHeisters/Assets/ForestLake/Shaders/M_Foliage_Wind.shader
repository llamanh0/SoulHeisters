// Made with Amplify Shader Editor v1.9.7.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "M_Foliage_Wind"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.4
		_Noise_Amount("Noise_Amount", Range( 0 , 2)) = -0.15
		_Wind_Amount("Wind_Amount", Range( 0 , 0.5)) = 0.1
		_Wind_Speed("Wind_Speed", Range( 0 , 2)) = 1
		_NoiseTexture("NoiseTexture", 2D) = "white" {}
		_BaseMap("Base Map", 2D) = "white" {}
		_Roughness("Roughness", 2D) = "white" {}
		_NormalMap("Normal Map", 2D) = "bump" {}
		_Brightness("Brightness", Range( 0 , 3)) = 1
		_Rough("Rough", Range( 0 , 2)) = 1
		_Subsurface("Subsurface", Range( 0 , 3)) = 1
		[Toggle(_BEND_ONLY_ON)] _Bend_Only("Bend_Only", Float) = 0
		_Desaturate("Desaturate", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Off
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma shader_feature_local _BEND_ONLY_ON
		#define ASE_VERSION 19701
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float3 worldPos;
			float2 uv_texcoord;
		};

		uniform float _Wind_Speed;
		uniform float _Wind_Amount;
		uniform sampler2D _NoiseTexture;
		uniform float _Noise_Amount;
		uniform sampler2D _NormalMap;
		uniform float4 _NormalMap_ST;
		uniform sampler2D _BaseMap;
		uniform float4 _BaseMap_ST;
		uniform float _Brightness;
		uniform float _Desaturate;
		uniform float _Subsurface;
		uniform float _Rough;
		uniform sampler2D _Roughness;
		uniform float4 _Roughness_ST;
		uniform float _Cutoff = 0.4;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 temp_output_15_0 = float3( 0,0,0 );
			float4 transform80 = mul(unity_ObjectToWorld,float4( 0,0,0,1 ));
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float temp_output_12_0 = ( ( _Wind_Speed * _CosTime.w ) * ( distance( transform80.y , ase_worldPos.y ) * _Wind_Amount ) );
			float4 appendResult13 = (float4(temp_output_12_0 , 0.0 , temp_output_12_0 , 0.0));
			float4 temp_output_14_0 = ( float4( temp_output_15_0 , 0.0 ) + appendResult13 );
			float2 temp_cast_2 = (_Noise_Amount).xx;
			float4 appendResult33 = (float4(ase_worldPos.x , ase_worldPos.y , 0.0 , 0.0));
			float2 panner36 = ( 0.1 * _Time.y * temp_cast_2 + ( appendResult33 * -0.15 ).xy);
			float4 _Direction = float4(0,0,0,0);
			float3 appendResult37 = (float3(_Direction.x , _Direction.y , _Direction.z));
			float3 worldToObjDir42 = mul( unity_WorldToObject, float4( appendResult37, 0 ) ).xyz;
			float4 lerpResult54 = lerp( float4( temp_output_15_0 , 0.0 ) , temp_output_14_0 , ( ( ( (tex2Dlod( _NoiseTexture, float4( panner36, 0, 0.0) )*2.0 + -1.0) * 0.39 ) + float4( ( worldToObjDir42 * 0.0 ) , 0.0 ) ) * float4( float3(1,1,0.2) , 0.0 ) ));
			#ifdef _BEND_ONLY_ON
				float4 staticSwitch74 = temp_output_14_0;
			#else
				float4 staticSwitch74 = lerpResult54;
			#endif
			v.vertex.xyz += staticSwitch74.xyz;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_NormalMap = i.uv_texcoord * _NormalMap_ST.xy + _NormalMap_ST.zw;
			o.Normal = UnpackNormal( tex2D( _NormalMap, uv_NormalMap ) );
			float2 uv_BaseMap = i.uv_texcoord * _BaseMap_ST.xy + _BaseMap_ST.zw;
			float4 tex2DNode16 = tex2D( _BaseMap, uv_BaseMap );
			float3 desaturateInitialColor81 = ( tex2DNode16 * _Brightness ).rgb;
			float desaturateDot81 = dot( desaturateInitialColor81, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar81 = lerp( desaturateInitialColor81, desaturateDot81.xxx, _Desaturate );
			o.Albedo = desaturateVar81;
			o.Emission = ( tex2DNode16 * _Subsurface ).rgb;
			float2 uv_Roughness = i.uv_texcoord * _Roughness_ST.xy + _Roughness_ST.zw;
			o.Smoothness = ( _Rough * tex2D( _Roughness, uv_Roughness ) ).r;
			o.Alpha = 1;
			clip( tex2DNode16.a - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
}
/*ASEBEGIN
Version=19701
Node;AmplifyShaderEditor.WorldPosInputsNode;31;-3409.043,-2207.981;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;33;-3172.437,-2201.464;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;32;-3220.257,-1987.363;Float;False;Constant;_WindS;WindS;6;0;Create;True;0;0;0;False;0;False;-0.15;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;-2956.099,-2190.328;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;51;-3010.236,-1940.24;Float;False;Property;_Noise_Amount;Noise_Amount;1;0;Create;True;0;0;0;False;0;False;-0.15;-0.15;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;36;-2697.334,-2090.32;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;1,1;False;1;FLOAT;0.1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WorldPosInputsNode;19;-3946.699,7.191627;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;80;-4335.131,-412.6365;Inherit;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector4Node;35;-3420.638,-2483.467;Float;False;Constant;_Direction;Direction;25;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;37;-3103.643,-2487.68;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;38;-2481.371,-2179.198;Inherit;True;Property;_NoiseTexture;NoiseTexture;4;0;Create;True;0;0;0;False;0;False;-1;a6bb3265c102a244387807ae59fac3f3;a6bb3265c102a244387807ae59fac3f3;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.CosTime;10;-3637.161,-593.2617;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DistanceOpNode;6;-3600.287,-330.7364;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-3721.161,-726.2615;Inherit;False;Property;_Wind_Speed;Wind_Speed;3;0;Create;True;0;0;0;False;0;False;1;1;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-3647.424,-152.5443;Inherit;False;Property;_Wind_Amount;Wind_Amount;2;0;Create;True;0;0;0;False;0;False;0.1;0.1;0;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;41;-2162.911,-2135.537;Inherit;False;3;0;COLOR;0,0,0,0;False;1;FLOAT;2;False;2;FLOAT;-1;False;1;COLOR;0
Node;AmplifyShaderEditor.TransformDirectionNode;42;-2796.752,-2540.761;Inherit;False;World;Object;False;Fast;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;39;-2337.323,-2258.979;Inherit;False;Constant;_Float0;Float 0;9;0;Create;True;0;0;0;False;0;False;0;0;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-3309.913,-289.5173;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-3360.161,-648.2615;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;40;-2249.287,-1923.277;Inherit;False;Constant;_WindN;WindN;10;0;Create;True;0;0;0;False;0;False;0.39;0.3;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;44;-2040.383,-2339.859;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;45;-1920.407,-2139.899;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-3087.261,-455.6618;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;47;-1684.336,-2210.095;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TransformPositionNode;15;-2848.331,-802.4263;Inherit;False;Object;Object;False;Fast;True;1;0;FLOAT3;0,0,0;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;13;-2824.175,-432.4695;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.Vector3Node;49;-2106.042,-1658.749;Inherit;False;Constant;WindStrengthDirectionMultiplier;WS;7;0;Create;False;0;0;0;False;0;False;1,1,0.2;1,1,0.2;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;50;-1583.837,-2000.528;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;71;-643.595,-400.3623;Inherit;False;Property;_Brightness;Brightness;8;0;Create;True;0;0;0;False;0;False;1;0.21;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;16;-1011.137,-538.0438;Inherit;True;Property;_BaseMap;Base Map;5;0;Create;True;0;0;0;False;0;False;-1;abc00000000013667944981076668650;65552fa057e624944bbb310d19fd2afd;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SimpleAddOpNode;14;-2552.32,-632.4047;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SamplerNode;66;-685.1819,255.6128;Inherit;True;Property;_Roughness;Roughness;6;0;Create;True;0;0;0;False;0;False;-1;a739a204253e75e44a5b1d8b803f0877;a739a204253e75e44a5b1d8b803f0877;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.RangedFloatNode;72;-1013.739,-244.6382;Inherit;False;Property;_Subsurface;Subsurface;10;0;Create;True;0;0;0;False;0;False;1;0.54;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;65;-397.1406,122.3603;Inherit;False;Property;_Rough;Rough;9;0;Create;True;0;0;0;False;0;False;1;1.33;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;54;-1440.954,-908.0657;Inherit;False;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;70;-251.4671,-528.6465;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;82;-242.9639,-295.2778;Inherit;False;Property;_Desaturate;Desaturate;12;0;Create;True;0;0;0;False;0;False;0;0.842;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;68;-219.4711,162.74;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;64;-998.1537,2.542435;Inherit;True;Property;_NormalMap;Normal Map;7;0;Create;True;0;0;0;False;0;False;-1;abc00000000011615642639239422150;abc00000000009174826200331873443;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;73;-705.684,-278.3613;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;74;-1219.297,-763.9045;Inherit;False;Property;_Bend_Only;Bend_Only;11;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT4;0,0,0,0;False;0;FLOAT4;0,0,0,0;False;2;FLOAT4;0,0,0,0;False;3;FLOAT4;0,0,0,0;False;4;FLOAT4;0,0,0,0;False;5;FLOAT4;0,0,0,0;False;6;FLOAT4;0,0,0,0;False;7;FLOAT4;0,0,0,0;False;8;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DesaturateOpNode;81;40.87488,-458.6683;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;828.4671,-218.0753;Float;False;True;-1;2;;0;0;Standard;M_Foliage_Wind;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;;0;False;;False;0;False;;0;False;;False;0;Custom;0.4;True;True;0;True;Transparent;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;33;0;31;1
WireConnection;33;1;31;2
WireConnection;34;0;33;0
WireConnection;34;1;32;0
WireConnection;36;0;34;0
WireConnection;36;2;51;0
WireConnection;37;0;35;1
WireConnection;37;1;35;2
WireConnection;37;2;35;3
WireConnection;38;1;36;0
WireConnection;6;0;80;2
WireConnection;6;1;19;2
WireConnection;41;0;38;0
WireConnection;42;0;37;0
WireConnection;7;0;6;0
WireConnection;7;1;17;0
WireConnection;11;0;8;0
WireConnection;11;1;10;4
WireConnection;44;0;42;0
WireConnection;44;1;39;0
WireConnection;45;0;41;0
WireConnection;45;1;40;0
WireConnection;12;0;11;0
WireConnection;12;1;7;0
WireConnection;47;0;45;0
WireConnection;47;1;44;0
WireConnection;13;0;12;0
WireConnection;13;2;12;0
WireConnection;50;0;47;0
WireConnection;50;1;49;0
WireConnection;14;0;15;0
WireConnection;14;1;13;0
WireConnection;54;0;15;0
WireConnection;54;1;14;0
WireConnection;54;2;50;0
WireConnection;70;0;16;0
WireConnection;70;1;71;0
WireConnection;68;0;65;0
WireConnection;68;1;66;0
WireConnection;73;0;16;0
WireConnection;73;1;72;0
WireConnection;74;1;54;0
WireConnection;74;0;14;0
WireConnection;81;0;70;0
WireConnection;81;1;82;0
WireConnection;0;0;81;0
WireConnection;0;1;64;0
WireConnection;0;2;73;0
WireConnection;0;4;68;0
WireConnection;0;10;16;4
WireConnection;0;11;74;0
ASEEND*/
//CHKSM=F0209FA5B17BF9EC6E39835E8914CDDFDF081563