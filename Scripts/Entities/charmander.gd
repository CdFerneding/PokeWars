extends GoodPokemon

class_name Charmander

signal charmander_clicked

var current_target: Node

@export var attack_damage = 5

var followPlayerOrder: bool = false

enum AttackModeEnum {ATTACK, PROTECT, STILL}

# handling evolution differences
@export var evolution = 0
@onready var animationSprite = $charmander
@export var selected = false 
@onready var box = $CharmanderSelected

#Mode describes how the ennemy should interract.
# attack : It attack the nearest ennemy
# still : It doesn't move but attack ennemies in his range
@export var mode: AttackModeEnum = AttackModeEnum.ATTACK
#implements the pathfinding algorithm
@onready var nav_agent:= $NavigationAgent2D #as NavigationAgent2D
var is_fighting = false

func _ready():
	animationSprite.animation = "walk_down"
	var main_node = get_tree().get_root().get_node("Main")
	$PlayerNavigationAgent.target_position = position
	connect("charmander_clicked", Callable(main_node, "_on_charmander_clicked"))
	
	# super initializes the healthbar 
	super()
	
	set_selected(false)
	# check evolution level and apply corresponding sprite
	check_evolution()


func _process(_delta:float):
	if Game.is_paused:
		return
	
	charmander_scale_on_hover()
		

# Setter-Funktion for evolution var
func set_evolution(value: int) -> void:
	# var is only allowed to be 0,1 or 2
	evolution = clamp(value, 0, 2)
	
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
	
	if is_fighting == false:
		apply_corresponding_animation()
	
	if $AttackCooldown.is_stopped() and current_target != null and position.distance_to(current_target.position) < 10:
		attack()
	
	move_and_slide()
	
func attack():
	if Game.is_paused:
		return
	if (current_target as BadPokemon) != null:
		(current_target as BadPokemon)._on_hit(attack_damage, PokemonType.FIRE)
	$AttackCooldown.start()
	

func make_path(ressource_position = get_global_mouse_position()) -> void:
	$PlayerNavigationAgent.target_position = ressource_position
	target = $PlayerNavigationAgent.target_position
	followPlayerOrder = true
	

func apply_corresponding_animation():
	var current_animation
	
	# calculate the degrees of the walking direction
	var current_velocity = velocity
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
		$charmander.visible = true
		$CollisionShapeCharmander.visible = true
		animationSprite = $charmander
		box = $CharmanderSelected
		## disable charmeleon and charizard sprites
		$charmeleon.visible = false
		$charizard.visible = false
		## disable collision shapes
		$CollisionShapeCharmeleon.visible = false
		$CollisionShapeCharizard.visible = false
		## disable selection boxes
		$CharmeleonSelected.visible = false
		$CharizardSelected.visible = false
	elif evolution == 1:
		$charmeleon.visible = true
		$CollisionShapeCharmeleon.visible = true
		animationSprite = $charmeleon
		box = $CharmeleonSelected
		## disable charmander and charizard
		$charmander.visible = false
		$charizard.visible = false
		## disable collision shapes
		$CollisionShapeCharmander.visible = false
		$CollisionShapeCharizard.visible = false
		## disable selection boxes
		$CharmanderSelected.visible = false
		$CharizardSelected.visible = false
	else:
		$charizard.visible = true
		$CollisionShapeCharizard.visible = true
		animationSprite = $charizard
		box = $CharizardSelected
		## diable charmander and charmeleon
		$charmander.visible = false
		$charmeleon.visible = false
		## disable collision shapes
		$CollisionShapeCharmander.visible = false
		$CollisionShapeCharmeleon.visible = false
		## disable selection boxes
		$CharmanderSelected.visible = false
		$CharmeleonSelected.visible = false

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
	if Game.is_paused:
		return
	if pok_hover:
		_char_hover_selected_check(event)

# function to reduce charmanders health, number damage is reducted from charmanders health_bar
func _on_hit(damage, type):
	if Game.is_paused:
		return
	var pathMain = get_tree().get_root().get_node("Main")
	damage = calculateDamage(damage, type)
	health_bar.value -= damage
	if health_bar.value == 0:
		pathMain.bulbasaurs.erase(self)
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


func _on_area_2d_area_entered(area):
	is_fighting = true


func _on_area_2d_area_exited(area):
	is_fighting = false
