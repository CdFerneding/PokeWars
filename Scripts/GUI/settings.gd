extends CanvasLayer

func _ready():
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), 0)

func _on_h_slider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)


func _input(event):
	if Input.is_action_just_pressed("Esc"):
		_on_exit_pressed()


func _on_exit_pressed():
	var pathui = get_tree().get_root().get_node("Main/UI")
	pathui.set_timer_state(true)
	self.queue_free()
