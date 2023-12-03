extends StaticBody2D

var buildingHover = false
@onready var unitBuilder = preload("res://Scripts/Builder/UnitBuilder.gd")

'until we have other units every building produces Pikachu'
@onready var pikachu = preload("res://Scenes/pokemon/pikachu.tscn")
@onready var squirtle = preload("res://Scenes/pokemon/squirtle.tscn")
@onready var charmander = preload("res://Scenes/pokemon/charmander.tscn")
@onready var bulbasaur = preload("res://Scenes/pokemon/bulbasaur.tscn")

var main: Node
var UI: Node

var currently_training = false

var tileId:int
var maxHealth = 200
var currentHealth

# Called when the node enters the scene tree for the first time.
func _ready():
	Game.GameMode = "play"
	main = get_tree().get_root().get_node("Main")
	UI = main.get_node("UI")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

'
timer functions
'
func _start_training(evolution):
	var scene = load("res://Scenes/GUI/Trainicon.tscn")
	var queueItem = scene.instantiate()
	queueItem.get_node("UnitIcon").texture = check_current_pokemon(evolution)
	queueItem.building = self
	queueItem.evolution = evolution
	queueItem.type = check_training_name(evolution)
	UI.get_node("TrainingQueue").add_child(queueItem)

func check_training_name(evolution):
	if "PokeCenter" in self.name:
		return "Pikachu"
	if "Fire Arena" in self.name:
		match evolution:
			0: return "Charmander"
			1: return "Charmeleon"
			2: return "Charizard"
	if "Water Arena" in self.name:
		match evolution:
			0: return "Squirtle"
			1: return "Wartortle"
			2: return "Blastoise"
	if "Plant Arena" in self.name:
		match evolution:
			0: return "Bulbasaur"
			1: return "Ivysaur"
			2: return "Venusaur"

func training_finished(evolution):
	currently_training = false
	if "PokeCenter" in self.name:
		unitBuilder._build_unit(main,"Pikachu",self.position, 16,0)
	if "Fire Arena" in self.name:
		match evolution:
			0: unitBuilder._build_unit(main,"Charmander",self.position, 48,0)
			1: unitBuilder._build_unit(main,"Charmander",self.position, 48,1)
			2: unitBuilder._build_unit(main,"Charmander",self.position, 48,2)
	if "Water Arena" in self.name:
		match evolution:
			0: unitBuilder._build_unit(main,"Squirtle",self.position, 48,0)
			1: unitBuilder._build_unit(main,"Squirtle",self.position, 48,1)
			2: unitBuilder._build_unit(main,"Squirtle",self.position, 48,2)
	if "Plant Arena" in self.name:
			match evolution:
				0: unitBuilder._build_unit(main,"Bulbasaur",self.position,48,0)
				1: unitBuilder._build_unit(main,"Bulbasaur",self.position, 48,1)
				2: unitBuilder._build_unit(main,"Bulbasaur",self.position, 48,2)
	# increase unit counter
	Game.friendlyUnits += 1


'
Input managment functions
'
func _on_mouse_entered():

	buildingHover = true

func _on_mouse_exited():
	buildingHover = false

func _on_input_event(viewport, event, shape_idx):
	if Game.is_paused:
		return
	if buildingHover:
		if Game.selectedBuilding == "delete":
			_delete_building(event)
		elif Game.GameMode == "play" && Input.is_action_just_released("left_click"):
			_show_train_UI()



func train_unit(evolution):
	if Game.Food >= _check_food(evolution):
		Game.Food -=  _check_food(evolution)
		_start_training(evolution)
		

func _delete_building(event):
	if Input.is_action_just_pressed("left_click") && !currently_training && self.name != "PokeCenter":
		var tileMap = get_tree().get_root().get_node("Main/TileMap")
		tileMap._delete_building(self.position, tileId)
		Game.buildCounter -= 1
		self.queue_free()

func _show_train_UI():
	UI.currentBuilding = self
	UI.get_node("TrainBox").show()
	UI.show_training_button()
	
func check_current_pokemon(evolution):
	if "PokeCenter" in self.name:
		return load(Game.pikachuIcon)
	if "Fire Arena" in self.name:
		match evolution:
			0: return load(Game.CharmanderIcon)
			1: return load(Game.CharmeleonIcon)
			2: return load(Game.CharizardIcon)
	if "Water Arena" in self.name:
			match evolution:
				0: return load(Game.SquirleIcon)
				1: return load(Game.WartortleIcon)
				2: return load(Game.BlastoiseIcon)
	if "Plant Arena" in self.name:
			match evolution:
				0: return load(Game.BulbasaurIcon)
				1: return load(Game.IvysaurIcon)
				2: return load(Game.VenusaurIcon)


func _check_food(evolution):
	if "PokeCenter" in self.name:
		return Game.PIKACHU_COST
	if "Fire Arena" in self.name:
		match evolution:
			0: return Game.CHARMANDER_COST
			1: return Game.CHARMELEON_COST
			2: return Game.CHARIZARD_COST
	if "Water Arena" in self.name:
		match evolution:
			0: return Game.SQUIRTLE_COST
			1: return Game.WARTORTLE_COST
			2: return Game.BLASTOISE_COST
	if "Plant Arena" in self.name:
		match evolution:
			0: return Game.BULBASAUR_COST
			1: return Game.IVYSAUR_COST
			2: return Game.VENUSAUR_COST
