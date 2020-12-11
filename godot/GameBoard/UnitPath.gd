## Draws the unit's movement path using an autotile.
class_name UnitPath
extends TileMap

export var grid: Resource

var _pathfinder: PathFinder
var current_path := PoolVector2Array()


## Creates a new PathFinder that uses the AStar algorithm to find a path between two cells among
## the `walkable_cells`.
func initialize(walkable_cells: Array) -> void:
	_pathfinder = PathFinder.new(grid, walkable_cells)


## Finds and draws the path between `cell_start` and `cell_end`
func draw(cell_start: Vector2, cell_end: Vector2) -> void:
	clear()
	current_path = _pathfinder.calculate_point_path(cell_start, cell_end)
	for cell in current_path:
		set_cellv(cell, 0)
	update_bitmask_region()


## Stops drawing, clearing the drawn path and the `_pathfinder`.
func stop() -> void:
	_pathfinder = null
	clear()
