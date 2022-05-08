
extends KinematicBody2D

const PlayerHurtSound = preload("res://Player/PlayerHurtSound.tscn")
export var ACCELERATION = 500
export var MAX_SPEED = 80
export var FRICTION = 500
export var ROLL_SPEED = 120
export(int) var health_regen = 1
export(int) var energy_regen = 1
export(int) var health_regen_time = 8
export(int) var energy_regen_time = 3
enum { #enumeration
	MOVE, #c'est le premier donc = 0
	ROLL, # = 1
	ATTACK # = 3
}

var state = MOVE
var velocity = Vector2.ZERO
var roll_vector = Vector2.DOWN
var stats = PlayerStats
var energyTimer = null
var healthTimer = null

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var swordHitbox = $HitboxPivot/SwordHitbox
onready var hurtbox = $Hurtbox 
onready var blinkAnimationPlayer = $BlinkAnimationPlayer


var inventory_resource = load("res://Inventory/Inventory.gd")
var inventory = inventory_resource.new()

func _ready():
	
	randomize()
	self.global_position = Global.player_initial_map_position
	set_blend_position(Global.player_facing_direction)

	stats.connect("no_health", self, "queue_free")

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
	
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			roll_state()
		ATTACK:
			attack_state()
	if $PickupZone.items_in_range.size() > 0:
		var pickup_item = $PickupZone.items_in_range.values()[0]
		pickup_item.pick_up_item(self)
		$PickupZone.items_in_range.erase(pickup_item)


func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x= Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y= Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
		
	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		swordHitbox.knockback_vector = input_vector
		
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationTree.set("parameters/Roll/blend_position", input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
		
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		
	move()
	
	if Input.is_action_just_pressed("attack"):
		state= ATTACK
	if stats.energy > 0:	 #si le joueur a mouin que 10 d'energie il ne peut plus role
		if Input.is_action_just_pressed("roll"):
			state = ROLL
			stats.energy -= 1
			
			
func roll_state():
	velocity= roll_vector * ROLL_SPEED
	animationState.travel("Roll")
	move()

func attack_state():
	
	animationState.travel("Attack")

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
		
		
func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	
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
		
