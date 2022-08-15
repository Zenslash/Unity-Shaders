#ifndef SHADOW_PASS_INCLUDE
#define SHADOW_PASS_INCLUDE

#include "Lighting.cginc"


#if defined(SHADOWS_CUBE)
    struct appdata
    {
        float4 vertex : POSITION;
    };

    struct VSOut
    {
        float4 pos : SV_POSITION;
        float3 lightVec : TEXCOORD0;
    };

    VSOut vert (appdata v)
    {
        VSOut o;
        o.pos = UnityObjectToClipPos(v.vertex);
        o.lightVec = mul(unity_ObjectToWorld, v.vertex).xyz - _LightPositionRange.xyz;
        return o;
    }

    fixed4 frag (VSOut i) : SV_Target
    {
        float depth = length(i.lightVec) + unity_LightShadowBias.x;
        depth *= _LightPositionRange.w;
        return UnityEncodeCubeShadowDepth(depth);
    }
#else
    struct appdata
    {
        float4 vertex : POSITION;
        float3 normal : NORMAL;
    };

    float4 vert (appdata v) : SV_POSITION
    {
        float4 pos = UnityClipSpaceShadowCasterPos(v.vertex, v.normal);
        return UnityApplyLinearShadowBias(pos);
    }

    fixed4 frag (float4 i : SV_POSITION) : SV_Target
    {
        return 0;
    }
#endif




#endif