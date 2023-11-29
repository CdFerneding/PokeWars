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
timer functions
'
func _start_training():
	var scene = load("res://Scenes/GUI/Trainicon.tscn")
	var queueItem = scene.instantiate()
	queueItem.get_node("UnitIcon").texture = check_current_pokemon()
	queueItem.building = self
	UI.get_node("TrainingQueue").add_child(queueItem)


'
Input managment functions
'
func _on_mouse_entered():
	if Game.is_paused:
		return
	buildingHover = true
	print(buildingHover)

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
			UI.show_upgrade_military()

func _delete_building(event):
	if Input.is_action_just_pressed("left_click") && !currently_training && self.name != "PokeCenter":
		var tileMap = get_tree().get_root().get_node("Main/TileMap")
		tileMap._delete_building(self.position, tileId)
		Game.buildCounter -= 1
		self.queue_free()

func _show_upgrade_UI():
	UI.currentBuilding = self
	UI.get_node("UpgradeMilitary").show()
	
func check_current_pokemon():
	if "PokeCenter" in self.name:
		return load(Game.pikachuIcon)
	if "Fire Arena" in self.name:
			return load(Game.CharmanderIcon)
	if "Water Arena" in self.name:
			return load(Game.SquirleIcon)
	if "Plant Arena" in self.name:
			return load(Game.BulbasaurIcon)
