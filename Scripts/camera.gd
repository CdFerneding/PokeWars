extends Camera2D
@export var tilemap: TileMap
@export var moveOffset: int
var visible_size
var viewportYBy2
var viewportXBy2

var border_right
var border_left
var border_bottom
var border_top

func _ready():
	update_limit()

# if the tilemap is updated, we need to go through this method
func update_limit():
	var mapRect = tilemap.get_used_rect()
	var tileSize = tilemap.cell_quadrant_size
	var worldSizeInPixels = mapRect.size * tileSize
	limit_right = worldSizeInPixels.x
	limit_bottom = worldSizeInPixels.y
	limit_left = 0
	limit_top = 0
	update_border()

# if the zoom or the viewport change, we need to go through this method
func update_border():
	var viewport_rect = get_viewport_rect()
	visible_size = viewport_rect.size / zoom  # Adjust for camera zoom
	
	viewportXBy2 = visible_size.x/2 # Will be use to calculate 
	viewportYBy2 = visible_size.y/2
	
	border_right = limit_right - viewportXBy2
	border_left = viewportXBy2
	border_bottom = limit_bottom - viewportYBy2
	border_top= viewportYBy2

	

func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	
	if Input.is_action_pressed("move_right") and position.x < border_right:
		velocity.x += moveOffset * delta
	if Input.is_action_pressed("move_left") and position.x > border_left:
		velocity.x -= moveOffset * delta
	if Input.is_action_pressed("move_down") and position.y < border_bottom:
		velocity.y += moveOffset * delta
	if Input.is_action_pressed("move_up") and position.y > border_top:
		velocity.y -= moveOffset * delta
	if Input.is_action_pressed("zoom_out") and zoom.x > 3 and $CooldownZoomTimer.is_stopped():
		zoom.x -= 1
		zoom.y -= 1
		$CooldownZoomTimer.start()
	if Input.is_action_pressed("zoom_in") and zoom.x < 6 and $CooldownZoomTimer.is_stopped():
		zoom.x += 1
		zoom.y += 1
		$CooldownZoomTimer.start()
		
	var new_position = position + velocity

	position = new_position
