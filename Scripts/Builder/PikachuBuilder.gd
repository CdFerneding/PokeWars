extends Object

class_name PikachuBuilder


static func _build_pikachu(main:Node,tileMap:TileMap, position:Vector2):
	var scene = load("res://Scenes/pikachu.tscn")
	var pikachu = scene.instantiate()
	pikachu.position = position
	pikachu.tilemap = tileMap
	pikachu.main = main
	main.add_child(pikachu)
