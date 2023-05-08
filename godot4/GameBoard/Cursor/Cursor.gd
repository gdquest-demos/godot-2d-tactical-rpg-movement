## Player-controlled cursor. Allows them to navigate the game grid, select units, and move them.
## Supports both keyboard and mouse (or touch) input.
@tool
class_name Cursor
extends Node2D

## Emitted when clicking on the currently hovered cell or when pressing "ui_accept".
signal accept_pressed(cell)
## Emitted when the cursor moved to a new cell.
signal moved(new_cell)

## Grid resource, giving the node access to the grid size, and more.
@export var grid: Resource
## Time before the cursor can move again in seconds.
@export var ui_cooldown := 0.1

## Coordinates of the current cell the cursor is hovering.
var cell := Vector2.ZERO:
	set(value):
		# We first clamp the cell coordinates and ensure that we aren't
		#	trying to move outside the grid boundaries
		var new_cell: Vector2 = grid.grid_clamp(value)
		if new_cell.is_equal_approx(cell):
			return

		cell = new_cell
		# If we move to a new cell, we update the cursor's position, emit
		#	a signal, and start the cooldown timer that will limit the rate
		#	at which the cursor moves when we keep the direction key held
		#	down
		position = grid.calculate_map_position(cell)
		emit_signal("moved", cell)
		_timer.start()

@onready var _timer: Timer = $Timer


func _ready() -> void:
	_timer.wait_time = ui_cooldown
	position = grid.calculate_map_position(cell)


func _unhandled_input(event: InputEvent) -> void:
	# Navigating cells with the mouse.
	if event is InputEventMouseMotion:
		cell = grid.calculate_grid_coordinates(event.position)
	# Trying to select something in a cell.
	elif event.is_action_pressed("click") or event.is_action_pressed("ui_accept"):
		emit_signal("accept_pressed", cell)
		get_viewport().set_input_as_handled()

	var should_move := event.is_pressed() 
	if event.is_echo():
		should_move = should_move and _timer.is_stopped()

	if not should_move:
		return

	# Moves the cursor by one grid cell.
	if event.is_action("ui_right"):
		cell += Vector2.RIGHT
	elif event.is_action("ui_up"):
		cell += Vector2.UP
	elif event.is_action("ui_left"):
		cell += Vector2.LEFT
	elif event.is_action("ui_down"):
		cell += Vector2.DOWN


func _draw() -> void:
	draw_rect(Rect2(-grid.cell_size / 2, grid.cell_size), Color.ALICE_BLUE, false, 2.0)

