extends Camera2D
@export var tilemap: TileMap
@export var moveOffset: int
@export var UI: Label
var visible_size
var viewportYBy2
var viewportXBy2

var border_right
var border_left
var border_bottom
var border_top
var viewport_rect

var maximum_x_to_move_camera_left
var maximum_y_to_move_camera_up
var minimum_x_to_move_camera_right
var minimum_y_to_move_camera_down


var mousePos = Vector2()
var mousePosGlobal = Vector2()
var start = Vector2()
var startV = Vector2()
var end = Vector2()
var endV = Vector2()
var isDragging = false
signal area_selected
signal start_move_selection
@onready var box = get_node("../UI/Panel")

func _ready():
	update_limit()
	connect("area_selected", Callable(get_parent(), "_on_area_selected"))

# if the tilemap is updated, we need to go through this method
func update_limit():
	var mapRect = tilemap.get_used_rect()
	var tileSize = tilemap.cell_quadrant_size
	var worldSizeInPixels = mapRect.size * tileSize
	#print(tileSize, " ", mapRect.size)
	limit_right = worldSizeInPixels.x
	limit_bottom = worldSizeInPixels.y
	#print(limit_right, " ", limit_bottom)
	limit_left = 0
	limit_top = 0
	update_border()

# if the zoom or the viewport change, we need to go through this method
func update_border():
	viewport_rect = get_viewport_rect()
	visible_size = viewport_rect.size / zoom  # Adjust for camera zoom
	
	viewportXBy2 = visible_size.x/2 # Will be use to calculate 
	viewportYBy2 = visible_size.y/2
	
	border_right = limit_right - viewportXBy2
	border_left = viewportXBy2
	border_bottom = limit_bottom - viewportYBy2
	border_top= viewportYBy2
	#print(border_right," ", border_left," ", border_top ," ", border_bottom)
	maximum_x_to_move_camera_left = viewport_rect.size.x / 10
	maximum_y_to_move_camera_up = viewport_rect.size.y / 10
	minimum_x_to_move_camera_right = viewport_rect.size.x - viewport_rect.size.x / 10
	minimum_y_to_move_camera_down = viewport_rect.size.y - viewport_rect.size.y / 10
	
	#print(maximum_x_to_move_camera_left, " ", maximum_y_to_move_camera_up, " ", minimum_x_to_move_camera_right, " ", minimum_y_to_move_camera_down)
	

func _process(delta):
	
	var mouse_position = get_viewport().get_mouse_position()
	#print(position)
	var velocity = Vector2.ZERO # The player's movement vector.
	var mouse_on_right = mouse_position.x > minimum_x_to_move_camera_right
	var mouse_on_left = mouse_position.x < maximum_x_to_move_camera_left
	var mouse_on_up = mouse_position.y < maximum_y_to_move_camera_up
	var mouse_on_down = mouse_position.y > minimum_y_to_move_camera_down
	
	
	if (Input.is_action_pressed("move_right") or mouse_on_right) and position.x < border_right:
		velocity.x += moveOffset * delta
	if (Input.is_action_pressed("move_left") or mouse_on_left) and position.x > border_left:
		velocity.x -= moveOffset * delta
	if (Input.is_action_pressed("move_down") or mouse_on_down) and position.y < border_bottom:
		velocity.y += moveOffset * delta
	if (Input.is_action_pressed("move_up") or mouse_on_up) and position.y > border_top:
		velocity.y -= moveOffset * delta
		
	var new_position = position + velocity
	
	if Input.is_action_pressed("zoom_out") and zoom.x > 3:
		zoom.x -= 0.15
		zoom.y -= 0.15
		update_border()
		if new_position.x < border_left:
			new_position.x = maximum_x_to_move_camera_left
		elif new_position.x > border_right:
			new_position.x = minimum_x_to_move_camera_right
			
		if new_position.y < border_top:
			new_position.y = maximum_y_to_move_camera_up
		elif new_position.y > border_bottom:
			new_position.y = minimum_y_to_move_camera_down

		
	if Input.is_action_pressed("zoom_in") and zoom.x < 7:
		zoom.x += 0.15
		zoom.y += 0.15


	position = new_position
	#UI.position = Vector2(new_position.x - 130,new_position.y - 80)
	
	
	
	# drag-select
	if Input.is_action_just_pressed("left_click"):
		start = mousePosGlobal
		startV = mousePos
		isDragging = true

	if isDragging:
		end = mousePosGlobal
		endV = mousePos
		draw_area()
	
	if Input.is_action_just_released("left_click"):
		if startV.distance_to(mousePos) > 20:
			end = mousePosGlobal
			endV = mousePos
			isDragging = false
			draw_area(false)
			emit_signal("area_selected", self)
		else:
			end = start
			isDragging = false
			draw_area(false)

func draw_area(s = true):
	box.size = Vector2(abs(startV.x - endV.x), abs(startV.y - endV.y))
	var pos = Vector2()
	pos.x = min(startV.x, endV.x)
	pos.y = min(startV.y, endV.y)
	box.position = pos
	
	# let the rectangle dissapear after drawing
	box.size *= int(s)

func _input(event):
	if event is InputEventMouse:
		# pos depending on zoom of the camera
		mousePos = event.position
		
		# global (unchanging) pos on the canvas layer
		mousePosGlobal = get_global_mouse_position()
