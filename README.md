# coretoon - ToonTree
A customizable shader for soft and painterly stylized trees.

Made for the Unity Built-in Render Pipeline (BiRP) and Universal Render Pipeline (URP).

This shader was inspired by (and uses the leaf textures from) [this GeometryNodes asset for Blender](https://reipart.gumroad.com/l/treeleaves).

## features
- [lighting](#lighting)

- [adjustable colors](#adjustable-colors)

- [leaf textures](#leaf-textures)

- [clean code/graph](#structured-code-and-graph)

- [currently missing features](#missing-features)

## lighting

ToonTree uses a very simple Lambert lighting model, which means it only supports the main directional light at the moment.
Since it's an unlit shader, it also doesn't have self-shadows (yet).

This still allows for very stylized and colorful lighting that is highly customizable and responds to sunlight.

![lighting](/Examples/toonTree_lighting.gif)


## adjustable colors

Colors are independently adjustable for specific lighting, color palettes or seasons.

![colors](/Examples/toonTree_colors.gif)

Highlights and Shadows can also be adjusted for more stylization.

- Softness - how soft or sharp the edge of highlights/shadows are

- Size - how big highlights or shadows are.

![softness](/Examples/toonTree_softness_size.gif)

Some nice color palettes for stylized trees:

`basecolor` `highlight` `shadow`

`#339D67` `#5AC452` `#0D5B7D` - original palette

`#9D3D33` `#FFA34E` `#6A1B34` - red autumn palette


## leaf textures

Supports different alpha textures for leaves. Examples for textures can be found [here](https://github.com/Yasu3D/coretoon-ToonTree/tree/main/Leaf%20Textures)

![alpha](/Examples/toonTree_alpha.gif)

## structured code and graph

This is my very first written shader but I tried to structure it well and comment most important things.

If you find any issues in my shader code or graph, open an issue or pull request about it.

![unity shadergraph](/Examples/toonTree_graph.png)

## missing features

Either wait until I decide to implement them, or do it yourself!

Features (currently) missing from the shader are:

- wind and sway
- colored lighting
- extra light support
- snow coverage

> ~ made with <3 by yasu.
