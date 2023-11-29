extends Node

class_name PlayerData

const pikachu = "res://Scenes/pokemon/pikachu.tscn"
const squirtle = "res://Scenes/pokemon/squirtle.tscn"
const charmander = "res://Scenes/pokemon/charmander.tscn"
const bulbasaur = "res://Scenes/pokemon/bulbasaur.tscn"

var pikachuIcon = "res://Assets/Potraits/pikachu_and_evolutions/pikachu Angry.png"
var CharmanderIcon = "res://Assets/Potraits/charmander Angry.png"
var SquirleIcon = "res://Assets/Potraits/squirtle Angry.png"
var BulbasaurIcon = "res://Assets/Potraits/bulbasaur Angry.png"


var Food = 0
var Wood = 0
var Stone = 0
var GameMode = "play"
var selectedBuilding = "Fire Arena"
var buildCounter = 0
var Selected = 0

var buildingCost = 0
var militaryCost = 10
var pikachuCost = 8
var Player_name : String

var screenWidth: int
var screenHeight: int

var UIHover = false

# dialogue attributes:
var playerName: String = "player"
var introDialoguePlayed = false

var is_paused = false

# keeping track of available units (through laboratory)
var fireUnitLvl = 0
var waterUnitLvl = 0
var plantUnitLvl = 0


# game state can be paused (false) or running (true)
# if the game is paused, no more _process funcions are getting called
# do not use
func set_game_paused(state):
	# the default paused state in Godot skips all process and physics_process functions of nodes 
	# that are specified in Node->Process->Mode
	# get_tree().paused = state
	
	# this state varible is used to more specifically skip functions in the Game
	is_paused = state
	
# true equals running
func set_timer_state(state):
	var pathUI = get_tree().get_root().get_node("Main/UI")
	if state == true:
		pathUI.set_timer_state(state)
	else:
		pathUI.set_timer_state(state)

func run_intro_finished():
	var mainPath = get_tree().get_root().get_node("Main")
	mainPath.on_intro_finished()
