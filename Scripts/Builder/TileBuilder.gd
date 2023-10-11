extends Object

class_name TileBuilder

static func _tileSetter(position,tileMap,tileId):
	var y = 0

	tileMap.set_cell(1,Vector2(position[0], position[2]),tileId,Vector2i(0,0))

	for n in range(position[2]+2,position[3]+1,-1):
		var x = 0
		print(y)
		for m in range(position[1]-2,position[0]-3, -1):
			match x:
				0:
					if y == 0:
						tileMap.set_cell(0,Vector2(m,n), 1,Vector2i(3,5))
					elif(y == 1 || y== 2):
						tileMap.set_cell(0,Vector2(m,n), 1,Vector2i(2,7))
					else:
						tileMap.set_cell(0,Vector2(m,n), 1,Vector2i(3,4))
				1,2,3:
					if y == 3:
						tileMap.set_cell(0,Vector2(m,n), 1,Vector2i(3,6))
					elif y == 0:
						tileMap.set_cell(0,Vector2(m,n), 1,Vector2i(3,7))
					else:
						tileMap.set_cell(0,Vector2(m,n), 1,Vector2i(0,4))
				4:
					if y == 0:
						tileMap.set_cell(0,Vector2(m,n), 1,Vector2i(2,5))
					elif(y == 1 || y== 2):
						tileMap.set_cell(0,Vector2(m,n), 1,Vector2i(2,6))
					else:
						tileMap.set_cell(0,Vector2(m,n), 1,Vector2i(2,4))
			x = x +1
		y = y + 1

		
		
static func _tileBuilder(position, tileMap, id):
	var no_obstacle = true

	#position array x_pos_offset_left, x_pos_offset_right, y_pos_offset_up, y_pos_offset_down
	for n in range(position[2]+3,position[3]-1,-1):
		for m in range(position[1]-1,position[0]-4, -1):
			var current_position = Vector2i(m,n)
			var obstacle_layer1 = is_instance_valid(tileMap.get_cell_tile_data(1,Vector2i(m, n)))
			if(obstacle_layer1):
				no_obstacle = false
				
	if(no_obstacle == true):
		_tileSetter(position,tileMap,id)
	else:
		pass
		
