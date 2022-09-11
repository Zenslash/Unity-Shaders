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

// Used in ForwardBase pass: Calculates diffuse lighting from 4 point lights, with data packed in a special way.
float3 ToonShade4PointLights (
    float4 lightPosX, float4 lightPosY, float4 lightPosZ,
    float3 lightColor0, float3 lightColor1, float3 lightColor2, float3 lightColor3,
    float4 lightAttenSq,
    float3 pos, float3 normal, float shadowIntensity)
{
    // to light vectors
    float4 toLightX = lightPosX - pos.x;
    float4 toLightY = lightPosY - pos.y;
    float4 toLightZ = lightPosZ - pos.z;
    // squared lengths
    float4 lengthSq = 0;
    lengthSq += toLightX * toLightX;
    lengthSq += toLightY * toLightY;
    lengthSq += toLightZ * toLightZ;
    // don't produce NaNs if some vertex position overlaps with the light
    lengthSq = max(lengthSq, 0.000001);

    // NdotL
    float4 ndotl = 0;
    ndotl += toLightX * normal.x;
    ndotl += toLightY * normal.y;
    ndotl += toLightZ * normal.z;
    // correct NdotL
    float4 corr = rsqrt(lengthSq);
    ndotl = max (float4(0,0,0,0), ndotl * corr);
    ndotl = (ndotl > 0.0) ? 1.0f : shadowIntensity;
    // attenuation
    float4 atten = 1.0 / (1.0 + lengthSq * lightAttenSq);
    float4 diff = ndotl * atten;
    // final color
    float3 col = 0;
    col += lightColor0 * diff.x;
    col += lightColor1 * diff.y;
    col += lightColor2 * diff.z;
    col += lightColor3 * diff.w;
    return col;
}

float3 ComputeToonVertexPointLights(float3 worldPos, float3 normal, float shadowIntensity)
{
    return ToonShade4PointLights(
        unity_4LightPosX0, unity_4LightPosY0, unity_4LightPosZ0,
        unity_LightColor[0].rgb, unity_LightColor[1].rgb,
        unity_LightColor[2].rgb, unity_LightColor[3].rgb,
        unity_4LightAtten0, worldPos, normal, shadowIntensity);
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