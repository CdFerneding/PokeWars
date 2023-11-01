extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready():
	Game.set_game_paused(true)


func _on_button_pressed():
	Game.set_game_paused(false)
	var musicPath = get_tree().get_root().get_node("Main/Music")
	musicPath.play()
	self.queue_free()
