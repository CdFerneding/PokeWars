extends TileMap
var no_obstacle = true
@export var main: Node
@onready var tileBuiler = preload("res://Scripts/Builder/TileBuilder.gd")
@onready var pikachu = preload("res://Scenes/pikachu.tscn")


'''
Description:
	places tile pokemon-center when buildmode is enabled and there are no obstacles in layer 
	1 and 2. There is probably an easier way to do it though. Especially for the if statement
	in with obstacle_layer1 but it works for now.

Notice:
	Add now check if more layers are added with obstacles

Next Step:
	Add different Building that can be placed depending on what building is selected
	depending on how we implement the functionality of the buildings add extra object
	when the player places buildings
'''

func _input(_event):
	if Input.is_action_just_pressed("left_click") && Game.GameMode == "build":
		_place_poke_center()
	if Input.is_action_pressed("left_click") && Game.GameMode == "place":
		_add_new_pikachu()


func _place_poke_center():
	var y_position = floor(get_global_mouse_position().y/16)
	var x_position = floor(get_global_mouse_position().x/16)

	var x_pos_offset_left = x_position
	var x_pos_offset_right = x_position + 4
	var y_pos_offset_up = y_position
	var y_pos_offset_down = y_position - 3
	
	var position_array = [x_pos_offset_left, x_pos_offset_right, y_pos_offset_up, y_pos_offset_down]
	tileBuiler._tileBuilder(position_array, self, 2)
	
		
		
#		var x_position = round(event)
#		var y_position = round(event.position.y/3)
#		var position = Vector2(100,100)
#		pikachuBuilder._build_pikachu(self,self.find_child("TileMap"),position)
