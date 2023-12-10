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

@onready var animationSprite;

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


func apply_corresponding_animation():
	var current_animation
	
	# calculate the degrees of the walking direction
	var current_velocity = velocity
	var radians = current_velocity.angle()
	var degrees = radians * 180 * 0.32 # equals 180 / PI but is more efficient
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
	
