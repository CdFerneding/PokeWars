extends CanvasLayer

var screensize = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	Game.set_game_paused(true)


func _process(delta):
	screensize = get_viewport().size
	$Background.set_size(screensize)


func _on_start_game_pressed():
	Game.set_game_paused(false)
	self.queue_free()
