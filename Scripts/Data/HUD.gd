extends CanvasLayer

@onready var FoodLabel = $Food
@onready var WoodLabel = $Wood
@onready var StoneLabel = $Stone
@onready var GameTimerLabel = $GameTimer
@onready var GameModeLabel = $GameMode
@onready var SelectedLabel = $Selected # (numbers of currently selected pikachus)

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
#	var size = get_viewport().size
#	$TextureRect.size.x = size.x
#	offset.y = size.y - $HUDMainSeparation/PlayerMenu.size.y
	FoodLabel.text = "Food: " + str(Game.Food)
	WoodLabel.text = "Wood: " + str(Game.Wood)
	StoneLabel.text = "Stone: " + str(Game.Stone)
	GameModeLabel.text = "Mode: " + Game.GameMode
	SelectedLabel.text = "Selected: " + str(Game.Selected)
	
