extends StaticBody2D

var buildingHover = false

@onready var main = get_tree().get_root().get_node("Main")
@onready var UI = get_tree().get_root().get_node("Main/UI")

var currently_training = false

var tileId:int
var maxHealth = 200
var currentHealth

@onready var bar = $HealthBar


# Called when the node enters the scene tree for the first time.
func _ready():
	bar.max_value = maxHealth
	currentHealth = maxHealth

func _on_hit(dmg):
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Selected.visible = buildingHover
	bar.value = currentHealth

'
Input managment functions
'
func _on_mouse_entered():
	if Game.is_paused:
		return
	buildingHover = true

func _on_mouse_exited():
	if Game.is_paused:
		return
	buildingHover = false

func _input(event):
	if Game.is_paused:
		return
	if buildingHover:
		if Game.selectedBuilding == "delete":
			_delete_building(event)
		elif Input.is_action_just_released("left_click"):
			UI.show_upgrade_military(true)

func _delete_building(event):
	if Input.is_action_just_pressed("left_click") && !currently_training && self.name != "PokeCenter":
		var tileMap = get_tree().get_root().get_node("Main/TileMap")
		tileMap._delete_building(self.position, tileId)
		Game.buildCounter -= 1
		self.queue_free()

func _show_upgrade_UI():
	UI.currentBuilding = self
	UI.get_node("UpgradeMilitary").show()

