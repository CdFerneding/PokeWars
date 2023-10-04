extends TileMap
class_name kanto

# load the berryfield.tscn into this script
# the goal is to replace all red berries (tilemap: 1, (1, 0), 0
@onready var berryfield = preload("res://Scenes/berrybush.tscn")

@export var TILE_SCENE = {
	"1, 1, Vector2(1, 0)": berryfield 
}

# Called when the node enters the scene tree for the first time.
func _ready():
	# get all tile positions that use the "red berries"
	# returns the position of the tile in it's upper left corner
	var berrybushes = get_used_cells_by_id(1, 1, Vector2(1, 0))
	for i in range(berrybushes.size()):
		print(berrybushes[i])
	add_berrybush(berrybushes)


func add_berrybush(berrybushes):
	for i in range(berrybushes.size()):
		var tile_pos = berrybushes[i]
		var local_pos = map_to_local(tile_pos)
		print(local_pos)
		local_pos.x -= 50
		var bb = berryfield.instantiate() # create instance of bb scene
		bb.set_position(local_pos)  # Set the world position
		add_child(bb)


