extends Node

@export var mob_scene: PackedScene
var score

# storing the selected pikachu
var selected = []
var selected_destination

# Called when the node enters the scene tree for the first time.
func _ready():
	new_game() # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func new_game():
	score = 0
	$Pikachu.start($StartPosition.position)
		
func _on_pikachu_input_event(viewport, event, shape_idx):
	if Input.is_action_pressed("left_click"):
		print("left click on pikachu")
		selected.append($Pikachu)
		print(selected)
		print(selected.size())

func _unhandled_input(event):
	if selected.size() != 0:
		if Input.is_action_pressed("right_click"):
			print("test")
			selected_destination = get_viewport().get_mouse_position()
			selected = []
			print(selected_destination)
				
