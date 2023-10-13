extends CharacterBody2D

# pikachu can hold 10 ressources (ressources being: berries, wood, stone) at a time.
# if pikachu switches to farming a different ressource ...
# without delivering the inventory to the pokecenter first the before farmed ressources get lost (macro)
@export var ressource_inventory = 0 # this number must never be anything else than [0,10]
@export var tilemap : TileMap 
@export var main: Node
var is_farming = false #
var pik_hover = false

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
	pikatchu_scale_on_hover()
		
	
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
	
# added is_farming = false to cancel farming when a new destination is issued for pikachu
func make_path(ressource_position = get_global_mouse_position()) -> void:
	is_farming = false
	nav_agent.target_position = ressource_position
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



# ----------------------------- farming berries -----------------------------
func farm_berries():
	is_farming = true
	var ressource_position = get_global_mouse_position()
	var pokecenter_position = tilemap.get_used_cells_by_id(1, 1, Vector2(0, 0))
	while is_farming:
		make_path_to_ressource(ressource_position)
		# stand there while "pikachu_inventory" goes up
		$FarmTimer.start()
		# when "ressource_inventory" hits 10 he delivers the (10) berries to the pokecenter
		# FarmTimer.stop has to be handles in _process function
		if ressource_inventory == 10:
			$FarmTimer.stop()
			make_path_to_ressource(pokecenter_position)
			# food counter increase 
			ressource_inventory = 0
		
		# when ressoure is delivered to pokecenter the ressource counterf (HUD) is updated
		# repeat / while pikachu is to farm berries
	
# ----------------------------- helper functions -----------------------------
# added ressource_position to make_path function with get_global_position as a default parameter
# need an addition function that does not set is_farming to false
func make_path_to_ressource(ressource_position = get_global_mouse_position()) -> void:
	nav_agent.target_position = ressource_position
	target = nav_agent.target_position

func _on_farm_timer_timeout():
	ressource_inventory += 1

# ----------------------------- farming berries end -----------------------------



func _on_mouse_entered():
	pik_hover = true



func _on_mouse_exited():
	pik_hover = false


func _pika_hover_selected_check(event):
	if pik_hover and Input.is_action_pressed("left_click"):
		main.selected_pikachu.append(self)
		pik_hover = false
		
	# leftclick on "nothing" to deselect units
	elif Input.is_action_pressed("left_click"):
		main.selected_pikachu = []
		pik_hover = false


func pikatchu_scale_on_hover() -> void:
	if pik_hover:
		self.scale.x = 0.6
		self.scale.y = 0.6

	else:
		self.scale.x = 0.5
		self.scale.y = 0.5



func _on_input_event(viewport, event, shape_idx):
	_pika_hover_selected_check(event)
