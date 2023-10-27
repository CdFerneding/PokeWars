extends TileMap
var no_obstacle = true
@export var main: Node
@onready var tileBuiler = preload("res://Scripts/Builder/TileBuilder.gd")
@onready var berryfield = preload("res://Scenes/WorldObjects/berrybush.tscn")
@export var start_position = Vector2()
# even though you can place multiple pokemon_centers you have only one pokecenter which the enemies will attack
@export var home_base = Vector2()
var selectedBuilding = "PokeCenter"


@export var TILE_SCENE = {
	"1, 1, Vector2(1, 0)": berryfield 
}

# Called when the node enters the scene tree for the first time.
func _ready():
	var all_pokemon_centers = get_used_cells_by_id(1,2, Vector2(0,0))
	
	if all_pokemon_centers.size() == 0:
		start_position = all_pokemon_centers[0]
		start_position = map_to_local(start_position)
		home_base = all_pokemon_centers[0]
		home_base = map_to_local(home_base)


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

func _place_building(tile_position:Vector2, x_offset, y_offset, tileId):
	
	var x_pos_offset_left = tile_position.x
	var x_pos_offset_right = tile_position.x + x_offset
	var y_pos_offset_up = tile_position.y
	var y_pos_offset_down = tile_position.y - y_offset
	
	var position_array = [x_pos_offset_left, x_pos_offset_right, y_pos_offset_up, y_pos_offset_down]
	if tileBuiler._tile_builder(position_array, self, tileId):
		_initiate_building(tile_position)


func _initiate_building(position:Vector2):

	var scene = load("res://Scenes/building.tscn")
	var mainPath = main.get_tree().get_root().get_node("Main")
	var buildingPath = main.get_tree().get_root().get_node("Main/Buildings")
	
	var building1 = scene.instantiate()
	building1.position = get_global_mouse_position()
	building1.main = main
	print(building1.position)
	buildingPath.add_child(building1)
	
	building1.name = Game.selectedBuilding
	
	mainPath.get_buildings()

