extends CanvasLayer

func _ready():
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), 0)

func _on_h_slider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)


func _on_exit_pressed():
	Game.set_game_paused(false)
	self.queue_free()
