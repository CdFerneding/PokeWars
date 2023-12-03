extends Control

var building: Node = null

var currentTime
var totalTime = 10
var timer
var evolution = 0
@onready var selfId = self.get_instance_id()
@export var type = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	if type == "Pikachu":
		Game.pikachuQueue.append(selfId)
	elif type == "Charmander" or type == "Charmeleon" or type == "Charizard":
		Game.fireQueue.append(selfId)
	elif type == "Bulbasaur" or type == "Ivysaur" or type == "Venusaur":
		Game.plantQueue.append(selfId)
	elif type == "Squirtle" or type == "Wartortle" or type == "Blastoise":
		Game.waterQueue.append(selfId)
	
	
	currentTime = 0
	$ProgressBar.max_value = totalTime
	timer = $Timer
	$Timer.start()
	check_timer()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	check_timer()

func check_timer():
	if type == "Pikachu" and not Game.pikachuQueue.is_empty():
		$Timer.paused = not (Game.pikachuQueue.front() == selfId)
	elif (type == "Charmander" or type == "Charmeleon" or type == "Charizard") and not Game.fireQueue.is_empty():
		$Timer.paused = not (Game.fireQueue.front() == selfId)
	elif (type == "Bulbasaur" or type == "Ivysaur" or type == "Venusaur") and not Game.plantQueue.is_empty():
		$Timer.paused = not (Game.plantQueue.front() == selfId)
	elif (type == "Squirtle" or type == "Wartortle" or type == "Blastoise")  and not Game.waterQueue.is_empty():
		$Timer.paused = not (Game.waterQueue.front() == selfId)

func _on_progress_bar_value_changed(value):
	var prog = $ProgressBar
	if prog.value == prog.max_value:
		if building != null:
			building.training_finished(evolution)

		# clear queue item after the timer has run out
		if type == "Pikachu":
			Game.pikachuQueue.pop_front()
		elif type == "Charmander" or type == "Charmeleon" or type == "Charizard":
			Game.fireQueue.pop_front()
		elif type == "Bulbasaur" or type == "Ivysaur" or type == "Venusaur":
			Game.plantQueue.pop_front()
		elif type == "Squirtle" or type == "Wartortle" or type == "Blastoise":
			Game.waterQueue.pop_front()

		# level the unit timer up if the icon was an upgrade
		if type == "UpgradeToWartortle":
			Game.waterUnitLvl = 1
		elif type == "UpgradeToBlastoise":
			Game.waterUnitLvl = 2
		elif type == "UpgradeToCharmeleon":
			Game.fireUnitLvl = 1
		elif type == "UpgradeToCharizard":
			Game.fireUnitLvl = 2
		elif type == "UpgradeToIvysaur":
			Game.plantUnitLvl = 1
		elif type == "UpgradeToVenusaur":
			Game.plantUnitLvl = 2
		
		self.queue_free()

func _on_timer_timeout():
	if Game.is_paused:
		return
	currentTime += 1
	$ProgressBar.value += 1
	if currentTime < totalTime:
		timer.start()
