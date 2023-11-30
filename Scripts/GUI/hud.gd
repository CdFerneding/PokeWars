extends CanvasLayer

@onready var screensize = get_viewport().size

# Called when the node enters the scene tree for the first time.
func _ready():
	$StartGame.visible = true
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

func win_game_overlay():
	Game.set_game_paused(true)
	$StartGame.hide()
	$Background.hide()
	var background = get_node("winningBackground"+Game.playerName)
	background.set_size(screensize)
	background.show()
	print_finish_dialogue()

func loose_game_overlay():
	Game.set_game_paused(true)
	$StartGame.hide()
	$Background.hide()
	$loosingBackground.set_size(screensize)
	$loosingBackground.show()
	print_finish_dialogue()
	
func print_finish_dialogue():
	var dialogueResource = preload("res://Dialogues/finish.dialogue")
	await DialogueManager.show_example_dialogue_balloon(dialogueResource, "finish_game")
	
