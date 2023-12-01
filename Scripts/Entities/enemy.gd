extends BadPokemon

class_name enemy

#@export var main: Node
#@export var main: Node
var enemy_hover = false
signal enemy_clicked

# this is the position that the enemy will attack when all pikachus are dead
# initializing home_base position
var pathTilemap = Game.get_tree().get_root().get_node("Main/TileMap")
var home_base = pathTilemap.home_base

@export var possible_targets = []
@export var nearest_target: CharacterBody2D

@export var arena : Node = null

var previous_direction

var current_target: Node

#implements the pathfinding algorithm
@onready var nav_agent:= $NavigationAgent2D #as NavigationAgent2D

func _ready():
	# make the enemies significantly slower than economy pokemon
	speed = 18
	
	previous_direction = "down"
	$AnimatedSprite2D.animation = "walk_down"
	$AttackCooldown.start()
	#var main_node = get_tree().get_root().get_node("Main")
	
	super()
	

func _process(_delta:float):
	if Game.is_paused == true:
		return
	enemy_scale_on_hover()
		
func attack():
	(current_target as GoodPokemon)._on_hit(1, PokemonType.ELECTRICITY)
	$AttackCooldown.start()
	
func _physics_process(_delta: float) -> void:
	if Game.is_paused == true:
		return
#	var prev_vel = velocity
	if self.position == target:
		return
		
	var next_pos = nav_agent.get_next_path_position()
	var dir = to_local(next_pos).normalized()
	velocity = dir * speed
	
	if position.distance_to(next_pos) < 10:
		velocity = Vector2.ZERO
		if $AttackCooldown.is_stopped() and current_target != null:
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
	if Game.is_paused == true:
		return
	enemy_hover = true
	selected = true
	set_selected(selected)

func _on_mouse_exited():
	if Game.is_paused == true:
		return
	enemy_hover = false
	selected = false
	set_selected(selected)


func _enemy_hover_selected_check(_event):
	if Game.is_paused == true:
		return
	if enemy_hover and Input.is_action_pressed("left_click"):
		#emit_signal("pikachu_clicked", self)
		enemy_hover = false
		
	# leftclick on "nothing" to deselect units
	elif Input.is_action_pressed("left_click"):
		enemy_hover = false


func enemy_scale_on_hover() -> void:
	if enemy_hover:
		self.scale.x = 0.6
		self.scale.y = 0.6

	else:
		self.scale.x = 0.5
		self.scale.y = 0.5

func _on_input_event(_viewport, event, _shape_idx):
	if Game.is_paused == true:
		return
	if enemy_hover:
		_enemy_hover_selected_check(event)


func _on_retarget_timer_timeout():
	if Game.is_paused == true:
		return
	self.call_thread_safe("retarget")
	
func retarget():
	if Game.is_paused == true:
		return
	var pathMain = get_tree().get_root().get_node("Main")
	possible_targets = pathMain.get_good_pokemon()
	nearest_target = null
	if possible_targets.size() == 0:
		return
	for target in possible_targets:
		if target == null:
			continue
		if nearest_target == null or target.position.distance_to(position) < nearest_target.position.distance_to(position):
			nearest_target = target
			current_target = target

	if nearest_target != null:
		nav_agent.target_position = nearest_target.position
		target = nav_agent.target_position
		if nearest_target.position.distance_to(position) > 100:
			$RetargetTimer.wait_time = 2
		else:
			$RetargetTimer.wait_time = 0.5

func _on_hit(damage, type):
	var pathMain = get_tree().get_root().get_node("Main")
	damage = calculateDamage(damage, type)
	health_bar.value -= damage
	if health_bar.value == 0:
		pathMain.enemies.erase(self)
		self.queue_free()
		pathMain.get_units()
