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
	Game.HOME_BASE = home_base

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

func _place_building(position:Vector2, tileId):
	if tileId == 3 and Game.Wood < Game.FIRE_ARENA_COST:
		return
	elif tileId == 4 and Game.Wood < Game.PLANT_ARENA_COST:
		return
	elif tileId == 5 and Game.Wood < Game.WATER_ARENA_COST:
		return
	if position.y < 400 and position.x < 600:
		var scene = load("res://Scenes/WorldObjects/building2.tscn")
		var mainPath = get_tree().get_root().get_node("Main")
		var buildingPath = get_tree().get_root().get_node("Main/Buildings")
	
		var building = scene.instantiate()
		building.position = get_global_mouse_position()
		
		mainPath.get_buildings()
		building.main = self.main
		buildingPath.add_child(building)
	
		building.name = Game.selectedBuilding
		building.tileId = tileId
		building.get_node("Area2D/CollisionShape2D2").scale = Vector2(1.28,1.28)

func initiate_tileset(position:Vector2, tileId, building):
	var tile_position = _get_tile_position(position)
	var position_array = _create_offset(tileId, tile_position)
	tileBuiler._tile_builder(position_array, self, tileId, position, building)

func _delete_building(position: Vector2, tileId):
	var tile_position = _get_tile_position(position)
	var position_array = _create_offset(tileId, tile_position)
	tileBuiler._delete_building(position_array,self)
	Game.buildCounter -= 1
	Game.GameMode = "play"

'
creates an offset array for the tiles that 
should be placed below the building
'
func _create_offset(tileId, tile_position):
	var position_array = []
	var x_offset
	var y_offset
	match tileId:
		2:
			x_offset = 4
			y_offset = 3
		3,4,5:
			x_offset = 4
			y_offset = 4
		
	var x_pos_offset_left = tile_position.x
	var x_pos_offset_right = tile_position.x + x_offset
	var y_pos_offset_up = tile_position.y
	var y_pos_offset_down = tile_position.y - y_offset
	return [x_pos_offset_left, x_pos_offset_right, y_pos_offset_up, y_pos_offset_down]
	

'
converts the worldposition into the position on the tilemap by dividing by 16
'
func _get_tile_position(position):
	return Vector2(floor(position.x/16), floor(position.y/16))
