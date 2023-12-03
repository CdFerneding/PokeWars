extends CanvasLayer

@onready var screensize = get_viewport().size

# Called when the node enters the scene tree for the first time.
func _ready():
	$StartGame.show()
	$StartGameWithoutSpeeches.show()
	Game.set_game_paused(true)
	$Background.set_size(screensize)
	$Background.show()
	$loosingBackground.hide()
	

func _input(event):
	if Input.is_action_pressed("enter"):
		_on_start_game_pressed()


func _on_start_game_pressed():
	var mainPath = get_tree().get_root().get_node("Main")
	mainPath.on_start_game()
	self.queue_free()

func _on_start_game_without_speeches_pressed():
	Game.skipping_speeches = true
	Game.playerName = "Bulbasaur"
	_on_start_game_pressed()

func win_game_overlay():
	Game.set_game_paused(true)
	$StartGame.hide()
	$StartGameWithoutSpeeches.hide()
	$Background.hide()
	var background = get_node("winningBackground"+Game.playerName)
	background.set_size(screensize)
	background.show()
	print_finish_dialogue()

func loose_game_overlay():
	Game.set_game_paused(true)
	$StartGame.hide()
	$StartGameWithoutSpeeches.hide()
	$Background.hide()
	$loosingBackground.set_size(screensize)
	$loosingBackground.show()
	print_finish_dialogue()
	
func print_finish_dialogue():
	if Game.skipping_speeches == false:
		var dialogueResource = preload("res://Dialogues/finish.dialogue")
		DialogueManager.show_example_dialogue_balloon(dialogueResource, "finish_game")
	else:
		var dialogueResource = preload("res://Dialogues/finish.dialogue")
		DialogueManager.show_example_dialogue_balloon(dialogueResource, "play_again")
