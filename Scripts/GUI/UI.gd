extends CanvasLayer

@onready var FoodLabel = $GameStateBox/VBoxContainer/Food
@onready var WoodLabel = $GameStateBox/VBoxContainer/Wood
@onready var StoneLabel = $GameStateBox/VBoxContainer/Stone
@onready var GameTimerLabel = $GameStateBox/VBoxContainer/GameTimer
@onready var GameModeLabel = $GameStateBox/VBoxContainer/GameMode
@onready var GameModeBuilding = $GameStateBox/VBoxContainer/CurrentBuilding
@onready var SelectedLabel = $GameStateBox/VBoxContainer/Selected # (numbers of currently selected pikachus)

var time = 0
var currentBuilding


# variables to remember if the upgrade timers where running before the game was paused

func _ready():
	$GameStateBox.visible = true
	$BuildingButtonBox.visible = true
	$TrainBox.visible = false
	$TrainBox/TrainUnitButtonLvl2.disabled = true
	$TrainBox/TrainUnitButtonLvl3.disabled = true
	checkGameMode()

func update_game_timer():
	var minutes
	var hours
	var time_formatted = ""
	if time > 3600:
		hours = time / 3600.0
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

	if $UpgradeMilitary.is_visible():
		check_upgrade_military_buttons()
	
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
	var button1 = $TrainBox/TrainUnitButtonLvl1
	var button2 = $TrainBox/TrainUnitButtonLvl2
	var button3 = $TrainBox/TrainUnitButtonLvl3
	button2.show()
	button3.show()
	button2.disabled = true
	button3.disabled = true
	if"PokeCenter" in currentBuilding.name:
		button1.icon = load(Game.pikachuIcon)
		button2.hide()
		button3.hide()
	elif "Fire" in currentBuilding.name:
		button1.icon = load(Game.CharmanderIcon)
		button2.icon = load(Game.CharmeleonIcon)
		button3.icon = load(Game.CharizardIcon)
		_check_unlocks("Fire")
	elif "Plant" in currentBuilding.name:
		button1.icon = load(Game.BulbasaurIcon)
		button2.icon = load(Game.IvysaurIcon)
		button3.icon = load(Game.VenusaurIcon)
		_check_unlocks("Plant")
	elif "Water" in currentBuilding.name:
		button1.icon = load(Game.SquirleIcon)
		button2.icon = load(Game.WartortleIcon)
		button3.icon = load(Game.BlastoiseIcon)
		_check_unlocks("Water")
	
	$TrainBox.show()
	$UpgradeMilitary.hide()
	$BuildingButtonBox.hide()

func _check_unlocks(name):
	match name:
		"Fire":
			match Game.fireUnitLvl:
				1:
					$TrainBox/TrainUnitButtonLvl2.disabled = false
				2:
					$TrainBox/TrainUnitButtonLvl2.disabled = false
					$TrainBox/TrainUnitButtonLvl3.disabled = false
		"Water":
			match Game.waterUnitLvl:
				1:
					$TrainBox/TrainUnitButtonLvl2.disabled = false
				2:
					$TrainBox/TrainUnitButtonLvl2.disabled = false
					$TrainBox/TrainUnitButtonLvl3.disabled = false
		"Plant":
			match Game.plantUnitLvl:
				1:
					$TrainBox/TrainUnitButtonLvl2.disabled = false
				2:
					$TrainBox/TrainUnitButtonLvl2.disabled = false
					$TrainBox/TrainUnitButtonLvl3.disabled = false



func _on_train_box_mouse_entered():
	Game.UIHover = true

func _on_train_box_mouse_exited():
	Game.UIHover = false

func _input(event):
	if Input.is_action_just_pressed("left_click") && Game.UIHover == false:
		show_upgrade_military(false)
	if $UpgradeMilitary.is_visible():
		_manage_upgrade_inputs()
	elif $TrainBox.is_visible():
		_manage_train_inputs()


func _manage_upgrade_inputs():
	if Input.is_action_just_pressed("Q"):
			_on_upgrade_to_wartortle_pressed()
	elif Input.is_action_just_pressed("W"):
		_on_upgrade_to_blastoise_pressed()
	elif Input.is_action_just_pressed("E"):
		_on_upgrade_to_charmeleon_pressed()
	elif Input.is_action_just_pressed("R"):
		_on_upgrade_to_charizard_pressed()
	elif Input.is_action_just_pressed("A"):
		_on_upgrade_to_ivysaur_pressed()
	elif Input.is_action_just_pressed("S"):
		_on_upgrade_to_venusaur_pressed()
	else:
		pass


