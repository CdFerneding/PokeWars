extends Control

var building: Node = null

var currentTime
var totalTime = 10
var timer
@export var type = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	currentTime = 0
	timer = $Timer
	timer.start()
	$ProgressBar.max_value = totalTime


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_progress_bar_value_changed(value):
	var prog = $ProgressBar
	if prog.value == prog.max_value:
		if building != null:
			building.training_finished()
			# level the unit timer up if the icon was an upgrade
		if type == "Wartortle":
			Game.waterUnitLvl = 1
		elif type == "Blastoise":
			Game.waterUnitLvl = 2
		elif type == "Charmeleon":
			Game.fireUnitLvl = 1
		elif type == "Charizard":
			Game.fireUnitLvl = 2
		elif type == "Ivysaur":
			Game.plantUnitLvl = 1
		elif type == "Venusaur":
			Game.plantUnitLvl = 2
		else:
			pass
		self.queue_free()


func _on_timer_timeout():
	if Game.is_paused:
		return
	currentTime += 1
	$ProgressBar.value += 1
	if currentTime < totalTime:
		timer.start()
	
