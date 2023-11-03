extends Node

@onready var pikachuBuilder = preload("res://Scripts/Builder/UnitBuilder.gd")
@onready var unitBuilder = preload("res://Scripts/Builder/UnitBuilder.gd")
@onready var pikachu = preload("res://Scenes/pokemon/pikachu.tscn")
@onready var enemy = preload("res://Scenes/pokemon/enemy.tscn")
@export var mob_scene: PackedScene
@export var tileMap: TileMap
# @Justin "UILabel is now as a "GameMode" Label in the HUD. 
# The controlling var is in the Gloabl File Game.gd as GameMode
# you can delte this
# @export var UI: Label
var score

# storing the selected pikachu
var selected_pikachus = []
# all units in the group their groups
var charmanders = []
var bulbasaurs = []
var squirtles = []
@export var pikachus = []

@export var enemies = []

# control the number of spawning enemies:
var num_of_enemies = 3


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
	
	get_units()
	get_buildings()
	get_enemies()
		

func get_units():
	pikachu = []
	pikachus = get_tree().get_nodes_in_group("pikachus")
	charmanders = get_tree().get_nodes_in_group("Charmanders")
	bulbasaurs = get_tree().get_nodes_in_group("Bulbasaurs")
	squirtles = get_tree().get_nodes_in_group("Squirtles")

func get_enemies():
	enemies = []
	enemies = get_tree().get_nodes_in_group("enemies")

func get_pikachus():
	pikachus = get_tree().get_nodes_in_group("pikachus")

func get_buildings():
	buildings = get_tree().get_nodes_in_group("buildings")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
	
func new_game():
	score = 0
	$Music.play()
	# $Pikachu.start($StartPosition.position)

'
this is code for the drag-selection
part of it is in the camera.gd file
'
# object is the camera that is passed through to analyse the selected area
func _on_area_selected(object: Camera2D):
	var start = object.start
	var end = object.end
	var area = []
	area.append(Vector2(min(start.x, end.x), min(start.y, end.y)))
	area.append(Vector2(max(start.x, end.x), max(start.y, end.y)))
	var pk = get_pikachus_in_area(area)
	for p in pk:
		selected_pikachus.append(p)
	Game.Selected = pk.size()
#	Game.SelectedUnits = ut.size()
	# deselect all units
	for p in pikachus:
		if p == null:
			continue
		p.set_selected(false)
	# select all units in the area (of drag_selection)
	#for u in pk:
	#	u.set_selected(true)
	
		
func get_pikachus_in_area(area):
	var ps = []
	for pikachu in pikachus:
		if pikachu == null:
			continue
		if pikachu.position.x > area[0].x and pikachu.position.x < area[1].x:
			if pikachu.position.y > area[0].y and pikachu.position.y < area[1].y:
				ps.append(pikachu)
	return ps

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
#func _on_pikachu_clicked(object: CharacterBody2D):
#	selected_pikachus = []
#	selected_pikachus.append(object)
	
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
		var tile_position = tileMap.get_global_mouse_position()
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
		var childrenHUD = $UI.get_children()
		for child in childrenHUD:
			if "Menu" in child.name:
				return
		var menu = preload("res://Scenes/GUI/menu.tscn")
		var pathHUD = get_tree().get_root().get_node("Main/UI")
		var menuOverlay = menu.instantiate()
		Game.set_game_paused(true)
		pathHUD.add_child(menuOverlay)


func _handle_play_input(event):
	#_add_new_pikachu(event)
	var no_pikachus_selected = true
	# this check needs to check for "release". Otherwise when placing new pikachus they get instantly selected
	if Input.is_action_just_released("left_click"):
		for p in pikachus:
			if p == null:
				continue
			if p.pik_hover:
				selected_pikachus = []
				selected_pikachus.append(p)
				Game.Selected = selected_pikachus.size()
				no_pikachus_selected = false
		if no_pikachus_selected:
			selected_pikachus = []
			Game.Selected = selected_pikachus.size()
			
	if Input.is_action_just_pressed("right_click"):
		if selected_pikachus.size() != 0:
			for p in selected_pikachus:
				p.make_path()

'
only for debugging to place units manually
'
func _handle_place_input(event):
	if Input.is_action_just_pressed("left_click"):
		var position = tileMap.get_global_mouse_position()
		unitBuilder._build_unit(self,"Pikachu", position, 0)

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


func _on_enemy_spawner_timer_timeout():
	var enemyPath = $Enemies
	
	if $Enemies.get_child_count() >= num_of_enemies:
		return
	
	var new_enemy = enemy.instantiate()
	new_enemy.position.x = rng.randf_range(20, 200)
	new_enemy.position.y = rng.randf_range(20, 200)
	enemyPath.add_child(new_enemy)
	# pikachus need the name Pikachu, to be recognized by resources farming-area
	new_enemy.name = "Bad Pokachu"

	# recall to have all pokachus from the "pokachus"-group in "pokachus"-variable again
	get_enemies()
	
	
#		var x_position = round(event)
#		var y_position = round(event.position.y/3)
#		var position = Vector2(100,100)
#		pikachuBuilder._build_pikachu(self,self.find_child("TileMap"),position)
