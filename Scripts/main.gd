extends Node

signal setUpdater(scene)

@onready var pikachuBuilder = preload("res://Scripts/Builder/UnitBuilder.gd")
@onready var unitBuilder = preload("res://Scripts/Builder/UnitBuilder.gd")
@onready var pikachu = preload("res://Scenes/pikachu.tscn")
@onready var ennemy = preload("res://Scenes/ennemy.tscn")
@export var mob_scene: PackedScene
@export var tileMap: TileMap
# @Justin "UILabel is now as a "GameMode" Label in the HUD. 
# The controlling var is in the Gloabl File Game.gd as GameMode
# you can delte this
# @export var UI: Label
var score

# storing the selected pikachu
var selected_pikachus = []
# all pikachus in the group "pikachus"
@export var pikachus = []

@export var ennemies = []

var buildings = []
#cursor
var default_cursor = preload("res://Assets/Sprites/Cursor/test_cursor_2.png")
#cursor 1 looks horrible - do not use
#var hover_cursor = preload("res://Assets/Sprites/Cursor/test_cursor_2.png")

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	new_game() # Replace with function body.
	
	#set cursor to default
	Input.set_custom_mouse_cursor(default_cursor, Input.CURSOR_ARROW, Vector2(5,0))
	#pikachuBuilder._build_pikachu(self,self.find_child("TileMap"),start_position)
	
	get_pikachus()
	get_buildings()
	get_ennemies()
	setUpdater.emit(self)
		

func get_pikachus():
	pikachus = []
	pikachus = get_tree().get_nodes_in_group("pikachus")

func get_ennemies():
	ennemies = []
	ennemies = get_tree().get_nodes_in_group("ennemies")


func get_buildings():
	buildings = []
	buildings = get_tree().get_nodes_in_group("buildings")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
	
func new_game():
	score = 0
	$Music.play()
	# $Pikachu.start($StartPosition.position)

'
first checks if button pressed for a change in gamemode
and then depending on what is the current gamemode goes to
the correlating _handle_input function
'
func _input(_event):
	_change_gamemode()
	_handle_esc()
	if Game.GameMode == "play":
		_handle_play_input(_event)
		
	elif Game.GameMode == "build" && Game.buildCounter < 3:
		_handle_building_input(_event)
		
	elif Game.GameMode == "place":
		_handle_place_input(_event)


# connected through funciton in pikachu._ready()
func _on_pikachu_clicked(object: CharacterBody2D):
	selected_pikachus.append(object)
	
'
different input functions get called depending on what 
the current gamemode is

building is for when you want to build a building
you can select different types of buildings and build them
'
func _handle_building_input(event):

	if Input.is_action_just_pressed("1"):
		Game.selectedBuilding = "PokeCenter"
	elif Input.is_action_just_pressed("2"):
		Game.selectedBuilding = "FireBuilding"
	elif Input.is_action_just_pressed("3"):
		Game.selectedBuilding = "PlantBuilding"
	elif Input.is_action_just_pressed("4"):
		Game.selectedBuilding = "WaterBuilding"
			
	elif Input.is_action_just_pressed("left_click"):
		var y_position = floor(tileMap.get_global_mouse_position().y/16)
		var x_position = floor(tileMap.get_global_mouse_position().x/16)
		var tile_position = Vector2(x_position,y_position)
		var selected = Game.selectedBuilding
		match selected:
			"PokeCenter":
				tileMap._place_building(tile_position,4,3,2)
			"FireBuilding":
				tileMap._place_building(tile_position,4,4,3)
			"PlantBuilding":
				tileMap._place_building(tile_position,4,4,4)
			"WaterBuilding":
				tileMap._place_building(tile_position,4,4,5)


'
play_input handles the main gamemode, where you can select and deselect
units and move them around.

found a small bug if it is not fixed yet where you can select the same
pikachu multiple times and increases selected count
'


func _handle_esc():
	if Input.is_action_pressed("Esc"):
		var childrenHUD = $HUD.get_children()
		for child in childrenHUD:
			if "Menu" in child.name:
				return
		var menu = preload("res://Scenes/menu.tscn")
		var pathHUD = get_tree().get_root().get_node("Main/HUD")
		var menuOverlay = menu.instantiate()
		Game.set_game_paused(true)
		pathHUD.add_child(menuOverlay)


func _handle_play_input(event):
	#_add_new_pikachu(event)
	var no_pikachus_selected = true
	# this check needs to check for "release". Otherwise when placing new pikachus they get instantly selected
	if Input.is_action_just_released("left_click"):
		for p in pikachus:
			if p.pik_hover:
				if p not in selected_pikachus:
					selected_pikachus.append(p)
				Game.Selected = selected_pikachus.size()
				no_pikachus_selected = false
		if no_pikachus_selected:
			selected_pikachus = []
			Game.Selected = selected_pikachus.size()
			
	if Input.is_action_just_pressed("right_click"):
		for p in selected_pikachus:
			p.make_path()

'
only for debugging to place units manually
'
func _handle_place_input(event):
	if Input.is_action_just_pressed("left_click"):
		var position = tileMap.get_global_mouse_position()
		unitBuilder._build_unit(self, pikachu,position,0)

'
change gamemode depending on different button presses
'
func _change_gamemode():
	if Input.is_action_pressed("B"):
		Game.GameMode = "build"
	if Input.is_action_pressed("R"):
		Game.GameMode = "play"
	if Input.is_action_pressed("P"):
		Game.GameMode = "place"


func _on_ennemy_spawner_timer_timeout():
	var ennemyPath = get_tree().get_root().get_node("Main/Ennemies")
	var mainPath = get_tree().get_root().get_node("Main")
	
	var new_ennemy = ennemy.instantiate()
	new_ennemy.position.x = rng.randf_range(20, 200)
	new_ennemy.position.y = rng.randf_range(20, 200)
	ennemyPath.add_child(new_ennemy)
	connect("setUpdater", Callable(new_ennemy, "_on_main_set_updater"))
	# pikachus need the name Pikachu, to be recognized by resources farming-area
	new_ennemy.name = "Bad Pokachu"
	setUpdater.emit(self)

	# recall to have all pikachus from the "pikachus"-group in "pikachus"-variable again
	mainPath.get_ennemies()
	
	
#		var x_position = round(event)
#		var y_position = round(event.position.y/3)
#		var position = Vector2(100,100)
#		pikachuBuilder._build_pikachu(self,self.find_child("TileMap"),position)
