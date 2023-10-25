extends GoodPokemon
#extends CharacterBody2D

var pik_hover = false
signal pikachu_clicked

var previous_direction

#implements the pathfinding algorithm
@onready var nav_agent:= $NavigationAgent2D #as NavigationAgent2D

func _ready():
	previous_direction = "down"
	$AnimatedSprite2D.animation = "walk_down"
	var main_node = get_tree().get_root().get_node("Main")
	connect("pikachu_clicked", Callable(main_node, "_on_pikachu_clicked"))
	super()


func _process(_delta:float):
	pikatchu_scale_on_hover()
		
	
func _physics_process(_delta: float) -> void:
#	var prev_vel = velocity
	#if int(nav_agent.distance_to_target() < 2):
		#return
		
	var next_pos = nav_agent.get_next_path_position()
	var dir = to_local(next_pos).normalized()
	velocity = dir * speed
	
	if position.distance_to(next_pos) < 1:
		velocity = Vector2.ZERO
		if dir != Vector2.ZERO:
			self.position = next_pos
		target = self.position
	apply_corresponding_animation(velocity)
	
	move_and_slide()
	
# added is_farming = false to cancel farming when a new destination is issued for pikachu
func make_path(ressource_position = get_global_mouse_position()) -> void:
	nav_agent.target_position = ressource_position
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
	pik_hover = true
	set_selected(!selected)

func _on_mouse_exited():
	pik_hover = false
	set_selected(!selected)


func _pika_hover_selected_check(_event):
	if pik_hover and Input.is_action_pressed("left_click"):
		emit_signal("pikachu_clicked", self)
		pik_hover = false
		
	# leftclick on "nothing" to deselect units
	elif Input.is_action_pressed("left_click"):
		pik_hover = false


func pikatchu_scale_on_hover() -> void:
	if pik_hover:
		self.scale.x = 0.6
		self.scale.y = 0.6

	else:
		self.scale.x = 0.5
		self.scale.y = 0.5

func _on_input_event(_viewport, event, _shape_idx):
	if pik_hover:
		_pika_hover_selected_check(event)

func _on_hit(damage):
	print("damage received !")
