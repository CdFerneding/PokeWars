static func _tile_setter(position:Array,tileMap:TileMap,tileId:int):
	var y = 0

	var y_range = (position[2]+2) - (position[3]+1)
	var x_range = (position[1]-2) - (position[0]-3)
	
	tileMap.set_cell(1,Vector2(position[0], position[2]),tileId,Vector2i(0,0))
	
	for n in range(position[2]+2,position[3]+1,-1):
		var x = 0
		for m in range(position[1]-2,position[0]-3, -1):
			if x == 0:
				if y == 0:
					tileMap.set_cell(0,Vector2(m,n), 1,Vector2i(3,5))
				elif y == y_range-1:
					tileMap.set_cell(0,Vector2(m,n), 1,Vector2i(3,4))
				else:
					tileMap.set_cell(0,Vector2(m,n), 1,Vector2i(0,4))
			elif x == x_range-1:
					if y == 0:
						tileMap.set_cell(0,Vector2(m,n), 1,Vector2i(2,5))
					elif y == y_range-1:
						tileMap.set_cell(0,Vector2(m,n), 1,Vector2i(2,4))
					else:
						tileMap.set_cell(0,Vector2(m,n), 1,Vector2i(0,4))
			else:
				tileMap.set_cell(0,Vector2(m,n), 1,Vector2i(0,4))
			x = x +1
		y = y + 1

static func _delete_building(position:Array, tileMap:TileMap):
	for n in range(position[2]+2,position[3]+1,-1):
		for m in range(position[1]-2,position[0]-3, -1):
			tileMap.set_cell(0,Vector2(m,n),1, Vector2(1,4))
	tileMap.set_cell(1,Vector2(position[0], position[2]), -1)

static func _tile_builder(position:Array, tileMap:TileMap, tileId:int):
	var no_obstacle = true
	var right_offeset = 0
	var left_offset = 0
	var top_offset = 0
	if(tileId == 2):
		right_offeset = 4
		left_offset = 1
		top_offset = 3
	else:
		right_offeset = 5
		top_offset = 4
		
	#position array x_pos_offset_left, x_pos_offset_right, y_pos_offset_up, y_pos_offset_down

	for n in range(position[2]+top_offset,position[3]-1,-1):
		for m in range(position[1] - left_offset,position[0]-right_offeset, -1):
			var current_position = Vector2i(m,n)
			var obstacle_layer1 = is_instance_valid(tileMap.get_cell_tile_data(1,Vector2i(m, n)))
			if(obstacle_layer1):
				no_obstacle = false
	
	if(no_obstacle == true && Game.Wood >= Game.buildingCost):
		_tile_setter(position,tileMap,tileId)
		var counter = Game.buildCounter
		Game.buildCounter = counter + 1
		Game.Wood = Game.Wood - 20
		return true
	else:
		return false

	

		
