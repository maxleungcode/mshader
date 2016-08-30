Shader "SS/VFMaskGray" {
	Properties {
		[PerRendererData] _MainTex ("tex1", 2D)  = "white" {}
		_MaskTex ("tex2", 2D)  = "white" {}
		_Sizeffo("sf",float) = 0
	}
	SubShader {
	Tags {  "IgnoreProjector"="True"  "Queue"="Transparent"  "RenderType"="Transparent"  }
        ZWrite Off
        Blend SrcAlpha OneMinusSrcAlpha    
		Pass
		{
			Lighting Off
			CGPROGRAM
			#include "UnityCG.cginc"
			#pragma fragment frag
			#pragma vertex vert
			sampler2D _MainTex;
			sampler2D _MaskTex;
			float4 _Color;
			float _Sizeffo;
			float4 _MainTex_ST;
			struct v2f
			{
				float4  pos : SV_POSITION;
				float2  uv : TEXCOORD0;
				
			};

			v2f vert (appdata_base v)
			{
				v2f o;
				//v.vertex.xyz += v.normal*0.01;
				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
				//o.uv.xy = v.texcoord;
				o.uv =  TRANSFORM_TEX(v.texcoord, _MainTex); 
				//no need dynamic light 
				//o.color = ShadeVertexLights(v.vertex, v.normal); 
				return o;
			}
			
			half4 frag (v2f i) : COLOR
			{
				half4 c = tex2D (_MainTex,float2(i.uv.x, i.uv.y));
				half4 ms = tex2D (_MaskTex,float2(i.uv.x, i.uv.y+_Sizeffo));
				c.rgb = ms.a==0?(c.r*0.3+c.g*0.59+c.b*0.11):c.rgb;
				return c;
			}
			ENDCG
		}
	}
	FallBack "Diffuse"
}

