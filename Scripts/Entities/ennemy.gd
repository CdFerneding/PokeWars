extends BadPokemon

class_name Ennemy

#@export var main: Node
#@export var main: Node
var ennemy_hover = false
signal ennemy_clicked

# pikachu highlighting 
@export var selected = false
@onready var box = get_node("Selected")

@export var possible_targets: Array[Node] = []
@export var nearest_target: CharacterBody2D


var previous_direction

var updaterPikachus : Node

var current_target: Node


#implements the pathfinding algorithm
@onready var nav_agent:= $NavigationAgent2D #as NavigationAgent2D

func _ready():
	previous_direction = "down"
	$AnimatedSprite2D.animation = "walk_down"
	$AttackCooldown.start()
	#var main_node = get_tree().get_root().get_node("Main")
	set_selected(selected)
	super()

func set_selected(value):
	selected = value
	box.visible = value

func _process(_delta:float):
	ennemy_scale_on_hover()
		
func attack():
	if current_target is Pikachu:
		(current_target as Pikachu)._on_hit(1)
	$AttackCooldown.start()
	
func _physics_process(_delta: float) -> void:
#	var prev_vel = velocity
	if self.position == target:
		return
		
	var next_pos = nav_agent.get_next_path_position()
	var dir = to_local(next_pos).normalized()
	velocity = dir * speed
	
	if position.distance_to(next_pos) < 10:
		velocity = Vector2.ZERO
		if $AttackCooldown.is_stopped() and current_target:
			attack()
			
	apply_corresponding_animation(velocity)
	
	move_and_slide()
	
# added is_farming = false to cancel farming when a new destination is issued for pikachu
func make_path(ressource_position = get_global_mouse_position()) -> void:
	nav_agent.target_position = nearest_target.position
	target = nav_agent.target_position
	
#toDo
#not sufficient yet
func apply_corresponding_animation(_prev):
	var current_animation = ""
	
	#if prev.x == velocity.x and prev.y == velocity.y:
	#	current_animation += "down_"
		
	if velocity.y > 0:
		current_animation+="down_"
	elif velocity.y < 0:
		current_animation+="up_"
		
	if velocity.x < 0:
		current_animation+="left_"
	elif velocity.x > 0:
		current_animation += "right_"
		
	if current_animation == "":
		current_animation = previous_direction+"_"
	
	previous_direction = current_animation.left(current_animation.length() - 1)
	current_animation = "walk_"+previous_direction

	$AnimatedSprite2D.animation = current_animation
	$AnimatedSprite2D.play()


func _on_mouse_entered():
	ennemy_hover = true
	set_selected(!selected)

func _on_mouse_exited():
	ennemy_hover = false
	set_selected(!selected)


func _ennemy_hover_selected_check(_event):
	if ennemy_hover and Input.is_action_pressed("left_click"):
		#emit_signal("pikachu_clicked", self)
		ennemy_hover = false
		
	# leftclick on "nothing" to deselect units
	elif Input.is_action_pressed("left_click"):
		ennemy_hover = false


func ennemy_scale_on_hover() -> void:
	if ennemy_hover:
		self.scale.x = 0.6
		self.scale.y = 0.6

	else:
		self.scale.x = 0.5
		self.scale.y = 0.5

func _on_input_event(_viewport, event, _shape_idx):
	if ennemy_hover:
		_ennemy_hover_selected_check(event)


func _on_retarget_timer_timeout():
	possible_targets = updaterPikachus.pikachus
	for target in possible_targets:
		if nearest_target == null or target.position.distance_to(position) < nearest_target.position.distance_to(position):
			nearest_target = target
			current_target = target
	
	nav_agent.target_position = nearest_target.position
	target = nav_agent.target_position

func _on_main_set_updater(scene: Node):
	updaterPikachus = scene
