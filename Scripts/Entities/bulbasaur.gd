extends MilitaryPokemon

class_name Bulbasaur

signal bulbasaur_clicked

# handling evolution differences
@export var evolution = 0

@export var selected = false 
@onready var box = $BulbasaurSelected


func _ready():
	animationSprite = $bulbasaur
	animationSprite.animation = "walk_down"
	var main_node = get_tree().get_root().get_node("Main")
	$PlayerNavigationAgent.target_position = position
	connect("bulbasaur_clicked", Callable(main_node, "_on_bulbasaur_clicked"))
	type = PokemonType.GRASS
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
	check_evolution()



func check_evolution():
	# check current evolution of charmander and enable / disable according boxes, shapes and sprites
	if evolution == 0:
		attack_damage = Game.BULBASAUR_ATTACK
		$HealthBar.max_value = Game.BULBASAUR_HEALTH
		$bulbasaur.visible = true
		$CollisionShapeBulbasaur.visible = true
		animationSprite = $bulbasaur
		box = $BulbasaurSelected
		## disable charmeleon and charizard sprites
		$ivysaur.visible = false
		$venusaur.visible = false
		## disable collision shapes
		$CollisionShapeIvysaur.visible = false
		$CollisionShapeVenusaur.visible = false
		## disable selection boxes
		$IvysaurSelected.visible = false
		$VenusaurSelected.visible = false
	elif evolution == 1:
		attack_damage = Game.IVYSAUR_ATTACK
		$HealthBar.max_value = Game.IVYSAUR_HEALTH
		$ivysaur.visible = true
		$CollisionShapeIvysaur.visible = true
		animationSprite = $ivysaur
		box = $IvysaurSelected
		## disable charmander and charizard
		$bulbasaur.visible = false
		$venusaur.visible = false
		## disable collision shapes
		$CollisionShapeBulbasaur.visible = false
		$CollisionShapeVenusaur.visible = false
		## disable selection boxes
		$BulbasaurSelected.visible = false
		$VenusaurSelected.visible = false
	else:
		attack_damage = Game.VENUSAUR_ATTACK
		$HealthBar.max_value = Game.VENUSAUR_HEALTH
		$venusaur.visible = true
		$CollisionShapeVenusaur.visible = true
		animationSprite = $venusaur
		box = $VenusaurSelected
		## diable charmander and charmeleon
		$bulbasaur.visible = false
		$ivysaur.visible = false
		## disable collision shapes
		$CollisionShapeBulbasaur.visible = false
		$CollisionShapeIvysaur.visible = false
		## disable selection boxes
		$BulbasaurSelected.visible = false
		$IvysaurSelected.visible = false
		
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
		emit_signal("bulbasaur_clicked", self)
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
