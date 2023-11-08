extends Pokemon

class_name BadPokemon

# pikachu highlighting 
@export var selected = false
@onready var box = $Selected

# Called when the node enters the scene tree for the first time.
func _ready():
	selected = false
	set_selected(selected)
	super()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func set_selected(value):
	selected = value
	box.visible = value
