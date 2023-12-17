# Game Programming IMT 3603

# Individual Report - Justin Frauböse

## Bad Code
### Structure of training building
The way I created the building scene, is that there only a single scene for all the different buildings and depending on the name of the building in the main scene it decides what part of the code should be run. What that does is that, since all the functions are present in the only script file it makes the code unneccesary big and also adds redundancy to the code. 
Here is an example of what I mean with it.
<pre>
func _check_food(evolution):
	if "PokeCenter" in self.name:
		return Game.PIKACHU_COST
	if "Fire Arena" in self.name:
		match evolution:
			0: return Game.CHARMANDER_COST
			1: return Game.CHARMELEON_COST
			2: return Game.CHARIZARD_COST
	if "Water Arena" in self.name:
		match evolution:
			0: return Game.SQUIRTLE_COST
			1: return Game.WARTORTLE_COST
			2: return Game.BLASTOISE_COST
	if "Plant Arena" in self.name:
		match evolution:
			0: return Game.BULBASAUR_COST
			1: return Game.IVYSAUR_COST
			2: return Game.VENUSAUR_COST
</pre>

The way I could solve this is by creating a generic script that includes the universal functions like deleting a building. From that script I could create other scripts that inherit that scipt as a parent. Inside I could write the more specific script. With that I could reduce the code at the top to a minimum depending on the scene.
For the fire arena it could look like this.
<pre>
func _check_food(evolution):
	match evolution:
		0: return Game.CHARMANDER_COST
		1: return Game.CHARMELEON_COST
		2: return Game.CHARIZARD_COST
	
</pre>

### placing buildings
The next bad code I want to present is about pacing building into the world. Here I decoupled the sprite for the building for the scene object. As to why, I think it was because I had tunnel vision and because at first I tried to create the building without taking the object into account. For a little background the "sprite" of the building is just a tile inside of the tilemap of the main scene that is placed by the player. I did it like that because it was the only way we could think of to make our units avoid the buildings and walk around it. Behind that main tile on a lower layer I also place an area of obstacle tiles to be certain of that. In retrospective I could just have the sprite inside of the scene and it should work fine. But I would still have to create the area below the building for navigation. So if I wanted to fix that I would have to restructure the whole navigation aspect to also avoid scenes and objects. If that were possible we completely scrape the [tileBuilder.gd](scripts/Builder/TileBuilder.gd). As there would be no need to create the tile for the "Sprite" or the area below it.

### the tileBuilder script
It is probably the most challenging and hidious part of the whole project I have written. The main fault I have with this code is the offsets I had to create for it to work. In the file that calls the tile_builder function I have to create an offset for the position of tilemap where the user clicked inside of the world.
<pre>
func _create_offset(tileId, tile_position):
	var position_array = []
	var x_offset
	var y_offset
	match tileId:
		2:
			x_offset = 4
			y_offset = 3
		3,4,5:
			x_offset = 4
			y_offset = 4
		
	var x_pos_offset_left = tile_position.x
	var x_pos_offset_right = tile_position.x + x_offset
	var y_pos_offset_up = tile_position.y
	var y_pos_offset_down = tile_position.y - y_offset
	return [x_pos_offset_left, x_pos_offset_right, y_pos_offset_up, y_pos_offset_down]
</pre>
From there this offset is then sent as a parameter to the tile_builder. Inside I have to create another offset. that is added on top of the other offset to check the area where the user wants to place the building if there is already a conflicting tile present. If not it can initilize the tiles for the building inside the tile_setter

[tile_builder](scripts/Builder/TileBuilder.gd#L42)
<pre>
static func tile_builder(positionArray:Array, tileMap:TileMap, tileId:int, position, building):
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

	for n in range(positionArray[2]+top_offset,positionArray[3]-1,-1):
		for m in range(positionArray[1] - left_offset,positionArray[0]-right_offeset, -1):
			var current_position = Vector2i(m,n)
			var obstacle_layer1 = is_instance_valid(tileMap.get_cell_tile_data(1,Vector2i(m, n)))
			if(obstacle_layer1):
				no_obstacle = false
</pre>

[tile_setter](scripts/Builder/TileBuilder.gd#L1)
<pre>
static func _tile_setter(position:Array,tileMap:TileMap,tileId:int, building):
	var y = 0

	var y_range = (position[2]+2) - (position[3]+1)
	var x_range = (position[1]-2) - (position[0]-3)
	print(position[2]*16)
	building.position = Vector2(position[0] * 16 + x_range, position[2]*16 + y_range + 2)
	#building.position.y = y_range
	#building.position.x = x_range
	
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
</pre>
