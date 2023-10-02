extends TileMap


# load the berryfield.tscn into this script
# the goal is to replace all red berries (tilemap: 1, (1, 0), 0
@onready var berryfield = preload("res://Scenes/berrybush.tscn")
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	# get all tile positions that use the "red berries"
	# returns the position of the tile in it's upper left corner
	var berryfields = get_used_cells_by_id(0, 1, Vector2(1, 0))
	add_berrybush(berryfields)


func add_berrybush(array):
	var pos
	for i in range(array.size() - 1):
		# "map_to_local:
		# Returns the centered position of a cell in the TileMap's local coordinate space. 
		# To convert the returned value into global coordinates, use Node2D.to_global. See also local_to_map.
		pos = map_to_local(array[i])
		rng.randomize()
		# randomize a little bit (
		var x = pos.x + rng.randi_range(0,7)
		var y = pos.y + rng.randi_range(0,7)
		var f = berryfield.instantiate()
		f.set_position(Vector2(x,y))