func _manage_train_inputs():
	if "PokeCenter" in currentBuilding.name:
		if Input.is_action_just_pressed("Q"):
			currentBuilding.train_unit(0)
	elif "Fire" in currentBuilding.name:
		if Input.is_action_just_pressed("Q"):
			currentBuilding.train_unit(0)
		elif Input.is_action_just_pressed("W"):
				currentBuilding.train_unit(1)
		elif Input.is_action_just_pressed("E"):
			currentBuilding.train_unit(2)
	elif "Water" in currentBuilding:
		if Input.is_action_just_pressed("Q"):
			currentBuilding.train_unit(0)
		elif Input.is_action_just_pressed("W"):
			currentBuilding.train_unit(1)
		elif Input.is_action_just_pressed("E"):
			currentBuilding.train_unit(2)
	elif "Plant" in currentBuilding:
		if Input.is_action_just_pressed("Q"):
			currentBuilding.train_unit(0)
		elif Input.is_action_just_pressed("W"):
			currentBuilding.train_unit(1)
		elif Input.is_action_just_pressed("E"):
			currentBuilding.train_unit(2)
	

func set_timer_state(state):
	if state:
		$Timer.paused = true
	else:
		$Timer.paused = false

####################################################################
########## buttons that can be called in the "Laboratory" ##########
####################################################################
# this could also be handled in a specific file for upgrading military
func show_upgrade_military(state):
	if state:
		$TrainBox.hide()
		$BuildingButtonBox.hide()
		$UpgradeMilitary.show()
	else: 
		$UpgradeMilitary.hide()


func _on_upgrade_to_wartortle_pressed():
	if Game.waterUnitLvl != 0 or is_upgrade_ongoing("Wartortle") or Game.Food < 20:
		return
	if (Game.plantUnitLvl > 0 or is_upgrade_ongoing("Ivysaur")) and (Game.fireUnitLvl > 0 or is_upgrade_ongoing("Charmeleon")):
		start_upgrade(150, "Wartortle")
	elif (Game.plantUnitLvl > 0 or is_upgrade_ongoing("Ivysaur")) and (Game.fireUnitLvl == 0 or is_upgrade_ongoing("Charmeleon")):
		start_upgrade(120, "Wartortle")
	elif (Game.plantUnitLvl == 0 or is_upgrade_ongoing("Ivysaur")) and (Game.fireUnitLvl > 0 or is_upgrade_ongoing("Charmeleon")):
		start_upgrade(120, "Wartortle")
	else:
		start_upgrade(90, "Wartortle")


func _on_upgrade_to_blastoise_pressed():
	if Game.waterUnitLvl != 1 or is_upgrade_ongoing("Blastoise") or Game.Food < 20:
		return
	if (Game.plantUnitLvl > 1 or is_upgrade_ongoing("Venusaur")) and (Game.fireUnitLvl > 1 or is_upgrade_ongoing("Charizard")):
		start_upgrade(210, "Blastoise")
	elif (Game.plantUnitLvl > 1 or is_upgrade_ongoing("Venusaur")) and (Game.fireUnitLvl == 1 or is_upgrade_ongoing("Charizard")):
		start_upgrade(180, "Blastoise")
	elif (Game.plantUnitLvl == 1 or is_upgrade_ongoing("Venusaur")) and (Game.fireUnitLvl > 1 or is_upgrade_ongoing("Charizard")):
		start_upgrade(180, "Blastoise")
	else:
		start_upgrade(150, "Blastoise")


func _on_upgrade_to_charmeleon_pressed():
	if Game.fireUnitLvl != 0 or is_upgrade_ongoing("Charmeleon") or Game.Food < 20:
		return
	if (Game.plantUnitLvl > 0 or is_upgrade_ongoing("Ivysaur")) and (Game.waterUnitLvl > 0 or is_upgrade_ongoing("Wartortle")):
		start_upgrade(150, "Charmeleon")
	elif (Game.plantUnitLvl > 0 or is_upgrade_ongoing("Ivysaur")) and (Game.waterUnitLvl == 0 or is_upgrade_ongoing("Wartortle")):
		start_upgrade(120, "Charmeleon")
	elif (Game.plantUnitLvl == 0 or is_upgrade_ongoing("Ivysaur")) and (Game.waterUnitLvl > 0 or is_upgrade_ongoing("Wartortle")):
		start_upgrade(120, "Charmeleon")
	else:
		start_upgrade(10, "Charmeleon")


func _on_upgrade_to_charizard_pressed():
	if Game.fireUnitLvl != 1 or is_upgrade_ongoing("Charizard") or Game.Food < 20:
		return
	if (Game.plantUnitLvl > 1 or is_upgrade_ongoing("Venusaur")) and (Game.waterUnitLvl > 1 or is_upgrade_ongoing("Blastoise")):
		start_upgrade(210, "Charizard")
	elif (Game.plantUnitLvl > 1 or is_upgrade_ongoing("Venusaur")) and (Game.waterUnitLvl == 1 or is_upgrade_ongoing("Blastoise")):
		start_upgrade(180, "Charizard")
	elif (Game.plantUnitLvl == 1 or is_upgrade_ongoing("Venusaur")) and (Game.waterUnitLvl > 1 or is_upgrade_ongoing("Blastoise")):
		start_upgrade(180, "Charizard")
	else:
		start_upgrade(150, "Charizard")


