extends GoodPokemon

class_name Charmander

var pok_hover = false
signal charmander_clicked

var previous_direction

var current_target: Node

@export var attack_damage = 5

enum AttackModeEnum {ATTACK, PROTECT, STILL}

#Mode describes how the ennemy should interract.
# attack : It attack the nearest ennemy
# still : It doesn't move but attack ennemies in his range
@export var mode: AttackModeEnum = AttackModeEnum.ATTACK
#implements the pathfinding algorithm
@onready var nav_agent:= $NavigationAgent2D #as NavigationAgent2D

func _ready():
	previous_direction = "down"
	$AnimatedSprite2D.animation = "walk_down"
	var main_node = get_tree().get_root().get_node("Main")
	connect("charmander_clicked", Callable(main_node, "_on_charmander_clicked"))
	
	# super initializes the healthbar 
	super()


func _process(_delta:float):
	if Game.is_paused:
		pass
	
	charmander_scale_on_hover()
		
	
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
	
	if position.distance_to(next_pos) < 7:
		velocity = Vector2.ZERO
		if $AttackCooldown.is_stopped() and current_target != null and position.distance_to(current_target.position) < 15:
			attack()
	
	move_and_slide()
	
func attack():
	if (current_target as BadPokemon) != null:
		(current_target as BadPokemon)._on_hit(attack_damage)
	$AttackCooldown.start()
	
# added is_farming = false to cancel farming when a new destination is issued for charmander
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
	pok_hover = true
	set_selected(!selected)

func _on_mouse_exited():
	pok_hover = false
	set_selected(!selected)


func _char_hover_selected_check(_event):
	if pok_hover and Input.is_action_pressed("left_click"):
		emit_signal("charmander_clicked", self)
		pok_hover = false
		
	# leftclick on "nothing" to deselect units
	elif Input.is_action_pressed("left_click"):
		pok_hover = false


func charmander_scale_on_hover() -> void:
	if pok_hover:
		self.scale.x = 0.6
		self.scale.y = 0.6

	else:
		self.scale.x = 0.5
		self.scale.y = 0.5

func _on_input_event(_viewport, event, _shape_idx):
	if pok_hover:
		_char_hover_selected_check(event)

# function to reduce charmanders health, number damage is reducted from charmanders health_bar
func _on_hit(damage):
	var pathMain = get_tree().get_root().get_node("Main")
	health_bar.value -= damage
	if health_bar.value == 0:
		pathMain.charmanders.erase(self)
		self.queue_free()
		pathMain.get_units()
		if self in pathMain.selected_pokemon:
			pathMain.selected_pokemon.erase(self)
			Game.Selected = pathMain.selected_pokemon.size()
			
func _on_retarget_timer_timeout():
		self.call_thread_safe("retarget")

func retarget():
	var pathMain = get_tree().get_root().get_node("Main")
	var possible_targets = pathMain.get_bad_pokemon()
	var nearest_target = null
	if possible_targets.size() == 0:
		pass
	for target in possible_targets:
		if target == null:
			continue
		if nearest_target == null or target.position.distance_to(position) < nearest_target.position.distance_to(position):
			nearest_target = target
			current_target = target

	if nearest_target != null:
		target = nav_agent.target_position
		nav_agent.target_position = nearest_target.position
		if nearest_target.position.distance_to(position) > 100:
			$RetargetTimer.wait_time = 2
		else:
			$RetargetTimer.wait_time = 0.5

func change_gamemode():
	if mode == AttackModeEnum.ATTACK:
		mode = AttackModeEnum.STILL
	elif mode == AttackModeEnum.STILL:
		mode = AttackModeEnum.ATTACK
