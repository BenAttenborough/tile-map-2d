# About

WIP: Attempt to make a 2d tile map utility for Love2d.
The intention is to create a tool for making Zelda like games.
A map will be stored to represent a world. Each element of the map will represent a tile.
The dev can input a table with the map information and a spritesheet and the utility will draw the map.
Extending on this the map could extend beyond the edges of the screen and be scrollable.

Will need some sort of configuration.
I'm thinking the tilemap2d class will take a table of values on initialisation. The table will contain:
* Map array - a two-dimensional array which represents the map to be rendered
* Spritemap - a spritemap which is a png representing all the tiles
* Tile size - A width and height for each tile. The engine will cut out tiles from the sprite map depending on these variables

# Todo

* Verify the playfield table is valid before using it and show error if not. (Probably check the number of columns * eidth of tile = width of table)
* Work out file IO (see [Here](https://love2d.org/wiki/love.filesystem))

# Notes

Files saved to `/Users/benattenborough/Library/Application Support/LOVE/tile-map-2d`

Draw modes:
fill
Draw filled shape.
line
Draw outlined shape.
