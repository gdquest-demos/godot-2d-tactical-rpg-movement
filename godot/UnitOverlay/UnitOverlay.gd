## Draws a selected unit's walkable tiles.
class_name UnitOverlay
extends TileMap


## Fills the tilemap with the cells, giving a visual representation of the cells a unit can walk.
func draw(cells: Array) -> void:
	clear()
	for cell in cells:
		set_cell(0, cell, 0, Vector2i(0,0))
