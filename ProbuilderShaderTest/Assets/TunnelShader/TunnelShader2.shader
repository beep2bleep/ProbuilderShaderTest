Shader "Unlit/TunnelShader2"
{
	Properties
	{
		//Impact("Impact", Float(2,50)) = 30
		//_RimColor("Rim Color (RGB)", Color) = (0.8,0.8,0.8,0.6)
		_BlendFactor("BlendFactor", float) = 0.75
		_MyTexture("My Texture", 2D) = "white" { }

	}

		SubShader{
		Tags{ "Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent" }
		LOD 200

		// extra pass that renders to depth buffer only
		Pass{
		ZWrite On
		//ColorMask 0
	
	
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
		return col;

		/*float4 color = tex2D(_MainTex, i.uv);
		float4 invertedColor = float4(color.a - color.rgb, color.a);
		return invertedColor;*/

	}
		ENDCG
	}
	}
}
