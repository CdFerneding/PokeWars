extends StaticBody2D

var totalTime = 10
var currTime
# number of pikachus near resource are counted to adjust farming speed
var pikachus = 0
@onready var bar = $ProgressBar
@onready var timer = $Timer

func _ready():
	currTime = totalTime
	bar.max_value = totalTime
	
func _process(delta):
	bar.value = currTime
	# check if bush has been completely farmed 
	if currTime <= 0:
		bushFarmed()

func _on_farm_area_body_entered(body):
	if "Pikachu" in body.name:
		pikachus += 1
		startFarming()

func _on_farm_area_body_exited(body):
	if "Pikachu" in body.name:
		pikachus -= 1
		if pikachus <= 0:
			timer.stop()


func _on_timer_timeout():
	var farmSpeed = 1*pikachus
	currTime -= farmSpeed
	# tweens are used to create smoothened animations
	var tween = get_tree().create_tween()
	# tween property anmates (here bar and value to current time, 
	# this transformation will take 0.4 seconds)
	# .set_trans describes the style of the animation
	tween.tween_property(bar, "value", currTime, 0.4).set_trans(Tween.TRANS_LINEAR)

func startFarming():
	timer.start()

func bushFarmed():
	Game.Food += 2
	# resetting ProgressBar and currentTime
	_ready()

