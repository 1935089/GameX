extends KinematicBody2D


export var ACCELERATION = 500
export var MAX_SPEED = 225
export var FRICTION = 200
export var WANDER_TARGET_RANGE = 4

enum{
	IDLE,
	CHASE
}

var velocity  = Vector2.ZERO

var knockback = Vector2.ZERO

var state = CHASE




onready var playerDetectionZone = $PlayerDetectionZone
onready var animationPlayer = $AnimationPlayer

func _ready():
	state = IDLE
	
func _physics_process(delta):


	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()

		CHASE:
			var player = playerDetectionZone.player
			if player != null:
				accelerate_towards_point(player.global_position,delta)
				var distance = global_position.distance_to(player.global_position)
				
				if distance < 4:
					
					GameManager.player.inventory.add_items("Sword", 1)
					queue_free()
					
			else:
				state = IDLE

			
	velocity = move_and_slide(velocity)


func accelerate_towards_point(position, delta):
	var direction = global_position.direction_to(position)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)

	
func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE



