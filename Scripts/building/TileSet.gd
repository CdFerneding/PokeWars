extends TileMap
var no_obstacle = true
@export var main: Node
@onready var tileBuiler = preload("res://Scripts/Builder/TileBuilder.gd")
@onready var berryfield = preload("res://Scenes/berrybush.tscn")
@export var start_position = self.get_used_cells_by_id(1,2, Vector2(0,0))[0]
var selectedBuilding = "PokeCenter"


@export var TILE_SCENE = {
	"1, 1, Vector2(1, 0)": berryfield 
}

# Called when the node enters the scene tree for the first time.
func _ready():
	var berrybushes = get_used_cells_by_id(1, 1, Vector2(1, 0))
	for i in range(berrybushes.size()):
		pass
	add_berrybush(berrybushes)
	start_position.y += 3
	start_position = map_to_local(start_position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func add_berrybush(berrybushes):
	for i in range(berrybushes.size()):
		var tile_pos = berrybushes[i]
		var local_pos = map_to_local(tile_pos)
		var bb = berryfield.instantiate() # create instance of bb scene
		bb.set_position(local_pos)  # Set the world position
		add_child(bb)


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

func _place_building(position:Vector2, x_offset, y_offset, tileId):
	var tile_position = _get_tile_position(position)
	var position_array = _create_offset(tileId, tile_position)
	if tileBuiler._tile_builder(position_array, self, tileId):
		_initiate_building(tile_position, main)
		print(get_cell_source_id(1,tile_position))
		print(tile_position)
		


func _initiate_building(position:Vector2, main:Node):

	var scene = load("res://Scenes/building.tscn")
	var mainPath = get_tree().get_root().get_node("Main")
	var buildingPath = get_tree().get_root().get_node("Main/Buildings")
	
	var building = scene.instantiate()
	building.position = get_global_mouse_position()
	building.main = self.main
	buildingPath.add_child(building)
	
	building.name = Game.selectedBuilding
	
	mainPath.get_buildings()

func _delete_building(position: Vector2):
	var tile_position = _get_tile_position(position)
	var tileId = get_cell_source_id(1,tile_position)
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
