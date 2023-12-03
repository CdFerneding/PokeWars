extends MilitaryPokemon

class_name Charmander

signal charmander_clicked

# handling evolution differences
@export var evolution = 0
@export var selected = false 
@onready var box = $CharmanderSelected

func _ready():
	type = PokemonType.FIRE
	animationSprite = $charmander
	animationSprite.animation = "walk_down"
	var main_node = get_tree().get_root().get_node("Main")
	$PlayerNavigationAgent.target_position = position
	connect("charmander_clicked", Callable(main_node, "_on_charmander_clicked"))
	
	# super initializes the healthbar 
	super()
	
	set_selected(false)
	# check evolution level and apply corresponding sprite
	check_evolution()


func _process(_delta:float):
	if Game.is_paused:
		return
	
	charmander_scale_on_hover()
		

# Setter-Funktion for evolution var
func set_evolution(value: int) -> void:
	# var is only allowed to be 0,1 or 2
	evolution = clamp(value, 0, 2)

func check_evolution():
	# check current evolution of charmander and enable / disable according boxes, shapes and sprites
	if evolution == 0:
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
		$charmeleon.visible = true
		$CollisionShapeCharmeleon.visible = true
		animationSprite = $charmeleon
		box = $CharmeleonSelected
		## disable charmander and charizard
		$charmander.visible = false
		$charizard.visible = false
		## disable collision shapes
		$CollisionShapeCharmander.visible = false
		$CollisionShapeCharizard.visible = false
		## disable selection boxes
		$CharmanderSelected.visible = false
		$CharizardSelected.visible = false
	else:
		$charizard.visible = true
		$CollisionShapeCharizard.visible = true
		animationSprite = $charizard
		box = $CharizardSelected
		## diable charmander and charmeleon
		$charmander.visible = false
		$charmeleon.visible = false
		## disable collision shapes
		$CollisionShapeCharmander.visible = false
		$CollisionShapeCharmeleon.visible = false
		## disable selection boxes
		$CharmanderSelected.visible = false
		$CharmeleonSelected.visible = false

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
		emit_signal("charmander_clicked", self)
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
		pathMain.bulbasaurs.erase(self)
		self.queue_free()
		pathMain.get_units()
		if self in pathMain.selected_pokemon:
			pathMain.selected_pokemon.erase(self)
			Game.Selected = pathMain.selected_pokemon.size()
		# decrease friendly unit counter
		Game.friendlyUnits -= 1
		if Game.friendlyUnits == 0:
			Game.trigger_loose_game()
			
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
