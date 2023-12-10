extends MilitaryPokemon

class_name Squirtle

signal squirtle_clicked

# handling evolution differences
@export var evolution = 0
@export var selected = false 
@onready var box = $SquirtleSelected

func _ready():
	type = PokemonType.WATER
	animationSprite = $squirtle
	animationSprite.animation = "walk_down"
	var main_node = get_tree().get_root().get_node("Main")
	$PlayerNavigationAgent.target_position = position
	connect("squirtle_clicked", Callable(main_node, "_on_squirtle_clicked"))
	
	# super initializes the healthbar 
	super()
	
	set_selected(false)
	# check evolution level and apply corresponding sprite
	check_evolution()


func _process(_delta:float):
	if Game.is_paused:
		animationSprite.pause()
		return
	animationSprite.play()
	
	charmander_scale_on_hover()

func check_evolution():
	# check current evolution of charmander and enable / disable according boxes, shapes and sprites
	if evolution == 0:
		attack_damage = Game.SQUIRTLE_ATTACK
		$HealthBar.max_value = Game.SQUIRTLE_HEALTH
		$squirtle.visible = true
		$CollisionShapeSquirtle.visible = true
		animationSprite = $squirtle
		box = $SquirtleSelected
		## disable charmeleon and charizard sprites
		$wartortle.visible = false
		$blastoise.visible = false
		## disable collision shapes
		$CollisionShapeWartortle.visible = false
		$CollisionShapeBlastoise.visible = false
		## disable selection boxes
		$WartortleSelected.visible = false
		$BlastoiseSelected.visible = false
	elif evolution == 1:
		attack_damage = Game.WARTORTLE_ATTACK
		$HealthBar.max_value = Game.WARTORTLE_HEALTH
		$wartortle.visible = true
		$CollisionShapeWartortle.visible = true
		animationSprite = $wartortle
		box = $WartortleSelected
		## disable charmander and charizard
		$squirtle.visible = false
		$blastoise.visible = false
		## disable collision shapes
		$CollisionShapeSquirtle.visible = false
		$CollisionShapeBlastoise.visible = false
		## disable selection boxes
		$SquirtleSelected.visible = false
		$BlastoiseSelected.visible = false
	else:
		attack_damage = Game.BLASTOISE_ATTACK
		$HealthBar.max_value = Game.BLASTOISE_HEALTH
		$blastoise.visible = true
		$CollisionShapeBlastoise.visible = true
		animationSprite = $blastoise
		box = $BlastoiseSelected
		## diable charmander and charmeleon
		$squirtle.visible = false
		$wartortle.visible = false
		## disable collision shapes
		$CollisionShapeSquirtle.visible = false
		$CollisionShapeWartortle.visible = false
		## disable selection boxes
		$SquirtleSelected.visible = false
		$WartortleSelected.visible = false
		
	$HealthBar.value = $HealthBar.max_value

func _on_mouse_entered():
	if Game.is_paused:
		return
	pok_hover = true
	set_selected(true)

func _on_mouse_exited():
	if Game.is_paused:
		return
	pok_hover = false
	set_selected(false)

func set_selected(value):
	selected = value
	box.visible = value

func _char_hover_selected_check(_event):
	if Game.is_paused:
		return
	if pok_hover and Input.is_action_pressed("left_click"):
		emit_signal("squirtle_clicked", self)
		pok_hover = false
		
	# leftclick on "nothing" to deselect units
	elif Input.is_action_pressed("left_click"):
		pok_hover = false


func charmander_scale_on_hover() -> void:
	if pok_hover:
		self.scale.x = 0.6
		self.scale.y = 0.6

	else:
		self.scale.x = 0.5
		self.scale.y = 0.5

func _on_input_event(_viewport, event, _shape_idx):
	if Game.is_paused:
		return
	if pok_hover:
		_char_hover_selected_check(event)

# function to reduce charmanders health, number damage is reducted from charmanders health_bar
func _on_hit(damage, type):
	if Game.is_paused:
		return
	var pathMain = get_tree().get_root().get_node("Main")
	damage = calculateDamage(damage, type)
	health_bar.value -= damage
	if health_bar.value == 0:
		pathMain.squirtles.erase(self)
		self.queue_free()
		pathMain.get_friendly_units()
		if self in pathMain.selected_pokemon:
			pathMain.selected_pokemon.erase(self)
			Game.Selected = pathMain.selected_pokemon.size()
			
func _on_retarget_timer_timeout():
	if Game.is_paused:
		return
	self.call_thread_safe("retarget")

func change_gamemode():
	if mode == AttackModeEnum.ATTACK:
		mode = AttackModeEnum.STILL
	elif mode == AttackModeEnum.STILL:
		mode = AttackModeEnum.ATTACK


func _on_area_2d_area_entered(area):
	is_fighting = true


func _on_area_2d_area_exited(area):
	is_fighting = false
