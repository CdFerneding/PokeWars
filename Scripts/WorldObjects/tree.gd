extends StaticBody2D

var totalTime = 20
var currTime
# number of pikachus near resource are counted to adjust choping speed
# this is named pikachus, since military units are not able to chop resources
var pikachus = 0
@onready var bar = $ProgressBar
@onready var timer = $Timer

func _ready():
	currTime = totalTime
	bar.max_value = totalTime
	
func _process(_delta):
	if Game.is_paused:
		return
	bar.value = currTime
	# check if bush has been completely choped 
	if currTime <= 0:
		treeChopped()

func _on_chop_area_body_entered(body):
	if "Pikachu" in body.name:
		pikachus += 1
		startChopping()

func _on_chop_area_body_exited(body):
	if "Pikachu" in body.name:
		pikachus -= 1
		if pikachus <= 0:
			timer.stop()


func _on_timer_timeout():
	if Game.is_paused:
		return
	var chopSpeed = 1*pikachus
	currTime -= chopSpeed
	# tweens are used to create smoothened animations
	var tween = get_tree().create_tween()
	# tween property anmates (here bar and value to current time, 
	# this transformation will take 0.4 seconds)
	# .set_trans describes the style of the animation
	tween.tween_property(bar, "value", currTime, 0.4).set_trans(Tween.TRANS_LINEAR)

func startChopping():
	timer.start()

func treeChopped():
	Game.Wood += 4
	$Sound.play()
	# resetting ProgressBar and currentTime
	_ready()

