extends Node

@onready var pikachuBuilder = preload("res://Scripts/Builder/PikachuBuilder.gd")
@export var mob_scene: PackedScene
@export var UI: Label
var score

# storing the selected pikachu
var selected_pikachu = []
var selected_destination

# for now gamemode 0 is general mode and 1 is buildmode
var gamemode = "Main"
@onready var start_position = $StartPosition.position




# ----------------------------- farming -----------------------------
# var berry_locations = []
var berryfield_hover = false


#deprecated attributes
var hover = false



# Called when the node enters the scene tree for the first time.
func _ready():
	new_game() # Replace with function body.
	UI.text = "Main"
	print(start_position)
	pikachuBuilder._build_pikachu(self,self.find_child("TileMap"),start_position)
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_change_gamemode()

	
	
func new_game():
	score = 0
	# $Pikachu.start($StartPosition.position)


func _unhandled_input(event):
	_berry_hover_check()
	_add_new_pikachu(event)

#When gamemode is in placemode you can place new pikachu
#only for testing for now can be refactored for building pikachu
func _add_new_pikachu(event):
	if Input.is_action_pressed("left_click") && gamemode =="Place":
		#var x_position = round(event)
		#var y_position = round(event.position.y/3)
		var position = Vector2(100,100)
		print(position)
		pikachuBuilder._build_pikachu(self,self.find_child("TileMap"),position)
		

# ----------------------------- register mouse hovering -----------------------------

func _on_berryfield_mouse_entered():
	berryfield_hover = true
	
func _on_berryfield_mouse_exited():
	berryfield_hover = false


func _berry_hover_check():
	if selected_pikachu.size() != 0:
		if Input.is_action_pressed("right_click") and !berryfield_hover:
			# a star algorithm here
			print(selected_pikachu.size())
			for p in selected_pikachu:
				p.make_path()
			# end of a star algorithm, pikachu arrived
			
		# check if
		if Input.is_action_pressed("right_click") and berryfield_hover: 
			for p in selected_pikachu:
				p.farm_berries()
	

func _change_gamemode():
	if Input.is_action_pressed("B"):
		gamemode = "Build"
		UI.text = gamemode
	if Input.is_action_pressed("R"):
		gamemode = "Main"
		UI.text = gamemode
	if Input.is_action_pressed("P"):
		gamemode = "Place"
		UI.text = gamemode

#deprecated functions

#func _on_pikachu_mouse_entered():
#	hover = true
#
#func _on_pikachu_mouse_exited():
#	hover = false