func _on_upgrade_to_ivysaur_pressed():
	if Game.plantUnitLvl != 0 or is_upgrade_ongoing("Ivysaur") or Game.Food < 20:
		return
	if (Game.fireUnitLvl > 0 or is_upgrade_ongoing("Charmeleon")) and (Game.waterUnitLvl > 0 or is_upgrade_ongoing("Wartortle")):
		start_upgrade(150, "Ivysaur")
	elif (Game.fireUnitLvl > 0 or is_upgrade_ongoing("Charmeleon")) and (Game.waterUnitLvl == 0 or is_upgrade_ongoing("Wartortle")):
		start_upgrade(120, "Ivysaur")
	elif (Game.fireUnitLvl == 0 or is_upgrade_ongoing("Charmeleon")) and (Game.waterUnitLvl > 0 or is_upgrade_ongoing("Wartortle")):
		start_upgrade(120, "Ivysaur")
	else:
		start_upgrade(90, "Ivysaur")


func _on_upgrade_to_venusaur_pressed():
	if Game.plantUnitLvl != 1 or is_upgrade_ongoing("Venusaur") or Game.Food < 20:
		return
	
	if (Game.fireUnitLvl > 1 or is_upgrade_ongoing("Charizard")) and (Game.waterUnitLvl > 1 or is_upgrade_ongoing("Blastoise")):
		start_upgrade(210, "Venusaur")
	elif (Game.fireUnitLvl > 1 or is_upgrade_ongoing("Charizard")) and (Game.waterUnitLvl == 1 or is_upgrade_ongoing("Blastoise")):
		start_upgrade(180, "Venusaur")
	elif (Game.fireUnitLvl == 1 or is_upgrade_ongoing("Charizard")) and (Game.waterUnitLvl > 1 or is_upgrade_ongoing("Blastoise")):
		start_upgrade(180, "Venusaur")
	else:
		start_upgrade(150, "Venusaur")


func start_upgrade(time, upgrade_to):
	if Game.is_paused:
		return
	var trainIconScene = load("res://Scenes/GUI/Trainicon.tscn")
	var queueItem = trainIconScene.instantiate()
	var button = get_node("UpgradeMilitary/UpgradeTo"+upgrade_to)
	queueItem.get_node("UnitIcon").texture = button.icon
	queueItem.totalTime = time
	queueItem.type = upgrade_to
	$TrainingQueue.add_child(queueItem)

func is_upgrade_ongoing(type_to_check: String) -> bool:
	for child in $TrainingQueue.get_children():
		if child.type == type_to_check:
			return true
	return false

func check_upgrade_military_buttons():
	$UpgradeMilitary/UpgradeToIvysaur.disabled = true
	$UpgradeMilitary/UpgradeToCharmeleon.disabled = true
	$UpgradeMilitary/UpgradeToWartortle.disabled = true
	$UpgradeMilitary/UpgradeToVenusaur.disabled = true
	$UpgradeMilitary/UpgradeToBlastoise.disabled = true
	$UpgradeMilitary/UpgradeToCharizard.disabled = true

	if Game.Food >= 20:
		if Game.plantUnitLvl == 0 and !is_upgrade_ongoing("Ivysaur"):
			$UpgradeMilitary/UpgradeToIvysaur.disabled = false
		
		if Game.fireUnitLvl == 0 and !is_upgrade_ongoing("Charmeleon"):
			$UpgradeMilitary/UpgradeToCharmeleon.disabled = false
		
		if Game.waterUnitLvl == 0 and !is_upgrade_ongoing("Wartortle"):
			$UpgradeMilitary/UpgradeToWartortle.disabled = false

	if Game.Food >= 40:
		if Game.plantUnitLvl == 1 and !is_upgrade_ongoing("Venusaur"):
			$UpgradeMilitary/UpgradeToVenusaur.disabled = false

		if Game.waterUnitLvl == 1 and !is_upgrade_ongoing("Blastoise"):
			$UpgradeMilitary/UpgradeToBlastoise.disabled = false

		if Game.fireUnitLvl == 1 and !is_upgrade_ongoing("Charizard"):
			$UpgradeMilitary/UpgradeToCharizard.disabled = false


func _on_win_game_pressed():
	Game.trigger_win_game()


func _on_loose_game_pressed():
	Game.trigger_loose_game()

func _on_train_unit_button_lvl_1_pressed():
	currentBuilding.train_unit(0)

func _on_train_unit_button_lvl_2_pressed():
	currentBuilding.train_unit(1)

func _on_train_unit_button_lvl_3_pressed():
	currentBuilding.train_unit(2)


