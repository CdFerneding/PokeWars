extends StaticBody2D

var buildingHover = false
@onready var unitBuilder = preload("res://Scripts/Builder/UnitBuilder.gd")

'until we have other units every building produces Pikachu'
@onready var pikachu = preload("res://Scenes/Pokemon/pikachu.tscn")
@onready var squirtle = preload("res://Scenes/Pokemon/squirtle.tscn")
@onready var charmander = preload("res://Scenes/Pokemon/charmander.tscn")
@onready var bulbasaur = preload("res://Scenes/Pokemon/bulbasaur.tscn")

var main: Node

@onready var timer = $Timer

var totalTime = 10
var currentTime
var currently_training = false


# Called when the node enters the scene tree for the first time.
func _ready():
	main = get_tree().get_root().get_node("Main")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

'
timer functions
'
func _start_training():
	currentTime = 0
	timer.start()
	
func _on_timer_timeout():
	currentTime += 1
	if currentTime < totalTime:
		$Label.text = str(currentTime)
		timer.start()
	else:
		$Label.text = ""
		$Created_Unit_Sound.play()
		_training_finished()


func _training_finished():
	timer.stop()
	currently_training = false
	print(self.name)
	if "PokeCenter" in self.name:
		unitBuilder._build_unit(main,"Pikachu",self.position, 3)
	if "FireBuilding" in self.name:
			unitBuilder._build_unit(main,"Charmander",self.position, 4)
	if "WaterBuilding" in self.name:
			unitBuilder._build_unit(main,"Squirtle",self.position, 4)
	if "PlantBuilding" in self.name:
			unitBuilder._build_unit(main,"Bulbasaur",self.position, 4)



'
Input managment functions
'
func _on_mouse_entered():

	buildingHover = true

func _on_mouse_exited():
	buildingHover = false

func _on_input_event(viewport, event, shape_idx):
	if buildingHover:
		if Game.GameMode == "delete":
			_delete_building(event)
		elif Game.GameMode == "play":
			_train_unit(event)


func _train_unit(event):
	if Input.is_action_just_pressed("left_click") && !currently_training:
		Game.Food = Game.Food - 10
		currently_training = true
		_start_training()

func _delete_building(event):
	if Input.is_action_just_pressed("left_click") && !currently_training:
		var tileMap = get_tree().get_root().get_node("Main/TileMap")
		tileMap._delete_building(self.position)
		Game.buildCounter -= 1
		self.queue_free()


