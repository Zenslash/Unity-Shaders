#ifndef LIT_PASS_INSTANCED_INCLUDE
#define LIT_PASS_INSTANCED_INCLUDE

#include "Lighting.cginc"
#include "../Common/Lighting.hlsl"


struct appdata
{
    float4 vertex : POSITION;
    float2 uv : TEXCOORD0;
    float4 normal : NORMAL;
    float4 tangent : TANGENT;   //xyz - tangent direction, w - tangent sign
    UNITY_VERTEX_INPUT_INSTANCE_ID
};

struct v2f
{
    float2 uv : TEXCOORD0;
    float4 pos : SV_POSITION;
    float3 normal : NORMAL;
    float3 tangent : TEXCOORD1;
    float3 bitangent : TEXCOORD2;
    float3 viewDir : TEXCOORD3;
    float4 worldPos : TEXCOORD4;
    LIGHTING_COORDS(5, 6)
    UNITY_VERTEX_INPUT_INSTANCE_ID
};

sampler2D _MainTex;
float4 _MainTex_ST;
sampler2D _NormalTex;
sampler2D _SpecularTex;

UNITY_INSTANCING_BUFFER_START(UnityPerMaterial)
float4 _AmbientColor;
float _ShadowIntensity;
float4 _RimColor;
float _RimLightPower;
float _RimLightLeftEdge;
float _RimLightRightEdge;
UNITY_INSTANCING_BUFFER_END(UnityPerMaterial)

v2f vert (appdata v)
{
    UNITY_SETUP_INSTANCE_ID(v);
    
    v2f o;
    o.pos = UnityObjectToClipPos(v.vertex);
    o.worldPos = mul(unity_ObjectToWorld, v.vertex);
    o.uv = TRANSFORM_TEX(v.uv, _MainTex);
    o.tangent = UnityObjectToWorldDir(v.tangent.xyz);
    o.normal = UnityObjectToWorldNormal(v.normal);
    o.bitangent = cross(o.normal, o.tangent) * (v.tangent.w * unity_WorldTransformParams.w);
    o.viewDir = WorldSpaceViewDir(v.vertex);
    UNITY_TRANSFER_INSTANCE_ID(v, o);
    TRANSFER_VERTEX_TO_FRAGMENT(o);     //Lighting
    return o;
}

fixed4 frag (v2f i) : SV_Target
{
    UNITY_SETUP_INSTANCE_ID(i);
    
    //Normal mapping
    //Unpack normal from normal map
    #if defined(_NORMALMAP)
    float3 tangentSpaceNormal = UnpackNormal(tex2D(_NormalTex, i.uv));
    float3x3 mtxTangToWorld = {
        i.tangent.x, i.bitangent.x, i.normal.x,
        i.tangent.y, i.bitangent.y, i.normal.y,
        i.tangent.z, i.bitangent.z, i.normal.z
    };
    //Calculate new normal
    float3 normal = mul(mtxTangToWorld, tangentSpaceNormal);
    #else
    float3 normal = i.normal;
    #endif

    Light light;
    light.Dir = normalize(UnityWorldSpaceLightDir(i.worldPos));
    light.Color = _LightColor0;
    
    // sample the texture
    float4 surfaceColor = tex2D(_MainTex, i.uv);

    //Normalize view direction
    i.viewDir = normalize(i.viewDir);
    //Calculate halfway vector
    float3 h = normalize(i.viewDir + light.Dir);
    
    //Diffuse
    float diffuseIntensity = dot(normal, light.Dir);
    diffuseIntensity = (diffuseIntensity > 0) ? 1.0 : UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial, _ShadowIntensity);
    float4 diffuse = diffuseIntensity * surfaceColor * light.Color;

    //Rim light
    float rimLightIntensity = dot(i.viewDir, normal);
    rimLightIntensity = 1.0f - rimLightIntensity;
    rimLightIntensity = max(0.0f, rimLightIntensity);
    rimLightIntensity = pow(rimLightIntensity, UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial, _RimLightPower));
    rimLightIntensity = smoothstep(UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial, _RimLightLeftEdge),
        UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial,_RimLightRightEdge), rimLightIntensity);
    float4 rimLight = rimLightIntensity * diffuseIntensity
    * surfaceColor
    * UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial, _RimColor);

    //Specular

    fixed4 col = (diffuse + rimLight);

    //Compute vertex lights
     #if defined(VERTEXLIGHT_ON)
         col += float4(ComputeToonVertexPointLights(i.worldPos.xyz, normal, UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial, _ShadowIntensity)), 1) * surfaceColor;
     #endif
    
    return col;
}


#endif