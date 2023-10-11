extends TileMap
var no_obstacle = true
@export var main: Node
@onready var tileBuiler = preload("res://Scripts/Builder/TileBuilder.gd")
@onready var berryfield = preload("res://Scenes/berrybush.tscn")

@export var TILE_SCENE = {
	"1, 1, Vector2(1, 0)": berryfield 
}

# Called when the node enters the scene tree for the first time.
func _ready():
	var berrybushes = get_used_cells_by_id(1, 1, Vector2(1, 0))
	for i in range(berrybushes.size()):
		pass
	add_berrybush(berrybushes)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

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

func add_berrybush(berrybushes):
	for i in range(berrybushes.size()):
		var tile_pos = berrybushes[i]
		var local_pos = map_to_local(tile_pos)
		var bb = berryfield.instantiate() # create instance of bb scene
		bb.set_position(local_pos)  # Set the world position
		add_child(bb)

func _input(event):
	if Input.is_action_just_pressed("left_click") && main.gamemode == "Build":
		_place_poke_center()


func _place_poke_center():
	var y_position = floor(get_global_mouse_position().y/16)
	var x_position = floor(get_global_mouse_position().x/16)

	var x_pos_offset_left = x_position
	var x_pos_offset_right = x_position + 4
	var y_pos_offset_up = y_position
	var y_pos_offset_down = y_position - 3
	
	var position_array = [x_pos_offset_left, x_pos_offset_right, y_pos_offset_up, y_pos_offset_down]
	tileBuiler._tileBuilder(position_array, self, 2)
