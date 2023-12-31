extends Object

class_name PikachuBuilder


# instantiate a new scene
#						asChildOf   sceneName    startPosition     offset
static func _build_unit(main: Node, name:String, position:Vector2, y_offset, evolution):
	var unitPath = _select_path(main, name)
	var unitScene = _select_scene(name)
		
	var unit = unitScene.instantiate()
	unit.position = position
	unit.position.y += y_offset
	if name != "Pikachu":
		unit.evolution = evolution

	unitPath.add_child(unit)
	# pikachus need the name Pikachu, to be recognized by resources farming-area
	unit.name = name
	
	# recall to have all pikachus from the "pikachus"-group in "pikachus"-variable again
	main.get_friendly_units()

static func _select_scene(name:String):
	match name:
		"Pikachu":
			return preload(Game.pikachu)
		"Charmander":
			return preload(Game.charmander)
		"Bulbasaur":
			return preload(Game.bulbasaur)
		"Squirtle":
			return preload(Game.squirtle)
			
static func _select_path(main:Node,name:String):
	match name:
		"Pikachu":
			return main.get_node("Units").get_node("Pikachus")
		"Charmander":
			return main.get_node("Units").get_node("Charmanders")
		"Bulbasaur":
			return main.get_node("Units").find_child("Bulbasaurs")
		"Squirtle":
			return main.get_node("Units").find_child("Squirtles")
