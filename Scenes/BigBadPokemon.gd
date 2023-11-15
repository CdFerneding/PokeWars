extends BadPokemon

var num_of_enemies = 3

var rng = RandomNumberGenerator.new()

func _ready():
	
	super()
	speed = 0
	
func _process(delta):
	pass

func _on_enemy_spawner_timer_timeout():
	
	var mainPath = get_tree().get_root().get_node("Main")
	var enemyPath = get_tree().get_root().get_node("Main/Enemies")

	if enemyPath.get_child_count() >= num_of_enemies:
		return
	
	var new_enemy = mainPath.enemy.instantiate()
	new_enemy.position.x = 1591 + rng.randf_range(-20, 20)
	new_enemy.position.y = 143 + rng.randf_range(-20, 20)
	enemyPath.add_child(new_enemy)
	# pikachus need the name Pikachu, to be recognized by resources farming-area
	new_enemy.name = "Bad Pokachu"

	# recall to have all pokachus from the "pokachus"-group in "pokachus"-variable again
	mainPath.get_enemies()


