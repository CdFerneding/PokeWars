extends CanvasLayer

@onready var settings = preload("res://Scenes/settings.tscn")


func _on_settings_button_pressed():
	print("settings pressed")
	var pathHUD = get_tree().get_root().get_node("Main/HUD")
	var settingsOverlay = settings.instantiate()
	pathHUD.add_child(settingsOverlay)
	self.queue_free()
