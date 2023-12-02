extends Node

class_name PlayerData

const pikachu = "res://Scenes/pokemon/pikachu.tscn"
const squirtle = "res://Scenes/pokemon/squirtle.tscn"
const charmander = "res://Scenes/pokemon/charmander.tscn"
const bulbasaur = "res://Scenes/pokemon/bulbasaur.tscn"

var pikachuIcon = "res://Assets/Potraits/pikachu_and_evolutions/pikachu Angry.png"
var CharmanderIcon = "res://Assets/Potraits/charmander_and_evolutions/charmander Angry.png"
var CharmeleonIcon =  "res://Assets/Potraits/charmander_and_evolutions/charmeleon Angry.png"
var CharizardIcon = "res://Assets/Potraits/charmander_and_evolutions/Charizard Angry.png"
var SquirleIcon = "res://Assets/Potraits/squirtle_and_evolutions/squirtle Angry.png"
var WartortleIcon = "res://Assets/Potraits/squirtle_and_evolutions/Wartortle Angry.png"
var BlastoiseIcon = "res://Assets/Potraits/squirtle_and_evolutions/Blastoise Angry.png"
var BulbasaurIcon = "res://Assets/Potraits/bulbasaur_and_evolutions/Bulbasaur Angry.png"
var IvysaurIcon = "res://Assets/Potraits/bulbasaur_and_evolutions/Ivysaur Angry.png"
var VenusaurIcon = "res://Assets/Potraits/bulbasaur_and_evolutions/Venusaur Angry.png"


var Food = 0
var Wood = 0
var Stone = 0
var GameMode = "play"
var selectedBuilding = "Fire Arena"
var buildCounter = 0
var Selected = 0

var militaryCost = 10
var pikachuCost = 8
var Player_name : String

var screenWidth: int
var screenHeight: int

var UIHover = false

# dialogue attributes:
var playerName: String = "Bulbasaur"

var skipping_speeches = false
var is_paused = false

# keeping track of available units (through laboratory)
var fireUnitLvl = 0
var waterUnitLvl = 0
var plantUnitLvl = 0

# this variable changes the finishing Game dialogue
var player_win

# training Queues
var pikachuQueue = []
var fireQueue = []
var waterQueue = []
var plantQueue = []

# upgrade time and cost constants (food)
var FIRST_UPGRADE_COST = 100
var SECOND_UPGRADE_COST = 200
var FIRST_UPGRADE_TIME = 100
var SECOND_UPGRADE_TIME = 200

# unit costs (food)
var PIKACHU_COST = 8
var CHARMANDER_COST = 10
var CHARMELEON_COST = 20
var CHARIZARD_COST = 30
var SQUIRTLE_COST = 10
var WARTORTLE_COST = 20
var BLASTOISE_COST = 30
var BULBASAUR_COST = 10
var IVYSAUR_COST = 20
var VENUSAUR_COST = 30

# building costs (wood)
var FIRE_ARENA_COST = 20 
var PLANT_ARENA_COST = 20 
var WATER_ARENA_COST = 20 

# unit count (start with two pikachus)
var friendlyUnits = 2
var hostileUnits = 0

# unit caps
var POP_CAP_FRIENDLY = 70
var POP_CAP_HOSTILE = 50

# game state can be paused (false) or running (true)
# if the game is paused, no more _process funcions are getting called
# do not use
func set_game_paused(state):
	# the default paused state in Godot skips all process and physics_process functions of nodes 
	# that are specified in Node->Process->Mode
	# get_tree().paused = state
	
	# this state varible is used to more specifically skip functions in the Game
	is_paused = state

'''
func _process(delta):
	if is_paused == false:
		if true:
			var mainPath = get_tree().get_root().get_node("Main")
'''			

func run_intro_finished():
	var mainPath = get_tree().get_root().get_node("Main")
	mainPath.on_intro_finished()

func trigger_win_game():
	player_win = true
	var hud = preload("res://Scenes/GUI/hud.tscn")
	var pathUI = get_tree().get_root().get_node("Main/UI")
	var hudOverlay = hud.instantiate()
	pathUI.add_child(hudOverlay)
	
	# call loosing overlay
	hudOverlay.win_game_overlay()

func trigger_loose_game():
	player_win = false
	var hud = preload("res://Scenes/GUI/hud.tscn")
	var pathUI = get_tree().get_root().get_node("Main/UI")
	var hudOverlay = hud.instantiate()
	pathUI.add_child(hudOverlay)
	
	# call loosing overlay
	hudOverlay.loose_game_overlay()

func play_again():
	get_tree().reload_current_scene()

func exit_game():
	get_tree().quit()
