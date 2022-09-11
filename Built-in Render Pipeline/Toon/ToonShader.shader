Shader "Custom/ToonShader"
{
    Properties
    {
        _MainTex ("Albedo", 2D) = "white" {}
        [NoScaleOffset]_NormalTex("Normal Map", 2D) = "bump" {}
        _AmbientColor("Ambient Color", Color) = (0, 0, 0, 0)
        _ShadowIntensity("Shadow Intensity", Range(0.1, 1)) = 0.2
        _RimColor("Rim Light Color", Color) = (0, 0, 0, 0)
        _RimLightPower("Rim Light power", float) = 0.2
        _RimLightLeftEdge("Rim Left edge", float) = 0.5
        _RimLightRightEdge("Rim Right edge", float) = 0.6
        _OutlineWidth("Outline Width", float) = 1
        _OutlineColor("Outline Color", Color) = (0, 0, 0, 0)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque"}
        LOD 100

        //Base pass
        Pass
        {
            Tags {"LightMode" = "ForwardBase"}
            
            Stencil 
            {
                Ref 1
                Comp Always
                Pass Replace
            }
            
            CGPROGRAM
            #pragma target 3.0
            #pragma vertex vert
            #pragma fragment frag

            #pragma shader_feature _NORMALMAP
            #pragma multi_compile _ SHADOWS_SCREEN
            #pragma multi_compile _ VERTEXLIGHT_ON

            #define FORWARD_BASE_PASS
            #define _NORMALMAP
            
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #include "./ToonPass.hlsl"
            
            ENDCG
        }
        
        //Outlining pass
        Pass
        {
            Cull Off

            Stencil 
            {
                Ref 1
                Comp Greater
            }
            
            CGPROGRAM
            #pragma target 3.0
            #pragma vertex vert
            #pragma fragment frag
            
            #include "./OutlinePass.hlsl"
            
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
            
            #include "./ShadowPass.hlsl"
            
            ENDCG
        }
    }
    
    CustomEditor "ToonGUI"
}
