extends Control

var building: Node

var currentTime
var totalTime = 10
var timer


# Called when the node enters the scene tree for the first time.
func _ready():
	currentTime = 0
	timer = $Timer
	timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_progress_bar_value_changed(value):
	var prog = $ProgressBar
	if prog.value == prog.max_value:
		building.training_finished()
		self.queue_free()


func _on_timer_timeout():
	currentTime += 1
	$ProgressBar.value += 1
	if currentTime < totalTime:
		timer.start()
