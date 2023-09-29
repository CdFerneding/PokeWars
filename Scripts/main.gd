extends Node

@export var mob_scene: PackedScene
var score

# storing the selected pikachu
var selected_pikachu = []
var selected_destination
var pik_hover = false


#deprecated attributes
var hover = false

# Called when the node enters the scene tree for the first time.
func _ready():
	new_game() # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pikatchu_scale_on_hover()
		
	
func new_game():
	score = 0
	$Pikachu.start($StartPosition.position)


func _unhandled_input(event):
	if selected_pikachu.size() != 0:
		if Input.is_action_pressed("right_click"):
			# a star algorithm here
			for p in selected_pikachu:
				p.make_path()
			# end of a star algorithm, pikachu arrived
			selected_pikachu = []
	if pik_hover and Input.is_action_pressed("left_click"):
		selected_pikachu.append($Pikachu_2)
		pik_hover = false
	elif Input.is_action_pressed("left_click"):
		pik_hover = false



func _on_pikachu_2_mouse_exited():
	pik_hover = false


func _on_pikachu_2_mouse_entered():
	pik_hover = true
	
func pikatchu_scale_on_hover() -> void:
	if pik_hover:
		$Pikachu_2.scale.x = 1.1
		$Pikachu_2.scale.y = 1.1
	else:
		$Pikachu_2.scale.x = 1.0
		$Pikachu_2.scale.y = 1.0

#deprecated functions

func _on_pikachu_mouse_entered():
	hover = true

func _on_pikachu_mouse_exited():
	hover = false
