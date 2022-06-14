extends KinematicBody2D

const PlayerHurtSound = preload("res://Player/PlayerHurtSound.tscn")
export var ACCELERATION = 500
export var MAX_SPEED = 80
export var FRICTION = 500
export var ROLL_SPEED = 120
export(int) var health_regen = 1
export(int) var energy_regen = 1
export(int) var health_regen_time = 12
export(int) var energy_regen_time = 6
export (Vector2) var player_spawn_location = Vector2.ZERO

enum { #enumeration
	MOVE, #c'est le premier donc = 0
	ROLL
}

var state = MOVE
var velocity = Vector2.ZERO
var roll_vector = Vector2.DOWN
var stats = PlayerStats
var energyTimer = null
var healthTimer = null


signal death_anim

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var swordHitbox = $AnimatedSprite/Hitbox
onready var hurtbox = $Hurtbox 
onready var blinkAnimationPlayer = $BlinkAnimationPlayer



var i = 0
func _ready():

	randomize()
	self.global_position = Global.player_initial_map_position
	set_blend_position(Global.player_facing_direction)
	
	if PlayerData.changing_map != true and PlayerData.player_data["Player"]["Position_x"] != null and PlayerData.player_data["Player"]["Position_y"] != null:
		self.global_position = Vector2(PlayerData.player_data["Player"]["Position_x"],PlayerData.player_data["Player"]["Position_y"])
		
	stats.connect("no_health", self, "death")

	animationTree.active = true
	swordHitbox.knockback_vector = roll_vector
	blinkAnimationPlayer.play("Stop")
	
	energyTimer = get_node("EnergyTimer")
	energyTimer.set_wait_time(energy_regen_time)
	
	
	energyTimer.start()
	
	healthTimer = get_node("HealthTimer")
	healthTimer.set_wait_time(health_regen_time)
	
	
	healthTimer.start()
	
	
		
#PLAYER MOVEMENT
func _physics_process(delta):
	
	PlayerData.player_data["Player"]["Position_x"] = position.x
	PlayerData.player_data["Player"]["Position_y"] = position.y
	
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			roll_state()

	
		
	if $PickupZone.items_in_range.size() > 0:
		var pickup_item = $PickupZone.items_in_range.values()[0]
		pickup_item.pick_up_item(self)
		$PickupZone.items_in_range.erase(pickup_item)


func move_state(delta):
	
	
	var input_vector = Vector2.ZERO
	input_vector.x= Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y= Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	var mousePos = $".".get_local_mouse_position().normalized()
	
		
	if PlayerData.inventory_open == false:
		if PlayerData.dead != true:	
			if input_vector != Vector2.ZERO:
				roll_vector = input_vector
				swordHitbox.knockback_vector = input_vector
				
				animationTree.set("parameters/Idle/blend_position", mousePos)
				animationTree.set("parameters/Run/blend_position", mousePos)
				#animationTree.set("parameters/Attack/blend_position", mousePos)
				animationTree.set("parameters/Roll/blend_position", input_vector)
				animationState.travel("Run")
				velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
				
			else:
				animationState.travel("Idle")
				velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			
			move()
			if PlayerData.hotbar_data[str(PlayerData.active_item_slot + 1)]["Item"] != null:
				if str(GameData.item_data[str(PlayerData.hotbar_data[str(PlayerData.active_item_slot + 1)]["Item"])]["Category"]) == "Weapon":
					swordHitbox.damage =  GameData.item_data[str(PlayerData.hotbar_data[str(PlayerData.active_item_slot + 1)]["Item"])]["Attack"]
					if Input.is_action_just_pressed("attack"):
						$AnimatedSprite.frame = 0
						attack()
				elif str(GameData.item_data[str(PlayerData.hotbar_data[str(PlayerData.active_item_slot + 1)]["Item"])]["Name"]) == "Healing Potion":
					if Input.is_action_just_pressed("attack"):
						
						var hp = stats.health + int(GameData.item_data[str(PlayerData.hotbar_data[str(PlayerData.active_item_slot + 1)]["Item"])]["PotionHealth"])
						if stats.health != stats.max_health:
							if hp > stats.max_health:
								
								stats.health = stats.max_health
								AddItem.item_used()
							else:
								AddItem.item_used()
								stats.health = hp
						
				elif str(GameData.item_data[str(PlayerData.hotbar_data[str(PlayerData.active_item_slot + 1)]["Item"])]["Name"]) == "Mana Potion":
					if Input.is_action_just_pressed("attack"):
						var mana = stats.energy + int(GameData.item_data[str(PlayerData.hotbar_data[str(PlayerData.active_item_slot + 1)]["Item"])]["PotionMana"])
						if stats.energy != stats.max_energy:
							if mana > stats.max_energy:
								
								stats.energy = stats.max_energy
								AddItem.item_used()
							else:
								AddItem.item_used()
								stats.energy = mana

			if stats.energy > 0:	 
				if Input.is_action_just_pressed("roll"):
					state = ROLL
					stats.energy -= 1
	elif PlayerData.inventory_open == true:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
func roll_state():
	velocity= roll_vector * ROLL_SPEED
	animationState.travel("Roll")
	move()
	
func move():
	velocity = move_and_slide(velocity)	
	
func roll_animation_finished():
	velocity = velocity * 0.8
	state = MOVE
	
func attack_animation_finished():
	
	state = MOVE
	
	
	
func set_blend_position(direction):
	if direction != Vector2.ZERO:
		animationTree.set("parameters/Idle/blend_position", direction)
		
func attack():
	$AnimatedSprite.visible =true
	$AnimatedSprite.play()
	$AnimatedSprite/Hitbox/CollisionShape2D.set_deferred("disabled", false)
func _on_Hurtbox_area_entered(area):
	
	var armor = PlayerData.player_armor()
	
	var damage = 0
	if PlayerData.dead != true:
		if armor !=0:
			damage = area.damage/armor
		else:
			damage = area.damage
		stats.health -= damage
	
		hurtbox.start_invincibilty(0.6)
		hurtbox.create_hit_effect()
		var playerHurtSound = PlayerHurtSound.instance()
		get_tree().current_scene.add_child(playerHurtSound)



func _on_Hurtbox_invincibility_started():
	blinkAnimationPlayer.play("Start")


func _on_Hurtbox_invincibility_ended():
	blinkAnimationPlayer.play("Stop")



func _on_EnergyTimer_timeout():
	if stats.energy < stats.max_energy:
		stats.energy += energy_regen
		

func _on_HealthTimer_timeout():
	if stats.health < stats.max_health:
		stats.health += health_regen
	if stats.health > stats.max_health:
		stats.health = stats.max_health

		
func death():
	
	health_regen = 0
	PlayerData.dead = true
	$Sprite.visible = false
	$ShadowSprite.visible = false
	
	emit_signal("death_anim")
	$Checkpoint.start(2)
	
func _on_Checkpoint_timeout():
	$Checkpoint.stop()
	animationPlayer.stop()
	
