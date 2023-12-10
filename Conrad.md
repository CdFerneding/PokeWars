# Game Programming IMT 3603

# Individual Report - Conrad Ferneding

## Good code
### Drag selection, ressources and ressource display
I programmed along a youtube tutorial [CodingQuests RTSGame](https://www.youtube.com/watch?v=2hiKniYh8y4&list=PLPuNhh82sRgljBFnwgASb0x5ZNhBheHY8&ab_channel=CodingQuests) to initially learn about Godot and already implement some functionalities for a fundamental RTS Game. The Code for that is saved on my own Github account: [CdFerneding/RTSGame](https://github.com/CdFerneding/RTSGame)
  
Through this youtube tutorial I was able to add a health bar, drag selection, learn about signals, order of nodes in the scene tree and groups.  

drag selection in [camera.gd](Scripts/Data/camera.gd#135):
<pre>
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
</pre>
logic behind farming wood in [tree.gd](Scripts/WorldObjects/tree.gd#15):
<pre>
func _process(_delta):
	if Game.is_paused:
		return
	bar.value = currTime
	# check if bush has been completely choped 
	if currTime <= 0:
		treeChopped()

func _on_chop_area_body_entered(body):
	if "Pikachu" in body.name:
		pikachus += 1
		startChopping()
</pre>

### Training queue  
After Justin added the functionality of training pokemon in different buildings I added a training queue for the different pokemon. Before the queue existed the player would be able to simultaniously train multiple pikachus if the neccessary ressources are available. Through the queues the player is forced to always keep an eye on the queue and keep the training of pikachus going.  

variables in [Game.gd](Scripts/Data/Game.gd#53):
<pre>
# training Queues
var pikachuQueue = []
var fireQueue = []
var waterQueue = []
var plantQueue = []
</pre>
implementation in [TrainIcon.gd](/Scripts/GUI/TrainIcon.gd#13):
<pre>
func _ready():
	if type == "Pikachu":
		Game.pikachuQueue.append(selfId)
	elif type == "Charmander" or type == "Charmeleon" or type == "Charizard":
		Game.fireQueue.append(selfId)
	elif type == "Bulbasaur" or type == "Ivysaur" or type == "Venusaur":
		Game.plantQueue.append(selfId)
	elif type == "Squirtle" or type == "Wartortle" or type == "Blastoise":
		Game.waterQueue.append(selfId)
</pre>

### Pause game
I implemented a is_paused variable in the Game script to handle functions that should be skipped when the game is paused. When a function should be paused "is_paused" you need to check if the variable is true and then return as to not update the Game 

### Constants
What is good is that I implemented constants in the Game.gd file. By that it is possible to design the Game statistics (attack and hp values) and then only make changes in one file instead of cahnging every file and if condition.  

### Evolutions and laboratory
For the pokemon to be able to evolve I added additional sprites, selection boxes and collision shapes that are being enabled/disabled based on the new evolution variable.  

[charmander.gd](/Scripts/Entities/charmander.gd#8):
<pre>
# handling evolution differences
@export var evolution = 0
</pre>  
Inside [check_evolution](/Scripts/Entities/charmander.gd#37) function:
<pre>
# check current evolution of charmander and enable / disable according boxes, shapes and sprites
	if evolution == 0:
		attack_damage = Game.CHARMANDER_ATTACK
		$HealthBar.max_value = Game.CHARMANDER_HEALTH
		$charmander.visible = true
		$CollisionShapeCharmander.visible = true
		animationSprite = $charmander
		box = $CharmanderSelected
		## disable charmeleon and charizard sprites
		$charmeleon.visible = false
		$charizard.visible = false
		## disable collision shapes
		$CollisionShapeCharmeleon.visible = false
		$CollisionShapeCharizard.visible = false
		## disable selection boxes
		$CharmeleonSelected.visible = false
		$CharizardSelected.visible = false
	elif evolution == 1:
		attack_damage = Game.CHARMELEON_ATTACK
        [...]
</pre>  
To unlock the evolution of a pokemon the player needs to farm berries, click the upgrade in the laboratory and wait for the upgrade to go through. The corresponding bottons are disabled/enabled based on the player action (is the upgrade already in queue / was it already done / does the player have enough resources).  
[UI.gd](/Scripts/GUI/UI.gd#277):
<pre>
func _on_upgrade_to_venusaur_pressed():
	if Game.plantUnitLvl != 1 or Game.Food < Game.SECOND_UPGRADE_COST or is_upgrade_ongoing("UpgradeToVenusaur"):
		return
	start_upgrade("Venusaur")
	Game.Food -= Game.SECOND_UPGRADE_COST


func start_upgrade(upgrade_to):
	if Game.is_paused:
		return
		
	if upgrade_to == "Blastoise" or upgrade_to == "Venusaur" or upgrade_to == "Charizard":
		time = Game.SECOND_UPGRADE_TIME
	else:
		time = Game.FIRST_UPGRADE_TIME
	
	var trainIconScene = load("res://Scenes/GUI/Trainicon.tscn")
	var queueItem = trainIconScene.instantiate()
	var button = get_node("UpgradeMilitary/UpgradeTo"+upgrade_to)
	queueItem.get_node("UnitIcon").texture = button.icon
	queueItem.totalTime = time
	queueItem.type = "UpgradeTo"+upgrade_to
	$TrainingQueue.add_child(queueItem)
</pre>

### Animating sprites based on walking (/velocity) angle
The following code is pretty self explanatory. The velocity is already given through Godot's CharacterBody2D Node which has a velocity attribute. I am transforming the velocity to degrees and afterwards am applying the animation to their corresponding angles (found through testing). Since we have 8 animated walk directions I calculated:  
360 / 8 = 45  
Now I spanned these 45 degrees around the walking direction. For example should the walk_down_right sprite be used when the angle is bigger than 22.5 or smaller than 67.5:  
67.5 - 22.5 = 45  
Now I am going around the 360 degrees and always add 45 to get the new angle border until I am at 22.5 again (or I have programmed 8 directions).  
in [pikachu.gd](/Scripts/Entities/pikachu.gd#56)
<pre>
func apply_corresponding_animation():
	var current_animation
	
	# calculate the degrees of the walking direction
	var current_velocity = velocity
	var radians = current_velocity.angle()
	var degrees = radians * 180 * 0.32  # equals 180 / PI but should be faster
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
</pre>

### Other
Other things I did that I had a lower number of issues in include:  
Adding sprites for the enemies, creating selection boxes, writing dialogue (which is not really code in my opinion) and playing it in the game, creating a start-/win-/loose-game HUD 

## Bad code
### Redundant code for Pokemon
Before I worked on the enemies (adding the different sprites) Max and Evan created 3 different "BigBadPokemon". Since the code is basically the same with the only difference being the animation and the pokemon defence/attack type, they were able to get the code into one script. This is very good in terms of overview and sanitation of the code (maybe a little worse in terms of efficiency because conditions are neccessary to animate the correct sprites).  
This could've been done for the military pokemon as well (bulbasaur, squirtle, charmander). This should technically be done, because when developer want to make changes to all Pokemon it makes it harder to overlook a file when there is only one instead of 3.  

### Variables and functions naming conventions
Unfortunately we missed to discuss naming conventions on our first meeting. Because of this blunder the naming conventions are messed up throughout the repository. For example I wrote my Variables in camelCase, my functions in snake_case (Godot funcitons are _snake_case [with underscore]), constants in UPPER CASE. However I know that there are Variable and Function names that are not following this pattern which we said would be to much to change by now and it does not bother us.  
I want to mention that if the project was larger this would be a bigger problem since there are more variables and funciton developer (and maybe new developers) need to track.  
Example from [camera.gd](/Scripts/Data/camera.gd#16):  
<pre>
# variable names by Evan
var maximum_x_to_move_camera_left
var maximum_y_to_move_camera_up
var minimum_x_to_move_camera_right
var minimum_y_to_move_camera_down

# variable names by Conrad
var mousePos = Vector2()
var mousePosGlobal = Vector2()
var start = Vector2()
var startV = Vector2()
</pre>

### Constants
Even though it is good that I implemented constants they could've been inside an extra file to isolate the constants from game state variables and game/dialogue functions (modulation).  

## Refleciton on key concepts
Concepts I have implemented are the following:  
Drag selection, event handling, queue management, pause game functionality, use of constants, evolution / upgrade mechanisms / player state, sprite animation, 

## Video
Video about groups, pausing the game, the Dialogue Manager, public scripts and event trigger in Godot (signals)  
[See Video Godot Intern Funcitonalities](Documentation/Conrad_Ferneding_Personal_Report_Assets/video_for_interface_documentation.mp4) 
