extends Pokemon

class_name GoodPokemon

#good pokemon can be selected and need a selected box
#box has to be added to inheriting pokemon scene since scene inheritance can be tricky
#but variables are defined here
#
#
# pikachu highlighting 
@export var selected = false
@onready var box = get_node("Selected")
var pok_hover: bool = false

func _ready():
	#box = get_node("Selected")
	set_selected(selected)
	super()
	
	

func _physics_process(delta):
	pass

func set_selected(value):
	selected = value
	box.visible = value
