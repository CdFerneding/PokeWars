extends Node

class_name PlayerData

const pikachu = "res://Scenes/pokemon/pikachu.tscn"
const squirtle = "res://Scenes/pokemon/squirtle.tscn"
const charmander = "res://Scenes/pokemon/charmander.tscn"
const bulbasaur = "res://Scenes/pokemon/bulbasaur.tscn"

var pikachuIcon = "res://Assets/Potraits/pikachu Angry.png"
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
# game state can be paused (false) or running (true)
# if the game is paused, no more _process funcions are getting called
# do not use
func set_game_paused(state):
	get_tree().paused = state
