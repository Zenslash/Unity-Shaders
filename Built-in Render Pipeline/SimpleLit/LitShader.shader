Shader "Custom/LitShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        [NoScaleOffset]_NormalTex("Normal Map", 2D) = "bump" {}
        [NoScaleOffset]_SpecularTex("Specular Map", 2D) = "bump" {}
        _Shiness("Shiness", float) = 0.5
        _AmbientColor("Ambient Color", Color) = (0, 0, 0, 0)
        [Toggle(Use Fresnel Factor)] _UseFresnelFactor("Use Fresnel Factor?", float) = 0
        _FresnelPower("Fresnel Power", float) = 2
    }
    SubShader
    {
        Tags { "RenderType"="Opaque"}
        LOD 100

        //Base pass
        Pass
        {
            Tags {"LightMode" = "ForwardBase"}
            
            CGPROGRAM
            #pragma target 3.0
            #pragma vertex vert
            #pragma fragment frag

            #pragma multi_compile _ SHADOWS_SCREEN
            #pragma multi_compile _ VERTEXLIGHT_ON

            #define FORWARD_BASE_PASS
            
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #include "Assets/Shaders/Lighting/LitPass.hlsl"
            
            ENDCG
        }
        
        //Add pass
        Pass
        {
            Blend One One   //src + dst
            
            Tags {"LightMode" = "ForwardAdd"}
            
            CGPROGRAM
            #pragma target 3.0
            #pragma vertex vert
            #pragma fragment frag

            #pragma multi_compile_fwdadd_fullshadows
            
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #include "Assets/Shaders/Lighting/LitPass.hlsl"
            
            ENDCG
        }
        
        //Shadow pass
        Pass
        {
            Tags {"LightMode" = "ShadowCaster"}
            
            CGPROGRAM
            #pragma target 3.0
            #pragma vertex vert
            #pragma fragment frag

            #pragma multi_compile_shadowcaster
            
            #include "Assets/Shaders/Lighting/ShadowPass.hlsl"
            
            ENDCG
        }
    }
}
