#ifndef OUTLINE_PASS_INCLUDE
#define OUTLINE_PASS_INCLUDE

struct appdata
{
    float4 vertex : POSITION;
    float3 normal : NORMAL;
    float2 uv : TEXCOORD0;
};

float _OutlineWidth;
float4 _OutlineColor;

float4 vert (appdata v) : SV_POSITION
{
    float4 clipPos = UnityObjectToClipPos(v.vertex);
    float3 clipNormal = mul((float3x3)UNITY_MATRIX_VP, mul((float3x3)UNITY_MATRIX_M, v.normal));
    float2 offset = normalize(clipNormal.xy) / _ScreenParams.xy * _OutlineWidth * clipPos.w * 2;
    clipPos.xy += offset;
    return clipPos;
}

sampler2D _CameraDepthTexture;

fixed4 frag (float4 pos : SV_POSITION) : SV_Target
{
    return _OutlineColor;
}




#endif