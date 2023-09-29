extends Node

@export var mob_scene: PackedScene
var score

# storing the selected pikachu
var selected_pikachu = []
var selected_destination
var hover = false
var pik_hover = false

# Called when the node enters the scene tree for the first time.
func _ready():
	new_game() # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func new_game():
	score = 0
	$Pikachu.start($StartPosition.position)

func _on_pikachu_mouse_entered():
	hover = true

func _on_pikachu_mouse_exited():
	hover = false

func _unhandled_input(event):
	if selected_pikachu.size() != 0:
		if Input.is_action_pressed("right_click"):
			#selected_destination = get_viewport().get_mouse_position() 
			#print(selected_pikachu[0], " from: ", selected_pikachu[0].position , " to: ", selected_destination)
			# a star algorithm here
			for p in selected_pikachu:
				p.make_path()
			# end of a star algorithm, pikachu arrived
			selected_pikachu = []
	if pik_hover and Input.is_action_pressed("left_click"):
		#print("hello world")
		selected_pikachu.append($Pikachu_2)
		hover = false



func _on_pikachu_2_mouse_exited():
	pik_hover = false


func _on_pikachu_2_mouse_entered():
	pik_hover = true
