extends GoodPokemon

class_name Bulbasaur

signal bulbasaur_clicked

var current_target: Node

@export var attack_damage = 5

var followPlayerOrder: bool = false

enum AttackModeEnum {ATTACK, PROTECT, STILL}

# handling evolution differences
@export var evolution = 0
@onready var animationSprite = $bulbasaur
@export var selected = false 
@onready var box = $BulbasaurSelected

#Mode describes how the ennemy should interract.
# attack : It attack the nearest ennemy
# still : It doesn't move but attack ennemies in his range
@export var mode: AttackModeEnum = AttackModeEnum.ATTACK
#implements the pathfinding algorithm
@onready var nav_agent:= $NavigationAgent2D #as NavigationAgent2D

func _ready():
	animationSprite.animation = "walk_down"
	var main_node = get_tree().get_root().get_node("Main")
	$PlayerNavigationAgent.target_position = position
	connect("bulbasaur_clicked", Callable(main_node, "_on_bulbasaur_clicked"))
	
	# super initializes the healthbar 
	super()
	
	set_selected(false)
	# check evolution level and apply corresponding sprite
	check_evolution()


func _process(_delta:float):
	if Game.is_paused:
		return
	
	charmander_scale_on_hover()
	check_evolution()
		
	
func _physics_process(_delta: float) -> void:
	if Game.is_paused:
		return
#	var prev_vel = velocity
	#if int(nav_agent.distance_to_target() < 2):
		#return
	var next_pos: Vector2
	if followPlayerOrder:
		next_pos = $PlayerNavigationAgent.get_next_path_position()
	elif mode != AttackModeEnum.STILL:
		next_pos = nav_agent.get_next_path_position()
		$PlayerNavigationAgent.target_position = position
	else:
		next_pos = position
	
	var dir = to_local(next_pos).normalized()
	velocity = dir * speed
	
	if position.distance_to(next_pos) < 1:
		velocity = Vector2.ZERO
		if dir != Vector2.ZERO:
			self.position = next_pos
		target = self.position
		followPlayerOrder = false
	
	apply_corresponding_animation()
	
	if $AttackCooldown.is_stopped() and current_target != null and position.distance_to(current_target.position) < 10:
		attack()
	
	move_and_slide()
	
func attack():
	if Game.is_paused:
		return
	if (current_target as BadPokemon) != null:
		(current_target as BadPokemon)._on_hit(attack_damage)
	$AttackCooldown.start()
	

func make_path(ressource_position = get_global_mouse_position()) -> void:
	$PlayerNavigationAgent.target_position = ressource_position
	target = $PlayerNavigationAgent.target_position
	followPlayerOrder = true
	

func apply_corresponding_animation():
	var current_animation
	
	# calculate the degrees of the walking direction
	var current_velocity = get_real_velocity()
	var radians = current_velocity.angle()
	var degrees = radians * (180/PI)
	if degrees < 0:
		degrees = 360 - abs(degrees)
	
	if degrees >= 22.5 and degrees <= 67.5:
		current_animation = "walk_down_right"
	elif degrees > 67.5 and degrees <= 112.5:
		current_animation = "walk_down"
	elif degrees > 112.5 and degrees <= 157.5:
		current_animation = "walk_down_left"
	elif degrees > 157.5 and degrees <= 202.5:
		current_animation = "walk_left"
	elif degrees > 202.5 and degrees <= 247.5:
		current_animation = "walk_up_left"
	elif degrees > 247.5 and degrees <= 292.5:
		current_animation = "walk_up"
	elif degrees > 292.5 and degrees <= 337.5:
		current_animation = "walk_up_right"
	else:
		current_animation = "walk_right"


	animationSprite.animation = current_animation
	animationSprite.play()

func check_evolution():
	# check current evolution of charmander and enable / disable according boxes, shapes and sprites
	if evolution == 0:
		$bulbasaur.visible = true
		$CollisionShapeBulbasaur.visible = true
		animationSprite = $bulbasaur
		box = $BulbasaurSelected
		## disable charmeleon and charizard sprites
		$ivysaur.visible = false
		$venusaur.visible = false
		## disable collision shapes
		$CollisionShapeIvysaur.visible = false
		$CollisionShapeVenusaur.visible = false
		## disable selection boxes
		$IvysaurSelected.visible = false
		$VenusaurSelected.visible = false
	elif evolution == 1:
		$ivysaur.visible = true
		$CollisionShapeIvysaur.visible = true
		animationSprite = $ivysaur
		box = $IvysaurSelected
		## disable charmander and charizard
		$bulbasaur.visible = false
		$venusaur.visible = false
		## disable collision shapes
		$CollisionShapeBulbasaur.visible = false
		$CollisionShapeVenusaur.visible = false
		## disable selection boxes
		$BulbasaurSelected.visible = false
		$VenusaurSelected.visible = false
	else:
		$venusaur.visible = true
		$CollisionShapeVenusaur.visible = true
		animationSprite = $venusaur
		box = $VenusaurSelected
		## diable charmander and charmeleon
		$bulbasaur.visible = false
		$ivysaur.visible = false
		## disable collision shapes
		$CollisionShapeBulbasaur.visible = false
		$CollisionShapeIvysaur.visible = false
		## disable selection boxes
		$BulbasaurSelected.visible = false
		$IvysaurSelected.visible = false


func _on_mouse_entered():
	if Game.is_paused:
		return
	pok_hover = true
	set_selected(true)

func _on_mouse_exited():
	if Game.is_paused:
		return
	pok_hover = false
	set_selected(false)

func set_selected(value):
	selected = value
	box.visible = value

func _char_hover_selected_check(_event):
	if Game.is_paused:
		return
	if pok_hover and Input.is_action_pressed("left_click"):
		emit_signal("bulbasaur_clicked", self)
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
	if Game.is_paused:
		return
	if pok_hover:
		_char_hover_selected_check(event)

# function to reduce charmanders health, number damage is reducted from charmanders health_bar
func _on_hit(damage):
	if Game.is_paused:
		return
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
	if Game.is_paused:
		return
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
