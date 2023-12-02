extends GoodPokemon
#extends CharacterBody2D

class_name Pikachu

signal pikachu_clicked

@export var selected = false
@onready var box = get_node("Selected")

#implements the pathfinding algorithm
@onready var nav_agent:= $NavigationAgent2D #as NavigationAgent2D

var is_fighting = false

func _ready():
	$AnimatedSprite2D.animation = "walk_down"
	$AnimatedSprite2D.play()
	
	var main_node = get_tree().get_root().get_node("Main")
	connect("pikachu_clicked", Callable(main_node, "_on_pikachu_clicked"))
	
	set_selected(false)
	
	# super initializes the healthbar 
	super()


func _process(_delta:float):
	if Game.is_paused == true:
		return
	pikachu_scale_on_hover()
		
	
func _physics_process(_delta: float) -> void:
	if Game.is_paused == true:
		return
#	var prev_vel = velocity
	#if int(nav_agent.distance_to_target() < 2):
		#return
		
	var next_pos = nav_agent.get_next_path_position()
	var dir = to_local(next_pos).normalized()
	velocity = dir * speed
	
	if position.distance_to(next_pos) < 1:
		velocity = Vector2.ZERO
		if dir != Vector2.ZERO:
			self.position = next_pos
		target = self.position
	
	if is_fighting == false:
		apply_corresponding_animation()
	
	move_and_slide()


func apply_corresponding_animation():
	var current_animation
	
	# calculate the degrees of the walking direction
	var current_velocity = velocity
	var radians = current_velocity.angle()
	var degrees = radians * (180/PI)
	if degrees < 0:
		degrees = 360 - abs(degrees)
	
	if degrees >= 22.5 and degrees <= 67.5:
		current_animation = "walk_down_right"
	elif degrees > 67.5 and degrees <= 112.5:
		current_animation = "walk_down"
	elif degrees > 112.5 and degrees <= 157.5:
		current_animation = "walk_down_left"
	elif degrees > 157.5 and degrees <= 202.5:
		current_animation = "walk_left"
	elif degrees > 202.5 and degrees <= 247.5:
		current_animation = "walk_up_left"
	elif degrees > 247.5 and degrees <= 292.5:
		current_animation = "walk_up"
	elif degrees > 292.5 and degrees <= 337.5:
		current_animation = "walk_up_right"
	else:
		current_animation = "walk_right"

	$AnimatedSprite2D.animation = current_animation
	$AnimatedSprite2D.play()


# added is_farming = false to cancel farming when a new destination is issued for pikachu
func make_path(ressource_position = get_global_mouse_position()) -> void:
	if Game.is_paused == true:
		return
	nav_agent.target_position = ressource_position
	target = nav_agent.target_position

func _on_mouse_entered():
	if Game.is_paused == true:
		return
	pok_hover = true
	set_selected(true)

func _on_mouse_exited():
	if Game.is_paused == true:
		return
	pok_hover = false
	set_selected(false)

func set_selected(value):
	selected = value
	box.visible = value


func _pika_hover_selected_check(_event):
	if Game.is_paused == true:
		return
	if pok_hover and Input.is_action_pressed("left_click"):
		emit_signal("pikachu_clicked", self)
		pok_hover = false
		
	# leftclick on "nothing" to deselect units
	elif Input.is_action_pressed("left_click"):
		pok_hover = false


func pikachu_scale_on_hover() -> void:
	if Game.is_paused == true:
		return
	if pok_hover:
		self.scale.x = 0.6
		self.scale.y = 0.6

	else:
		self.scale.x = 0.5
		self.scale.y = 0.5

func _on_input_event(_viewport, event, _shape_idx):
	if pok_hover:
		_pika_hover_selected_check(event)

# function to reduce pikachus health, number damage is reducted from pikachus health_bar
func _on_hit(damage, type):
	var pathMain = get_tree().get_root().get_node("Main")
	damage = calculateDamage(damage, type)
	health_bar.value -= damage
	if health_bar.value == 0:
		pathMain.pikachus.erase(self)
		self.queue_free()
		pathMain.get_pikachus()
		if self in pathMain.selected_pokemon:
			pathMain.selected_pokemon.erase(self)
			Game.Selected = pathMain.selected_pokemon.size()
		# decrease friendly unit counter
		Game.friendlyUnits -= 1



func _on_area_2d_area_entered(area):
	is_fighting = true


func _on_area_2d_area_exited(area):
	is_fighting = false
