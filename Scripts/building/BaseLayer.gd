extends TileMap
class_name InteractiveTilemap

export(Dictionary) var TILE_SCENE := {
	1: preload("res://Scenes/berry_bush.tscn")
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func add_berry_bush():
	var pos
	for i in range(0, array.size() - 1):
		

