extends CharacterBody2D

class_name Pokemon

#every pokemon has a speed, and makes use of the navigation agent.
#that is why every pokemon needs a target
#furthermore, every pokemon has a progress health_bar
#the health_bar needs to be added to the inheriting child (the specific pokemon itself)
#since inheritance can be tricky in scenes but the variables are defined here

#speed of moving Pikatchu
var speed = 25

#used to detect when path is reached
var target : Vector2

enum PokemonType {NEUTRAL, FIRE, WATER, GRASS, ELECTRICITY}

@export var type : PokemonType

@onready var health_bar = $HealthBar

@export var max_health: int = 20

func _ready():
	health_bar.max_value = max_health
	health_bar.value = max_health

func _physics_process(delta):
	pass

func calculateDamage(damage : int, attackType : PokemonType):
	match attackType:
		PokemonType.FIRE:
			if type == PokemonType.WATER or type == PokemonType.FIRE:
				damage /= 2
			elif type == PokemonType.GRASS:
				damage *= 2
		PokemonType.WATER:
			if type == PokemonType.GRASS or type == PokemonType.WATER:
				damage /= 2
			elif type == PokemonType.FIRE:
				damage *= 2
		PokemonType.GRASS:
			if type == PokemonType.FIRE or type == PokemonType.GRASS:
				damage /= 2
			elif type == PokemonType.WATER:
				damage *= 2
		PokemonType.ELECTRICITY:
			if type == PokemonType.GRASS or type == PokemonType.ELECTRICITY:
				damage /= 2
			elif type == PokemonType.WATER:
				damage *= 2
	return damage
