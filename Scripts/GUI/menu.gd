extends CanvasLayer

@onready var settings = preload("res://Scenes/GUI/settings.tscn")


func _on_settings_button_pressed():
	var pathHUD = get_tree().get_root().get_node("Main/UI")
	var settingsOverlay = settings.instantiate()
	pathHUD.add_child(settingsOverlay)
	self.queue_free()


func _input(event):
	if Input.is_action_just_pressed("Esc"):
		_on_exit_pressed()


func _on_quit_game_button_pressed():
	Game.exit_game()


func _on_exit_pressed():
	Game.set_game_paused(false)
	var pathui = get_tree().get_root().get_node("Main/UI")
	self.queue_free()
