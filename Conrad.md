# Game Programming IMT 3603

# Individual Report - Conrad Ferneding

## Good code
### Drag selection, ressources and ressource display
I programmed along a youtube tutorial [CodingQuests RTSGame](https://www.youtube.com/watch?v=2hiKniYh8y4&list=PLPuNhh82sRgljBFnwgASb0x5ZNhBheHY8&ab_channel=CodingQuests) to initially learn about Godot and already implement some functionalities for a fundamental RTS Game. The Code for that is saved on my own Github account: [CdFerneding/RTSGame](https://github.com/CdFerneding/RTSGame)
  
Through this youtube tutorial I was able to add a health bar, drag selection, learn about signals, order of nodes in the scene tree and groups.  

On Drag Selection: The basics of what is happening: I am using the Godot "Input" inside the `camera.gd/process` function to register the left-click mouse input and set the `isDragging` variable to true. This variable is toggled to false when the left mouse button is released.

While the left-click is held (`if isDragging == true`), a rectangle is dynamically drawn from the initial mouse click position to the current mouse position. The key here is the distance check (`startV.distance_to(mousePos) > 20`), which ensures that a drag action is occurring and not just a simple click. If the mouse has moved significantly (more than 20 pixels), it signifies a deliberate drag, triggering the rectangle drawing logic.

When the left-click is released, the final rectangle is drawn, and its coordinates are emitted through a signal to the `main.gd` code, which manages the selection.

The `draw_area` function handles the mathematical calculations for drawing the rectangle, offering a visual representation of the selection. This process is designed for clarity and ease of understanding, though it may be even clearer with pen and paper.


drag selection in [camera.gd](Scripts/Data/camera.gd#L135):
<pre>
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
</pre>
logic behind farming wood in [tree.gd](Scripts/WorldObjects/tree.gd#L15):
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

variables in [Game.gd](Scripts/Data/Game.gd#L53):
<pre>
# training Queues
var pikachuQueue = []
var fireQueue = []
var waterQueue = []
var plantQueue = []
</pre>
implementation in [TrainIcon.gd](/Scripts/GUI/TrainIcon.gd#L13):
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
Inside [check_evolution](/Scripts/Entities/charmander.gd#L37) function:
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
[UI.gd](/Scripts/GUI/UI.gd#L277):
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
in [pikachu.gd](/Scripts/Entities/pikachu.gd#L56)
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
Adding sprites for the enemies, creating selection boxes, writing dialogue (which is not really code in my opinion) and playing it in the game, creating a start-/win-/loose-game HUD, menu and settings with editable music volume

## Bad code
### Consolidation of Pokemon Code
Problem:
Before addressing the enemies, there was redundant code for three different "BigBadPokemon." While Max and Evan initially created separate scripts, the realization came that the code was essentially identical, differing only in animations and Pokemon attributes.

Solution:
To enhance code clarity and maintainability, we consolidated the code into a single script. Although this approach slightly impacts efficiency due to conditional statements for sprite animations, it significantly improves code overview and cleanliness. A similar consolidation approach could be applied to military Pokemon (e.g., Bulbasaur, Squirtle, Charmander) to promote consistency and ease of future modifications.

### Naming Conventions Oversight
Problem:
Naming conventions for variables and functions were not discussed during our initial meeting, leading to inconsistent patterns throughout the repository. For instance, variables were named in camelCase, functions in snake_case (Godot functions with an underscore), and constants in UPPER CASE. While this inconsistency currently doesn't pose a major issue, it may become problematic as the project scales.

Solution:
While acknowledging the oversight, we decided not to retroactively modify existing names due to the project's current state. However, it's essential to recognize that in larger projects, inconsistent naming conventions could pose challenges for developers, especially newcomers. Going forward, we commit to adhering to a unified naming convention to ensure better code maintainability.  

Example from [camera.gd](/Scripts/Data/camera.gd#L16):  
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

### Unused Delta variable / elapsed time since last frame
We have basically not used the delta variable of all the different processes functions.  This may have led to drawbacks in terms of gameplay smoothness, frame rate independence, and overall performance.  
This oversight can lead to significant drawbacks in terms of gameplay smoothness, frame rate independence, and overall
performance.  
Godot 4 most likely implements delta time independence for the nodes because of which the animation are working the same on all devices.  
The delta time could have been used to optimized the Game. 

## Refleciton
### Implemented Concepts
Concepts I have implemented are the following:  
Unit selection, event handling, queue management, pause game functionality, use of constants, evolution / upgrade mechanisms / unit state, sprite animation.  

### Playtesting
While playtesting I noticed the music (which is often too loud / changes volume when playing on different devices / platforms) and some other things not working as expected which has led me to newfound respect for all developers who make their game accessible on multiple platforms.  

### Unit balancing 
Due to little time we did not nearly have enough time to playtest and therefore balancing. I updated the initial enemies health and attack values based on game time to match the military pokemon of the player wich can be made stronger (through the laboratory) than the original enemies.  
However we did not nearly have enough time to finetune the statistics (which can be seen in the Game Design file).  

### Key concepts learned in the duration of the Game Progarmming course
I will not consider wether I learned the following concepts during the lectures, through simply using a Game Enginge or by research as it really does not matter to me.   
1. Game Loop:  
	The Game loop is represented in Godot 4 through the _process(delta) function (even though we mostly didn't use the delta function).  
2. Physics Simulation  
	This is implemented in Godot 4 mainly through collision shaped as a child node of different world objects.  
3. Input Handling  
	Implementing User Input is very beginner friendly in Godot as developers can always ceck "Input.[...]" as well as the very easy to use "signals". 
4. Artificial Intelligence  
	Referring to the enemies and the military pokemon who search for the nearest enemy and attack them
5. Sound effects and music
6. User Interface  
	In Godot this section is reserved for specific nodes (which are tecnically not the only nodes able to display UI but are made by Godot especially for this purpose), e.g. "CanvasLayer". 
7. Optimisation and performance
8. Version Control
	In our groups case the version control was git.

## Video
Video about groups, pausing the game, the Dialogue Manager, public scripts and event trigger in Godot (signals)  
[See Video Godot Intern Funcitonalities](Documentation/Conrad_Ferneding_Personal_Report_Assets/video_for_interface_documentation.mp4) 
