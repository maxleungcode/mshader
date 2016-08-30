Shader "SS/VFGraytoUI" {
	Properties {
		[PerRendererData] _MainTex ("tex1", 2D)  = "white" {}
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
				c.rgb = (c.r*0.3+c.g*0.59+c.b*0.11);
				return c;
			}
			ENDCG
		}
	}
	FallBack "Diffuse"
}

