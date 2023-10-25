extends Pokemon

class_name GoodPokemon

# pikachu highlighting 
@export var selected = false
@onready var box = get_node("Selected")


func _ready():
	set_selected(selected)
	

func _physics_process(delta):
	pass

func set_selected(value):
	selected = value
	box.visible = value
