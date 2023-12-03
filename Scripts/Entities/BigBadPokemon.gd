extends BadPokemon

class_name BigBadPokemon

signal ennemy_killed

var list_pokemon_in_area: Array[Node]

var rng = RandomNumberGenerator.new()

var animatedSprite

var current_group = ""

# load different enemy scenes (children of legendary pokemon)
@onready var waltos_child = preload("res://Scenes/pokemon/waltos_child.tscn")
@onready var plantos_child = preload("res://Scenes/pokemon/plantos_child.tscn")
@onready var moltres_child = preload("res://Scenes/pokemon/moltres_child.tscn")

var iteration1 = 1
var iteration2 = 1
var iteration3 = 1

@export var current_x_spawn_location : int
@export var current_y_spawn_location : int

func _ready():
	assign_sprite()
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
	
func assign_sprite():
	if self.name == "Moltres":
		animatedSprite = $Moltres
	elif self.name == "Plantos":
		animatedSprite = $Plantos
		animatedSprite.modulate = Color(0, 0.8, 0)
	else:
		animatedSprite = $Waltos
	
func _process(delta):
	if Game.is_paused:
		return
	

func _on_enemy_spawner_timer_timeout():
	var mainPath = get_tree().get_root().get_node("Main")

	if Game.is_paused == true or (mainPath.enemiesCanSpawn == false) or Game.POP_CAP_HOSTILE < Game.hostileUnits:
		return
	
	if current_group == "arena1":
		spawn_enemies(1 + iteration1)
		iteration1 = iteration1 + 1
	elif current_group == "arena2":
		spawn_enemies(2 + iteration2)
		iteration2 = iteration2 + 1
	elif current_group == "arena3":
		spawn_enemies(3 + iteration3 * 2)
		iteration3 = iteration3 + 1
	
func _on_ennemy_killed():
	# decrease hostile unit counter 
	Game.hostileUnits -= 1
	
func spawn_enemies(number) -> void:
	
	var mainPath = get_tree().get_root().get_node("Main")
	var new_enemy
	var enemyPath = get_tree().get_root().get_node("Main/Enemies/"+current_group)
	
	if enemyPath.get_child_count() > Game.POP_CAP_HOSTILE:
		return
	
	for i in range(1, number):
		
		# increment hostile unit counter 
		Game.hostileUnits += 1
		
		if self.name == "Moltres":
			new_enemy = moltres_child.instantiate()
		elif self.name == "Plantos":
			new_enemy = plantos_child.instantiate()
		else:
			new_enemy = waltos_child.instantiate()
		
		new_enemy.position.x = current_x_spawn_location + rng.randf_range(-40, 40)
		new_enemy.position.y = current_y_spawn_location + rng.randf_range(-40, 40)
		enemyPath.add_child(new_enemy)
		# pikachus need the name Pikachu, to be recognized by resources farming-area
		new_enemy.name = "Bad Pokachu"
	
		new_enemy.arena = self

		# recall to have all pokachus from the "pokachus"-group in "pokachus"-variable again
		mainPath.get_enemies()

func _on_hit(damage, type):
	var pathMain = get_tree().get_root().get_node("Main")
	damage = calculateDamage(damage, type)
	health_bar.value -= damage
	if health_bar.value == 0:
		pathMain.enemies.erase(self)
		self.queue_free()
		pathMain.get_units()
