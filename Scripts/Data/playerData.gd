extends Node

class_name PlayerData

var Wood : int = 0
var Stone : int = 0
var Food : int = 0
var Player_name : String


# Called when the node enters the scene tree for the first time.
func _init(player_name: String, wood : int = 50, stone : int = 50, food : int = 50):
	Wood = wood
	Stone = stone
	Food = food
	Player_name = player_name


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
