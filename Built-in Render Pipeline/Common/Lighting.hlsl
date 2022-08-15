#ifndef LIGHTING_INCLUDE
#define LIGHTING_INCLUDE

#include "Lighting.cginc"
#include "./Light.hlsl"

float4 GetLambertianDiffuse(float3 normal, Light light)
{
    return saturate(dot(normal,light.Dir)) * light.Color;
}
float GetBlinnPhongSpecular(float3 normal, float3 h, float shiness)
{
    return pow(max(dot(normal, h), 0.0), shiness);
}
float GetFresnelFactor(float3 normal, float3 viewDir, float fresnelPower)
{
    float fresnel = dot(normal, viewDir);
    fresnel = max(fresnel, 0.0f);
    fresnel = 1.0 - fresnel;
    fresnel = pow(fresnel, fresnelPower);
    return fresnel;
}
float GetAttenuation(Light light)
{
    return 1 / (1 + dot(light.Dir, light.Dir));
}

float3 ComputeVertexPointLights(float3 worldPos, float3 normal)
{
    return Shade4PointLights(
        unity_4LightPosX0, unity_4LightPosY0, unity_4LightPosZ0,
        unity_LightColor[0].rgb, unity_LightColor[1].rgb,
        unity_LightColor[2].rgb, unity_LightColor[3].rgb,
        unity_4LightAtten0, worldPos, normal);
}




#endif