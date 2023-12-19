## Game Programming IMT 3603

# Individual Report - Evan Fregeais

### Good code

#### Camera

To have a gameplay experience close enough to an Age of Empire style of game, we needed to have a camera controled by and only by the player. The main goal was for the player to move the camera with his mouse or by keyboard input. One of the big issues was to know where the camera is on the tilemap, how to keep the camera inside the game border and when the mouse is close enought to the edge of the window to be able to move the camera.

Since it's not a common way to create camera movement (at least on godot), there wasn't an easy tutorial to know where to look. To get the border limit of the game, it was pretty easy since we just needed to have the tilemap to get the information.

```gdscript
	var mapRect = tilemap.get_used_rect()
	var tileSize = tilemap.cell_quadrant_size
	var worldSizeInPixels = mapRect.size * tileSize
```

With this, we can get the camera limit to go to the left or the bottom in ingame coordinate. 

One problem was when we zoom in or out or when we change the windows size. To deal with it, we need to get information about the current windows



But we needed also to update the border of the camera when the window size is changed. Hopefully there was an event called size changed for the windows on Godot and we can connect this event to our function in the camera.

```gdscript
get_viewport().size_changed.connect(Callable(get_node("Camera"), "update_limit"))
```

#### Ennemies

To be able to have pokemon fighting each other, we first created ennemies. Since we didn't wanted the ennemies to stay where they spawned (since the pokecenter is far away) they needed to be able to see every good pokemon. Since it would have been a big performance issue to this every game tick, we implemented a Timer to retarget ennemies. Also, to improving it more, we change the duration timer is far away or if it's closer:

```gdscript
    if nearest_target.position.distance_to(position) > 100:
        $RetargetTimer.wait_time = 2
    else:
        $RetargetTimer.wait_time = 0.5
```

To be able for the ennemies to deal damage to a specific pokemon we decided to not use the signal system in godot since it will call the others pokemon.

Each time we run the retarget function in the ennemies, we save the closest pokemon and inside our physic process function we check if the pokemon is close enough and if the attack cooldown is over, we attack the targeted pokemon:



> <u>**ennemy.gd**</u>

```gdscript
func _physics_process(_delta: float) -> void:
    # ...
	if current_target!= null and position.distance_to(current_target.position) < 10:
		velocity = Vector2.ZERO
		if $AttackCooldown.is_stopped():
			attack()
    #...
	
func attack():
	(current_target as GoodPokemon)._on_hit(attack_damage, type)
	$AttackCooldown.start()
```

> **<u>pikachu.gd</u>**

```gdscript
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
```



#### Military pokemons



## Bad code

#### Detect a window size change

As I said before about the camera, the event to detect window size change doesn't work on Windows and Linux. To remedy this issue, we needed to create a hack to fix this issue. To do that we created a timer to call the update_border function in the camera code every 0.1s. To deal with performance issue we added a few lines of code to prevent recalculating every time if the window size hasn't changed:

```gdscript
	if get_viewport_rect() == previous_viewport_rect:
		return
	previous_viewport_rect = get_viewport_rect()
```

## Reflection

## Video

Show performance optimization
