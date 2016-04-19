Shader "Unlit/TunnelShader"
{
	Properties
	{
		//Impact("Impact", Float(2,50)) = 30
		//_RimColor("Rim Color (RGB)", Color) = (0.8,0.8,0.8,0.6)
		_BlendFactor("BlendFactor", float) = 0.75
		_MyTexture("My Texture", 2D) = "white" { }

	}
		SubShader
		{
			Tags{ "Queue" = "Transparent" }
			//Cull Back
			////Lighting Off
			////Fog{ Mode Off }
			ZWrite Off
			////Blend One One
			Blend SrcAlpha OneMinusSrcAlpha
			//
//		Pass
//	{
//		Cull Off // first pass renders only back faces 
//				   // (the "inside")
//
//		ZWrite Off // don't write to depth buffer 
//				   // in order not to occlude other objects
//
//		Blend SrcAlpha OneMinusSrcAlpha // use alpha blending
//
//		CGPROGRAM
//
//#pragma vertex vert 
//#pragma fragment frag

		Pass
	{
		CGPROGRAM
#pragma vertex vert
#pragma fragment frag
		// make fog work
#pragma multi_compile_fog
		// use "vert" function as the vertex shader
#pragma vertex vert
		// use "frag" function as the pixel (fragment) shader
#pragma fragment frag

#include "UnityCG.cginc"

float4 vert(float4 vertexPos : POSITION) : SV_POSITION
	{
		return mul(UNITY_MATRIX_MVP, vertexPos);
	}

		float4 frag(void) : COLOR
	{
		return float4(0.0, 1.0, 0.0, 0.3);
	// the fourth component (alpha) is important: 
	// this is semitransparent green
	}

		uniform float _BlendFactor;

		// vertex shader inputs
	struct appdata
	{
		float4 vertex : POSITION; // vertex position
		float2 uv : TEXCOORD0; // texture coordinate
	};

	// vertex shader outputs ("vertex to fragment")
	struct v2f
	{
		float2 uv : TEXCOORD0; // texture coordinate
		float4 vertex : SV_POSITION; // clip space position
	};

	// vertex shader
	v2f vert(appdata v)
	{
		v2f o;
		// transform position to clip space
		// (multiply with model*view*projection matrix)
		o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
		// just pass the texture coordinate
		o.uv = v.uv;
		return o;
	}

	// texture we will sample
	sampler2D _MainTex;

	// pixel shader; returns low precision ("fixed4" type)
	// color ("SV_Target" semantic)
	fixed4 frag(v2f i) : SV_Target
	{
		// sample texture and return it
		/*fixed4 col = tex2D(_MainTex, i.uv);
		col.rgba = col.rgba * 5;
		return col;*/

		float4 col = tex2D(_MainTex, i.uv);
		col.a = _BlendFactor;
		//col.g = 1;
		return col;

		/*float4 color = tex2D(_MainTex, i.uv);
		float4 invertedColor = float4(color.a - color.rgb, color.a);
		return invertedColor;*/

	}
		ENDCG
	}
		}
	}
