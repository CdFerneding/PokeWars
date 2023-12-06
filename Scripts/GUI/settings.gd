extends CanvasLayer

var music = AudioServer.get_bus_index("Master")

func _on_h_slider_value_changed(value):
	AudioServer.set_bus_volume_db(music , linear_to_db(value))


func _input(event):
	if Input.is_action_just_pressed("Esc"):
		_on_exit_pressed()


func _on_exit_pressed():
	var pathui = get_tree().get_root().get_node("Main/UI")
	Game.set_game_paused(false)
	self.queue_free()
