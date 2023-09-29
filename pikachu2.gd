extends CharacterBody2D

const speed = 200

signal pikachu_2(pik)

var player : Node2D
@onready var nav_agent:= $NavigationAgent2D as NavigationAgent2D

func _process(delta:float):
	var mouse_position = get_viewport().get_mouse_position()
	
	#make_path()
	

func _physics_process(_delta: float) -> void:
	
	var dir = to_local(nav_agent.get_next_path_position()).normalized()
	velocity = dir * speed
	move_and_slide()
	
	
func make_path() -> void:
	nav_agent.target_position = get_global_mouse_position()
	
func _input(event):
	if event.is_action("left_click"):
		print("Pikachu clicked")
		emit_signal("pikachu_2", self)
		
		
		
   





#
#signal hit
#
#@export var speed = 200 # How fast the player will move (pixels/sec).
#@export var tilemap: TileMap
#var limit_right
#var limit_bottom
#var previous_direction
#var previous_positions = []
#var currentDir
#
#var vector_minimum_top_left
#var vector_maximum_bottom_right
#
#
#func _ready():
#	previous_direction = "down"
#	#$AnimatedSprite2D.animation = "idle_down"
#	hide()
#	update_limit()
#
#func update_limit():
#	var shape = $CollisionShape2D.shape.get_rect().size
#
#	var mapRect = tilemap.get_used_rect()
#	var tileSize = tilemap.cell_quadrant_size
#	var worldSizeInPixels = mapRect.size * tileSize
#	limit_right = worldSizeInPixels.x
#	limit_bottom = worldSizeInPixels.y
#
#	vector_minimum_top_left = Vector2(shape.x/2,shape.y)
#
#	vector_maximum_bottom_right = Vector2(worldSizeInPixels.x-shape.x/2, worldSizeInPixels.y-shape.y/2)
#
#func _process(delta):
#	var velocity = Vector2.ZERO # The player's movement vector.
#	if  Input.is_action_pressed("move_right"):
#		velocity.x += 1
#	if Input.is_action_pressed("move_left"):
#		velocity.x -= 1
#	if Input.is_action_pressed("move_down") :
#		velocity.y += 1
#	if Input.is_action_pressed("move_up"):
#		velocity.y -= 1
#
#
#	if velocity.length() > 0:
#		velocity = velocity.normalized() * speed
#		$AnimatedSprite2D.play()
#
#	if(previous_positions.size() < 4):
#		previous_positions.append(position)
#	else:
#		previous_positions.pop_front()
#		previous_positions.append(position)
#	position += velocity * delta
#
#
#	$AnimatedSprite2D.play()
#
#	if velocity == Vector2.ZERO:
#		$AnimatedSprite2D.animation = "idle_"+previous_direction
#	else:
#		var current_animation = ""
#
#		if velocity.y < 0:
#			current_animation+="up_"
#		elif velocity.y > 0:
#			current_animation+="down_"
#
#		if velocity.x < 0:
#			current_animation+="left_"
#		elif velocity.x > 0:
#			current_animation += "right_"
#
#		previous_direction = current_animation.left(current_animation.length() - 1)
#		current_animation = "walking_"+previous_direction
#		$AnimatedSprite2D.animation = current_animation
#
#func start(pos):
#	position = pos
#	show()
#	$CollisionShape2D.disabled = false

