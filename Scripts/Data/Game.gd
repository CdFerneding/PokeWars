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

var UIHover = false
# game state can be paused (false) or running (true)
# if the game is paused, no more _process funcions are getting called
# do not use
func set_game_paused(state):
	get_tree().paused = state
