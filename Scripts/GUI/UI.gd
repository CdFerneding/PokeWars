extends CanvasLayer

@onready var FoodLabel = $GameStateBox/VBoxContainer/Food
@onready var WoodLabel = $GameStateBox/VBoxContainer/Wood
@onready var StoneLabel = $GameStateBox/VBoxContainer/Stone
@onready var GameTimerLabel = $GameStateBox/VBoxContainer/GameTimer
@onready var GameModeLabel = $GameStateBox/VBoxContainer/GameMode
@onready var GameModeBuilding = $GameStateBox/VBoxContainer/CurrentBuilding
@onready var SelectedLabel = $GameStateBox/VBoxContainer/Selected # (numbers of currently selected pikachus)
@onready var pikachuIcon = preload("res://Assets/Potraits/pikachu_and_evolutions/pikachu Angry.png")

var time = 0
var currentBuilding

func _ready():
	$GameStateBox.visible = true
	$BuildingButtonBox.visible = true
	$TrainBox.visible = true
	$UpgradeMilitary.hide()
	checkGameMode()

func update_game_timer():
	var minutes
	var hours
	var time_formatted = ""
	if time > 3600:
		hours = time / 3600
		time_formatted += str(hours)+"h "
	if time > 60:
		minutes = (time / 60) % 60
		time_formatted += str(minutes)+"m "
	
	time_formatted += str(time % 60)+"s"
	GameTimerLabel.text = "Time: " + str(time_formatted)


func _on_timer_timeout():
	time+=1
	update_game_timer()

func _process(_delta):
	if Game.is_paused:
		$Timer.paused = true
		return
	
	$Timer.paused = false
	
	FoodLabel.text = "Food: " + str(Game.Food)
	WoodLabel.text = "Wood: " + str(Game.Wood)
	StoneLabel.text = "Stone: " + str(Game.Stone)
	GameModeLabel.text = "Mode: " + Game.GameMode
	SelectedLabel.text = "Selected: " + str(Game.Selected)
	GameModeBuilding.text = "Building: \n" + Game.selectedBuilding
	checkGameMode()
	


func _on_fire_arena_pressed():
	if Game.GameMode == "select":
		Game.GameMode = "build"
		Game.selectedBuilding = "Fire Arena"


func _on_water_arena_pressed():
	if Game.GameMode == "select":
		Game.GameMode = "build"
		Game.selectedBuilding = "Water Arena"

func _on_plant_arena_pressed():
	if Game.GameMode == "select":
		Game.GameMode = "build"
		Game.selectedBuilding = "Plant Arena"


func _on_delete_button_pressed():
	if Game.GameMode == "select":
		Game.selectedBuilding = "delete"

func checkGameMode():
	if Game.GameMode == "play":
		$BuildingButtonBox.hide()
		$GameStateBox/VBoxContainer/CurrentBuilding.hide()
	elif Game.GameMode == "select":
		$BuildingButtonBox.show()
		$GameStateBox/VBoxContainer/CurrentBuilding.show()
	elif Game.GameMode =="build":
		$BuildingButtonBox.hide()
		$GameStateBox/VBoxContainer/CurrentBuilding.show()


func show_training_button():
	var button = $TrainBox/TrainUnitButton
	if("PokeCenter" in currentBuilding.name):
		button.icon = pikachuIcon
	
	$TrainBox.show()



func _on_train_unit_button_pressed():
	currentBuilding.train_unit()


func _on_train_box_mouse_entered():
	Game.UIHover = true


func _on_train_box_mouse_exited():
	Game.UIHover = false

####################################################################
########## buttons that can be called in the "Laboratory" ##########
####################################################################
func show_upgrade_military():
	$UpgradeMilitary.show()
	print("upgrade military ui is visible")


func _on_upgrade_to_wartortle_pressed():
	if Game.
	$UpgradeMilitary/timerWartortle.start()


func _on_upgrade_to_blastoise_pressed():
	$UpgradeMilitary/timerBlastoise.start()


func _on_upgrade_to_charmeleon_pressed():
	$UpgradeMilitary/timerCharmeleon.start()


func _on_upgrade_to_charizard_pressed():
	$UpgradeMilitary/timerCharizard.start()


func _on_upgrade_to_ivysaur_pressed():
	$UpgradeMilitary/timerIvysaur.start()


func _on_upgrade_to_venusaur_pressed():
	$UpgradeMilitary/timerVenusaur.start()


func _on_upgrade_military_mouse_entered():
	Game.UIHover = true


func _on_upgrade_military_mouse_exited():
	Game.UIHover = false



func _on_timer_wartortle_timeout():
	pass # Replace with function body.


func _on_timer_blastoise_timeout():
	pass # Replace with function body.


func _on_timer_charmeleon_timeout():
	pass # Replace with function body.


func _on_timer_charizard_timeout():
	pass # Replace with function body.


func _on_timer_ivysaur_timeout():
	pass # Replace with function body.


func _on_timer_venusaur_timeout():
	pass # Replace with function body.
