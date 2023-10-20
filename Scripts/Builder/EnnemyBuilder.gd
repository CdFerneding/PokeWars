extends Object

class_name EnnemyBuilder


static func _build_ennemy(main:Node,tileMap:TileMap, position:Vector2):
	var scene = load("res://Scenes/ennemy.tscn")
	var ennemy = scene.instantiate()
	ennemy.position = position
	ennemy.tilemap = tileMap
	ennemy.main = main
	main.add_child(ennemy)
