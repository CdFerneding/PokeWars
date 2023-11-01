extends CanvasLayer

@onready var FoodLabel = $VBoxContainer/Food
@onready var WoodLabel = $VBoxContainer/Wood
@onready var StoneLabel = $VBoxContainer/Stone
@onready var GameTimerLabel = $VBoxContainer/GameTimer
@onready var GameModeLabel = $VBoxContainer/GameMode
@onready var SelectedLabel = $VBoxContainer/Selected # (numbers of currently selected pikachus)

var time = 0

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
	GameTimerLabel.text = "Time : " + str(time_formatted)


func _on_timer_timeout():
	time+=1
	update_game_timer()



func _process(_delta):
	FoodLabel.text = "Food: " + str(Game.Food)
	WoodLabel.text = "Wood: " + str(Game.Wood)
	StoneLabel.text = "Stone: " + str(Game.Stone)
	GameModeLabel.text = "Mode: " + Game.GameMode
	SelectedLabel.text = "Selected: " + str(Game.Selected)
	


func _on_fire_arena_pressed():
	if Game.GameMode == "play":
		Game.GameMode = "build"
		Game.selectedBuilding = "FireBuilding"


func _on_water_arena_pressed():
	if Game.GameMode == "play":
		Game.GameMode = "build"
		Game.selectedBuilding = "WaterBuilding"

func _on_plant_arena_pressed():
	if Game.GameMode == "play":
		Game.GameMode = "build"
		Game.selectedBuilding = "PlantBuilding"


func _on_delete_button_pressed():
	if Game.GameMode == "play":
		Game.GameMode = "delete"

