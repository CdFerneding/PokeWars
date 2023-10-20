extends Object

class_name PikachuBuilder


static func _build_unit(main: Node, scene, position:Vector2, y_offset):
	var pikachuPath = main.get_tree().get_root().get_node("Main/Pikachus")
	var mainPath = main.get_tree().get_root().get_node("Main")
		
	var pikachu1 = scene.instantiate()
	pikachu1.position = position
	pikachu1.position.y += y_offset*16

	pikachuPath.add_child(pikachu1)
	# pikachus need the name Pikachu, to be recognized by resources farming-area
	pikachu1.name = "Pikachu"
	
	# recall to have all pikachus from the "pikachus"-group in "pikachus"-variable again
	mainPath.get_pikachus()
