using System;
using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

public class ToonGUI : ShaderGUI
{
    private MaterialEditor _materialEditor;
    private MaterialProperty[] _materialProperties;

    private static GUIContent _staticLabel = new GUIContent();
    
    public override void OnGUI(MaterialEditor materialEditor, MaterialProperty[] properties)
    {
        _materialEditor = materialEditor;
        _materialProperties = properties;
        //base.OnGUI(materialEditor, properties);

        RenderMain();
        EditorGUILayout.Space(10.0f);
        RenderShadowSettings();
        EditorGUILayout.Space(10.0f);
        RenderRimLight();
        EditorGUILayout.Space(10.0f);
        RenderOutline();
    }

    private void RenderMain()
    {
        GUILayout.Label("Main Maps", EditorStyles.boldLabel);

        MaterialProperty mainTex = GetProperty("_MainTex");
        _materialEditor.TexturePropertySingleLine(MakeLabel(mainTex, "Albedo(RGB)"), mainTex);
        RenderNormalMap();
        _materialEditor.TextureScaleOffsetProperty(mainTex);
    }

    private void RenderNormalMap()
    {
        MaterialProperty normalTex = GetProperty("_NormalTex");
        _materialEditor.TexturePropertySingleLine(MakeLabel(normalTex), normalTex);
    }

    private void RenderShadowSettings()
    {
        GUILayout.Label("Shadow settings", EditorStyles.boldLabel);

        MaterialProperty shadowIntensity = GetProperty("_ShadowIntensity");
        _materialEditor.ShaderProperty(shadowIntensity, MakeLabel(shadowIntensity));
    }
    private void RenderRimLight()
    {
        GUILayout.Label("Rim Light", EditorStyles.boldLabel);
        
        MaterialProperty rimLightColor = GetProperty("_RimColor");
        _materialEditor.ShaderProperty(rimLightColor, MakeLabel(rimLightColor));
        
        MaterialProperty rimLightPower = GetProperty("_RimLightPower");
        _materialEditor.ShaderProperty(rimLightPower, MakeLabel(rimLightPower));
        
        EditorGUILayout.Space(5.0f);
        GUILayout.Label("Rim Light smooth settings", EditorStyles.boldLabel);
        
        MaterialProperty rimLightLeftEdge = GetProperty("_RimLightLeftEdge");
        _materialEditor.ShaderProperty(rimLightLeftEdge, MakeLabel(rimLightLeftEdge));
        
        MaterialProperty rimLightRightEdge = GetProperty("_RimLightRightEdge");
        _materialEditor.ShaderProperty(rimLightRightEdge, MakeLabel(rimLightRightEdge));
    }

    private void RenderOutline()
    {
        GUILayout.Label("Outline settings", EditorStyles.boldLabel);
        
        MaterialProperty outlineColor = GetProperty("_OutlineColor");
        _materialEditor.ShaderProperty(outlineColor, MakeLabel(outlineColor));
        
        MaterialProperty outlineWidth = GetProperty("_OutlineWidth");
        _materialEditor.ShaderProperty(outlineWidth, MakeLabel(outlineWidth));
    }

    private static GUIContent MakeLabel(MaterialProperty property, string tooltip = null)
    {
        _staticLabel.text = property.displayName;
        _staticLabel.tooltip = tooltip ?? String.Empty;
        return _staticLabel;
    }

    private MaterialProperty GetProperty(string name)
    {
        return FindProperty(name, _materialProperties);
    }
}
