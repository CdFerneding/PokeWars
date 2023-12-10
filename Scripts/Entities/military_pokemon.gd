extends GoodPokemon

class_name MilitaryPokemon

var current_target: Node

var possible_targets: Array = []

@export var attack_damage = 5

var followPlayerOrder: bool = false

enum AttackModeEnum {ATTACK, PROTECT, STILL}

#Mode describes how the ennemy should interract.
# attack : It attack the nearest ennemy
# still : It doesn't move but attack ennemies in his range
@export var mode: AttackModeEnum = AttackModeEnum.ATTACK

#implements the pathfinding algorithm
@onready var nav_agent:= $NavigationAgent2D #as NavigationAgent2D

var is_fighting = false

func _physics_process(_delta: float) -> void:
	if Game.is_paused:
		return
#	var prev_vel = velocity
	#if int(nav_agent.distance_to_target() < 2):
		#return
	var next_pos: Vector2
	if followPlayerOrder:
		next_pos = $PlayerNavigationAgent.get_next_path_position()
		if next_pos == Vector2.ZERO:
			return
	elif mode != AttackModeEnum.STILL:
		next_pos = nav_agent.get_next_path_position()
		if next_pos == Vector2.ZERO:
			return
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
	
	if $AttackCooldown.is_stopped() and current_target != null and ((position.distance_to(current_target.position) < 10) or ((current_target as BigBadPokemon) != null and position.distance_to(current_target.position) < 50)):
		attack()
	
	move_and_slide()

func attack():
	if Game.is_paused:
		return
	if (current_target as BadPokemon) != null:
		(current_target as BadPokemon)._on_hit(attack_damage, type)
	$AttackCooldown.start()
	

func make_path(ressource_position = get_global_mouse_position()) -> void:
	$PlayerNavigationAgent.target_position = ressource_position
	target = $PlayerNavigationAgent.target_position
	followPlayerOrder = true
	
func retarget():
	var pathMain = get_tree().get_root().get_node("Main")
	
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

func _on_attack_range_area_2d_body_entered(body):
	if body as BadPokemon != null:
		possible_targets.append(body)

func _on_attack_range_area_2d_body_exited(body):
	if body as BadPokemon != null:
		possible_targets.erase(body)
