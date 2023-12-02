extends BadPokemon

class_name BigBadPokemon

signal ennemy_killed

var num_of_enemies = 200

var list_pokemon_in_area: Array[Node]

var rng = RandomNumberGenerator.new()

@onready var animatedSprite = $AnimatedSprite2D

var current_group = ""

var iteration1 = 1
var iteration2 = 1
var iteration3 = 1

@export var current_x_spawn_location : int
@export var current_y_spawn_location : int

func _ready():
	
	super()
	speed = 0
	animatedSprite.play()
	for group in self.get_groups():
		if group.begins_with("arena") and !group.ends_with("arena"):
			current_group = group
			break
	var group = Node2D.new()
	group.name = current_group
	get_tree().get_root().get_node("Main/Enemies").add_child(group)
	
func _process(delta):
	if Game.is_paused:
		return
	

func _on_enemy_spawner_timer_timeout():
	var mainPath = get_tree().get_root().get_node("Main")
	
	if Game.is_paused == true or (mainPath.enemiesCanSpawn == false):
		return
	
	var enemyPath = get_tree().get_root().get_node("Main/Enemies/"+current_group)
	
	if enemyPath.get_child_count() >= num_of_enemies:
		return
	
	if current_group == "arena1":
		spawn_enemies(2 + iteration1)
		iteration1 = iteration1 + 1
	elif current_group == "arena2":
		spawn_enemies(5 + iteration2)
		iteration2 = iteration2 + 1
	elif current_group == "arena3":
		spawn_enemies(7 + iteration3 * 2)
		iteration3 = iteration3 + 1
	
	
func _on_ennemy_killed():
	pass
	
func spawn_enemies(number) -> void:
	var mainPath = get_tree().get_root().get_node("Main")
	var enemyPath = get_tree().get_root().get_node("Main/Enemies/"+current_group)
	
	for i in range(1, number):
		var new_enemy = mainPath.enemy.instantiate()
		new_enemy.position.x = current_x_spawn_location + rng.randf_range(-40, 40)
		new_enemy.position.y = current_y_spawn_location + rng.randf_range(-40, 40)
		enemyPath.add_child(new_enemy)
		# pikachus need the name Pikachu, to be recognized by resources farming-area
		new_enemy.name = "Bad Pokachu"
	
		new_enemy.arena = self

		# recall to have all pokachus from the "pokachus"-group in "pokachus"-variable again
		mainPath.get_enemies()

func in_range(pokemon):
	return pokemon in list_pokemon_in_area

func _on_attack_range_body_entered(body):
	list_pokemon_in_area.append(body)
	
func _on_hit(damage, type):
	var pathMain = get_tree().get_root().get_node("Main")
	damage = calculateDamage(damage, type)
	health_bar.value -= damage
	if health_bar.value == 0:
		pathMain.enemies.erase(self)
		self.queue_free()
		pathMain.get_units()
