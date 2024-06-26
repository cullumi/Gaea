# How to enable Chunk Generation

> It is suggested you follow the [Getting Started](getting_started.md) tutorial **_BEFORE_** following this tutorial!

**SO**! You have a great big world to explore, but it takes forever to load ... This is where **Chunk Generation** comes in!

In this quick tutorial, you'll learn how to enable chunk generation to make it so your players can experience _vast_ worlds in a more optimized way!

## 2D Chunk Generation

> This tutorial assumes you have a basic understanding of how to set up `Generators` and `Renderers` within Gaea and as such will brush over these topics. 
> 
> If you don't have an understanding of these topics, see [this lovely tutorial](https://www.youtube.com/watch?v=oB1xsCcO9wI) by [DevWorm](https://www.youtube.com/@dev-worm)!

Gaea comes pre-packaged with multiple different generators, but for this example, we'll be using the `NoiseGenerator` node, the `TilemapGaeaRenderer` node, the Godot built-in `TileMap` node, and a `CharacterBody2D` node, which will represent our Player!

![Nodes needed for the Tutorial](../assets/tutorials/chunk_generation/chunk-generation-nodes.png)

### Setup

Once you have all the pre-requisite nodes mentioned above setup in your scene, you will want to search for the `ChunkLoader2D` node.

![Find the ChunkLoader node in the Node search](..%2Fassets%2Ftutorials%2Fchunk_generation%2Fchunk-loader-2d.png)

After finding this node, you can add it anywhere in the scene tree, in this instance, I've added it as a child node of the `NoiseGenerator`

![Add the Chunk](..%2Fassets%2Ftutorials%2Fchunk_generation%2Fchunk-generation-loader.png)

Once this node has been added to the tree, you need to assign the `Generator` and `Actor` nodes to the `ChunkLoader2D`, these map to the `NoiseGenerator` and `CharacterBody2D` nodes mentioned earlier!

![assign-nodes.gif](..%2Fassets%2Ftutorials%2Fchunk_generation%2Fassign-nodes.gif)

After this has been done ... **_VOILÀ!_** You now have Chunk Generation enabled for your 2D world! Once this is done, you can play around with the settings of the ChunkLoader to tune it to your liking!

## 3D Chunk Generation

> ⚠ **!! This feature is currently experimental !!** ⚠
> 
> A tutorial for this feature will not be written until the feature has been marked as stable

### _Tutorial Coming Soon_