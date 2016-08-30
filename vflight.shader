Shader "Temp/vf8" {
	Properties {
		_MainColor("mc",Color) = (1,1,1,1)
		_SpecalarColor("SpecularColor",Color) = (1,1,1,1)
        _Shininess("Shininess",Range(1,94)) = 8
        _Tex (" Texure", 2D) = "white" {}
	}
	SubShader {
		
		Tags { "Queue"="Geometry" "IgnoreProjector"="True" "LightMode"="ForwardBase"}
		
		
		Pass {
			Lighting On
			CGPROGRAM
			#pragma vertex vert  
            #pragma fragment frag  
            #pragma multi_compile_fog 
            #include "UnityCG.cginc"
            #include "Lighting.cginc"

            struct v2f {  
                float4 pos : SV_POSITION;  
                float3 normal :NORMAL;
                float4 vertex: COLOR;
                half2 uvLM : TEXCOORD1;
            };
			float4 _Tex_ST;
			sampler2D _Tex;
            float4 _MainColor;
            float4 _SpecalarColor;
            float _Shininess;

            v2f vert(appdata_full v) {   
            	v2f o;
                o.pos = mul(UNITY_MATRIX_MVP,v.vertex);
                o.normal = v.normal;
                o.vertex = v.vertex;
                o.uvLM = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;  
                return o;
            }

            float4 frag(v2f v) : COLOR { 
            	// Ambient Color 环境光
                float4 col = UNITY_LIGHTMODEL_AMBIENT;

                float3 N = UnityObjectToWorldNormal(v.normal);
                float3 L = normalize(WorldSpaceLightDir(v.vertex));
                float3 V = normalize(WorldSpaceViewDir(v.vertex));
                  //deffuse Color 漫反射
                float ndot = saturate(dot(N,L));//saturate把点积的结果限定在[0-1]
                col += _LightColor0*_MainColor * ndot;
                // 高光
                float3 R = 2*dot(N,L)*N-L;
                R = normalize(R);
 				float specularScale = pow(saturate(dot(R,V)),_Shininess);//pow：数的n次幂

 				//点光源
                float3 wpos = mul(_Object2World,v.vertex).xyz;
 
                col.rgb += Shade4PointLights(unity_4LightPosX0,unity_4LightPosY0,unity_4LightPosZ0
 
                            ,unity_LightColor[0].rgb,unity_LightColor[1].rgb,unity_LightColor[2].rgb,unity_LightColor[3].rgb,
 
                            unity_4LightAtten0,wpos,N);
 


 				//烘焙获取灯光贴图
 				fixed3 lm = DecodeLightmap (UNITY_SAMPLE_TEX2D(unity_Lightmap, v.uvLM.xy)); 
                //col += _SpecalarColor * specularScale;
                float4 t = tex2D(_Tex,v.uvLM*_Tex_ST.xy);
                t.rgb= col.rgb+(lm/1.5);
                return t;
            }


			ENDCG 
		} 
	}

	Fallback "Diffuse"

}