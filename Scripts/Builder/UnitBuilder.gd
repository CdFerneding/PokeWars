extends Object

class_name PikachuBuilder



static func _build_unit(main: Node, name:String, position:Vector2, y_offset):
	var unitPath = _select_path(main, name)
	var unitScene = _select_scene(name)
		
	var unit = unitScene.instantiate()
	unit.position = position
	unit.position.y += y_offset

	unitPath.add_child(unit)
	# pikachus need the name Pikachu, to be recognized by resources farming-area
	unit.name = name
	print(unit.position)
	
	# recall to have all pikachus from the "pikachus"-group in "pikachus"-variable again
	main.get_units()

static func _select_scene(name:String):
	match name:
		"Pikachu":
			return preload(Game.pikachu)
		"Charmander":
			return preload(Game.charmander)
		"bulbasaur":
			return preload(Game.bulbasaur)
		"Squirtle":
			return preload(Game.squirtle)
			
static func _select_path(main:Node,name:String):
	match name:
		"Pikachu":
			print()
			return main.get_node("Units").get_node("Pikachus")
		"Charmander":
			return main.get_node("Units").get_node("Charmanders")
		"Bulbasaur":
			return main.get_node("Units").find_child("Bulbasaurs")
		"Squirtle":
			return main.get_node("Units").find_child("Squirtles")
