extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_entered(body):
	if(body.is_in_group("Unit")):
		print(body.position)
		for i in range(body.previous_positions.size() -1, -1,-1):
			var pos = body.previous_positions[i]
			body.position = pos
			print(body.position)
		


func _on_area_exited(body):
	if(body.is_in_group("Unit")):
		print(body)

	
