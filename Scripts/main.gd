extends Node

@onready var pikachuBuilder = preload("res://Scripts/Builder/PikachuBuilder.gd")
@export var mob_scene: PackedScene
# @Justin "UILabel is now as a "GameMode" Label in the HUD. 
# The controlling var is in the Gloabl File Game.gd as GameMode
# you can delte this
# @export var UI: Label
var score

# storing the selected pikachu
var selected_pikachus = []
# all pikachus in the group "pikachus"
var pikachus = []

# for now gamemode 0 is general mode and 1 is buildmode
var gamemode = "play"
@onready var start_position = $TileMap.start_position

#cursor
var default_cursor = preload("res://Assets/Sprites/Cursor/test_cursor_2.png")
#cursor 1 looks horrible - do not use
#var hover_cursor = preload("res://Assets/Sprites/Cursor/test_cursor_2.png")


# Called when the node enters the scene tree for the first time.
func _ready():
	new_game() # Replace with function body.
	
	#set cursor to default
	Input.set_custom_mouse_cursor(default_cursor, Input.CURSOR_ARROW, Vector2(5,0))
	#pikachuBuilder._build_pikachu(self,self.find_child("TileMap"),start_position)
	
	get_pikachus()
		

func get_pikachus():
	pikachus = []
	pikachus = get_tree().get_nodes_in_group("pikachus")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_change_gamemode()
	
	
func new_game():
	score = 0
	$Music.play()
	# $Pikachu.start($StartPosition.position)


func _input(event):
#	_berry_hover_check()
#	_add_new_pikachu(event)
	if Input.is_action_just_pressed("left_click"):
		for p in pikachus:
			if p.pik_hover:
				selected_pikachus.append(p)
	if Input.is_action_just_pressed("right_click"):
		for p in selected_pikachus:
			p.make_path()
		


#When gamemode is in placemode you can place new pikachu
#only for testing for now can be refactored for building pikachu
#func _add_new_pikachu(event):
#	if Input.is_action_pressed("left_click") && gamemode =="Place":
#		var x_position = round(event)
#		var y_position = round(event.position.y/3)
#		var position = Vector2(100,100)
#		pikachuBuilder._build_pikachu(self,self.find_child("TileMap"),position)



func _change_gamemode():
	if Input.is_action_pressed("B"):
		Game.GameMode = "build"
	if Input.is_action_pressed("R"):
		Game.GameMode = "play"
	if Input.is_action_pressed("P"):
		Game.GameMode = "edit"


func _on_pikachu_clicked(object: CharacterBody2D):
	selected_pikachus.append(object)
