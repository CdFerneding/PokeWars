extends Node

class_name PlayerData

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


# dialogue attributes:
var playerName: String = "player"
var introDialoguePlayed = false

var is_paused = false


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
