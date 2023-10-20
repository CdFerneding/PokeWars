extends StaticBody2D

var buildingHover = false
@onready var unitBuilder = preload("res://Scripts/Builder/UnitBuilder.gd")

'until we have other units every building produces Pikachu'
@onready var pikachu = preload("res://Scenes/pikachu.tscn")

@export var main: Node

@onready var timer = $Timer

var totalTime = 10
var currentTime
var currently_training = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


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
	if self.name == "PokeCenter":
		unitBuilder._build_unit(main,pikachu,self.position, 3)
	else:
		unitBuilder._build_unit(main,pikachu,self.position, 4)



'
Input managment functions
'
func _on_mouse_entered():
	buildingHover = true

func _on_mouse_exited():
	buildingHover = false

func _on_input_event(viewport, event, shape_idx):
	if buildingHover:
		_train_unit(event)

func _train_unit(event):
	if Input.is_action_just_pressed("left_click") && Game.GameMode == "play" && Game.Food >=10 && !currently_training:
		Game.Food = Game.Food - 10
		currently_training = true
		_start_training()




