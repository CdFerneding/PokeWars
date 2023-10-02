extends CharacterBody2D

#speed of moving Pikatchu
const speed = 50

#used to detect when path is reached
var target : Vector2

var previous_direction

#implements the pathfinding algorithm
@onready var nav_agent:= $NavigationAgent2D as NavigationAgent2D

func _ready():
	previous_direction = "down"
	$AnimatedSprite2D.animation = "walk_down"

func _process(delta:float):
	pass
	
func _physics_process(_delta: float) -> void:
	
	var prev_vel = velocity
	if self.position == target:
		return
		
	var next_pos = nav_agent.get_next_path_position()
	var dir = to_local(next_pos).normalized()
	velocity = dir * speed
	
	if position.distance_to(next_pos) < 1:
		velocity = Vector2.ZERO
		if dir != Vector2.ZERO:
			self.position = next_pos
		target = self.position
	apply_corresponding_animation(velocity)
	
	move_and_slide()
	
func make_path() -> void:
	nav_agent.target_position = get_global_mouse_position()
	target = nav_agent.target_position
	
#toDo
#not sufficient yet
func apply_corresponding_animation(prev):
	var current_animation = ""
	
	#if prev.x == velocity.x and prev.y == velocity.y:
	#	current_animation += "down_"
		
	if velocity.y > 0:
		current_animation+="down_"
	elif velocity.y < 0:
		current_animation+="up_"
		
	if velocity.x < 0:
		current_animation+="left_"
	elif velocity.x > 0:
		current_animation += "right_"
		
	if current_animation == "":
		current_animation = previous_direction+"_"
	
	previous_direction = current_animation.left(current_animation.length() - 1)
	current_animation = "walk_"+previous_direction

	$AnimatedSprite2D.animation = current_animation
	$AnimatedSprite2D.play()

	
func _input(event):
	pass
	
	#this was a try to start pathfinding algorithem from Pikatchu and not from the main scene
#	if event.is_action("left_click"):
#		print("Pikachu clicked")
		
		
		
		
   
