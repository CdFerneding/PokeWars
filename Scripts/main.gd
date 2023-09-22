extends Node

@export var mob_scene: PackedScene
var score

# storing the selected pikachu
var selected_pikachu = []
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
		selected_pikachu.append($Pikachu)

func _unhandled_input(event):
	if selected_pikachu.size() != 0:
		if Input.is_action_pressed("right_click"):
			selected_destination = get_viewport().get_mouse_position()
			print(selected_pikachu[0], " from: ", selected_pikachu[0].position , " to: ", selected_destination)
			# a star algorithm here
			
			# end of a star algorithm, pikachu arrived
			selected_pikachu = []


