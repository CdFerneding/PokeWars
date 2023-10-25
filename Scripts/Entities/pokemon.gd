extends CharacterBody2D

class_name Pokemon

#every pokemon has a speed, and makes use of the navigation agent.
#that is why every pokemon needs a target
#furthermore, every pokemon has a progress bar
#the bar needs to be added to the inheriting child (the specific pokemon itself)
#since inheritance can be tricky in scenes but the variables are defined here

#speed of moving Pikatchu
const speed = 25

#used to detect when path is reached
var target : Vector2

@onready var bar = $ProgressBar

func _ready():
	bar.max_value = 20
	bar.value = 20

func _physics_process(delta):
	pass
