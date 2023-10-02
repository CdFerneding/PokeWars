extends CharacterBody2D

# pikachu can hold 10 ressources (ressources being: berries, wood, stone) at a time.
# if pikachu switches to farming a different ressource ...
# without delivering the inventory to the pokecenter first the before farmed ressources get lost (macro)
@export var ressource_inventory = 0 # this number must never be anything else than [0,10]
var is_farming = false #

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
	if ressource_inventory == 10:
		$FarmTimer.stop()
		
	
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



# ----------------------------- farming berries -----------------------------
func farm_berries():
	var ressource_position = get_global_mouse_position()
	var pokecenter_position = Vector2(176.0 ,112.0) # x = 176; y = 112 is the position of a tileintersection in front of the pokecenter
	while is_farming:
		# walk to berryfield
		make_path_to(ressource_position)
		# stand there while "pikachu_inventory" goes up
		$FarmTimer.start()
		# when "ressource_inventory" hits 10 he delivers the (10) berries to the pokecenter
		# FarmTimer.stop has to be handles in _process function
		make_path_to(pokecenter_position)
		
		# when ressoure is delivered to pokecenter the ressource counterf (HUD) is updated
		# repeat
	
# ----------------------------- helper functions -----------------------------
	# this function is neccessary since the global_mouse_position will not stay the same, 
# but pikachu needs to go to the same ressource
func make_path_to(ressource_position):
	nav_agent.target_position = ressource_position
	target = nav_agent.target_position

func _on_farm_timer_timeout():
	ressource_inventory += 1

# ----------------------------- farming berries end -----------------------------
