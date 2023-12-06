extends BadPokemon

class_name enemy

#@export var main: Node
#@export var main: Node
var enemy_hover = false

# this is the position that the enemy will attack when all pikachus are dead
# initializing home_base position
var pathTilemap = Game.get_tree().get_root().get_node("Main/TileMap")
var home_base = pathTilemap.home_base

@export var possible_targets = []
@export var nearest_target: CharacterBody2D

@export var arena : Node = null

var current_target: Node
var is_fighting = false

@export var attack_damage = 5

#implements the pathfinding algorithm
@onready var nav_agent:= $NavigationAgent2D #as NavigationAgent2D

func _ready():
	assign_sprite()
	
	# make the enemies significantly slower than economy pokemon
	speed = 18
	
	animationSprite.animation = "walk_down"
	$AttackCooldown.start()
	#var main_node = get_tree().get_root().get_node("Main")
	
	super()

# assign the child based on the scene name (alls enemy children have the same script)
func assign_sprite():
	if self.name == "WaltosChild":
		animationSprite = $waltos
		type = PokemonType.WATER
	elif self.name == "PlantosChild":
		type = PokemonType.GRASS
		animationSprite = $plantos
		animationSprite.modulate = Color(0, 1, 0)
	else:
		type = PokemonType.ELECTRICITY
		animationSprite = $moltres

func _process(_delta:float):
	if Game.is_paused == true:
		return
	enemy_scale_on_hover()
	
#	var main_path = get_tree().get_root().get_node("Main")
#	var all_pokemon = main_path.get_all_units()
#	if all_pokemon.position.distance_to(position) < 15:
#		is_fighting = true
#	else:
#		is_fighting = false
		
func attack():
	(current_target as GoodPokemon)._on_hit(attack_damage, type)
	$AttackCooldown.start()
	
func _physics_process(_delta: float) -> void:
#	var prev_vel = velocity
	if self.position == target || current_target == null || Game.is_paused:
		return
	
	var next_pos = nav_agent.get_next_path_position()
	if next_pos == Vector2.ZERO:
		return
	var dir = to_local(next_pos).normalized()
	velocity = dir * speed
	
	if current_target!= null and position.distance_to(current_target.position) < 10:
		velocity = Vector2.ZERO
		if $AttackCooldown.is_stopped():
			attack()
	
	if !is_fighting:
		apply_corresponding_animation()
	
	move_and_slide()
	
# added is_farming = false to cancel farming when a new destination is issued for pikachu
func make_path(ressource_position = get_global_mouse_position()) -> void:
	nav_agent.target_position = nearest_target.position
	target = nav_agent.target_position

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
		pathMain.get_friendly_units()


func _on_area_2d_area_entered(area):
	is_fighting = true


func _on_area_2d_area_exited(area):
	is_fighting = false
