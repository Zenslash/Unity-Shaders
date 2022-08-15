# Simple Lit

Pretty simple lit shader that implements diffuse, specular light and some other stuff.

It can be used as a basis for further experiments with shaders.

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="GIF/BigPicture.png">
  <img alt="" src="https://user-images.githubusercontent.com/25423296/163456779-a8556205-d0a5-45e2-ac17-42d089e3c3f8.png">
</picture>

## Feature list
- Lambertian diffuse light
- Blinn-Phong specular light
- Ambient light
- Fresnel factor
- Normal mapping
- Cascade shadows
- GPU Instancing

## Supported light types
- Per-pixel directional, point, spot lights
- Per-vertex point, spot lights
- SH point, spot lights

## Per-pixel directional light
<picture>
  <source media="(prefers-color-scheme: dark)" srcset="GIF/DirLight.gif">
  <img alt="" src="https://user-images.githubusercontent.com/25423296/163456779-a8556205-d0a5-45e2-ac17-42d089e3c3f8.png">
</picture>

## Per-vertex point lights
<picture>
  <source media="(prefers-color-scheme: dark)" srcset="GIF/PointLight.gif">
  <img alt="" src="https://user-images.githubusercontent.com/25423296/163456779-a8556205-d0a5-45e2-ac17-42d089e3c3f8.png">
</picture>

## Per-pixel spot light
<picture>
  <source media="(prefers-color-scheme: dark)" srcset="GIF/SpotLight.gif">
  <img alt="" src="https://user-images.githubusercontent.com/25423296/163456779-a8556205-d0a5-45e2-ac17-42d089e3c3f8.png">
</picture>

## GPU Instancing
Unity uses GPU instancing for GameObjects that share the same mesh and material. To instance a mesh and material:

- The material’s shader must support GPU instancing. Unity’s Standard Shader supports GPU instancing, as do all surface shaders.
- The mesh must come from one of the following sources, grouped by behavior:
  - A MeshRenderer component or a Graphics.RenderMesh call.                                
Behavior: Unity adds these meshes to a list and then checks to see which meshes it can instance.
**Unity does not support GPU instancing for SkinnedMeshRenderers or MeshRenderer components attached to GameObjects that are SRP Batcher compatible** . For more information, see SRP Batcher compatibility.
  - A Graphics.RenderMeshInstanced or Graphics.RenderMeshIndirect call. These methods render the same mesh multiple times using the same shader. Each call to these methods issues a separate draw call. Unity does not merge these draw calls.
