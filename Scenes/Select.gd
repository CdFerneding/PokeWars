extends Node

var is_selecting = false
var selection_start
var selected_units = []

func _input(event):
	if Input.is_action_pressed("LeftClick"):
		is_selecting = true
		selection_start = get_viewport().get_mouse_position()
		selected_units.clear()
	elif Input.is_action_just_released("LeftClick"):
		is_selecting = false
	elif is_selecting && Input.is_action_pressed("LeftClick"):
		var current_mouse = get_viewport().get_mouse_position()
		# Calculate the selection rectangle here.
		# You can use a Control node for visualizing the selection rectangle.
		# Check for units within the rectangle and add them to selected_units.
