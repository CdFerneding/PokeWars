extends CanvasLayer

var screensize = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	Game.set_game_paused(true)


func _process(delta):
	screensize = get_viewport().size
	$Background.set_size(screensize)
	

func _input(event):
	if Input.is_action_pressed("enter"):
		_on_start_game_pressed()


func _on_start_game_pressed():
	var mainPath = get_tree().get_root().get_node("Main")
	mainPath.on_start_game()
	self.queue_free()
