extends Area2D

signal hit

@export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.
var previous_direction
var previous_position

func _ready():
	screen_size = get_viewport_rect().size
	previous_direction = "down"
	$AnimatedSprite2D.animation = "idle_down"
	hide()

func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	$AnimatedSprite2D.play()
	
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	previous_position = position
	
	if velocity == Vector2.ZERO:
		$AnimatedSprite2D.animation = "idle_"+previous_direction
	else:
		var current_animation = ""
		
		if velocity.y < 0:
			current_animation+="up_"
		elif velocity.y > 0:
			current_animation+="down_"
			
		if velocity.x < 0:
			current_animation+="left_"
		elif velocity.x > 0:
			current_animation += "right_"
		
		previous_direction = current_animation.left(current_animation.length() - 1)
		current_animation = "walking_"+previous_direction
		$AnimatedSprite2D.animation = current_animation
		
func _on_body_entered(body):
	print("colision")
	hit.emit()
	position = previous_position
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionShape2D.set_deferred("disabled", true)
	
	
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
