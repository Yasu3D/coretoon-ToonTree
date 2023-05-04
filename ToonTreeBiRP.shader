Shader "CoreToon/ToonTreeBiRP"
{
    Properties
    {
        _BasisColor ("Base Color", Color) = (0.2, 0.6, 0.4, 1.0)
        _HighlightColor ("Highlight Color", Color) = (0.52, 0.77, 0.32, 1.0)
        _ShadowColor ("Shadow Color", Color) = (0.05, 0.36, 0.49, 1.0)
        _AlphaMask ("alpha Mask", 2D) = "white" {}
        _AlphaClipping ("alpha Clipping", Range(0.0, 1.1)) = 0.5
        _ShadowSize ("Shadow Size", Range(-1.0, 0)) = -0.25
        _ShadowSoftness ("Shadow Softness", Range(0.0, 1.0)) = 1
        _HighlightSize ("Highlight Size", Range(-1.0, 0.0)) = -0.25
        _HighlightSoftness ("Highlight Softness", Range(0.0, 1.0)) = 1
    }
    SubShader
    {
        Tags { "RenderType"="TransparentCutout" "Queue"="Transparent"}
        LOD 100
        Cull Off
        
        Pass // Colors
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fog

            #include "UnityCG.cginc"


            //colors
            float4 _BasisColor;
            float4 _ShadowColor;
            float4 _HighlightColor;
            
            //alpha
            sampler2D _AlphaMask;
            float4 _AlphaMask_ST;
            float _AlphaClipping;

            //color blend adjustments
            float _ShadowSize;
            float _ShadowSoftness;
            float _HighlightSize;
            float _HighlightSoftness;


            struct meshData {
                float4 vertex : POSITION;
                float3 normals : NORMAL;
                float2 uv : TEXCOORD0;
            };

            struct Interpolators {
                float2 uv : TEXCOORD0;
                float3 normal : TEXCOORD1;
                float4 vertex : SV_POSITION;
                //fog
                UNITY_FOG_COORDS(2)
            };

            Interpolators vert (meshData v)
            {
                //get everything needed for frag shader
                Interpolators o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                //  (convert to worldSpace normals)
                o.normal = UnityObjectToWorldNormal( v.normals );
                o.uv = TRANSFORM_TEX(v.uv, _AlphaMask);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (Interpolators i) : SV_Target
            {
                UNITY_APPLY_FOG(i.fogCoord, col);

                //calculate lighting
                float lighting = dot(i.normal, _WorldSpaceLightPos0);

                //calculate color masks
                float shadowMask = smoothstep(0, _ShadowSoftness, (saturate(-lighting) + _ShadowSize));
                float highlightMask = smoothstep(0, _HighlightSoftness, (saturate(saturate(lighting) + _HighlightSize)));

                //mix colors
                float4 mixedColor = lerp(lerp(_BasisColor, _ShadowColor, shadowMask), _HighlightColor, highlightMask);
                
                //sample alpha mask and clip it
                float alpha = tex2D(_AlphaMask, i.uv);
                clip(alpha - _AlphaClipping);

                //return mixed colors and transparency
                return float4( mixedColor.rgb, alpha);
            }
            ENDCG
        }

        Pass // Shadow Casting
        {
            Name "ShadowCaster"
            Tags { "LightMode" = "ShadowCaster" }

            CGPROGRAM
            #pragma vertex vertShadows
            #pragma fragment fragShadows
            #pragma multi_compile_shadowcaster
            #include "UnityCG.cginc"

            struct ShadowInterpolators { 
                V2F_SHADOW_CASTER;
            };

            ShadowInterpolators vertShadows(appdata_base v)
            {
                ShadowInterpolators o;
                TRANSFER_SHADOW_CASTER_NORMALOFFSET(o)
                return o;
            }

            float4 fragShadows(ShadowInterpolators i) : SV_Target
            {
                SHADOW_CASTER_FRAGMENT(i)
            }
            ENDCG
        }
    }
}
