extends AnimatedSprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$"Hitbox/CollisionShape2D".set_deferred("disabled", true)



func _process(_delta):
	if PlayerData.inventory_open == false:
		$".".look_at(get_global_mouse_position()) 
		$".".offset.x = 20
		
		


func _on_AnimatedSprite_animation_finished():
	$"Hitbox/CollisionShape2D".set_deferred("disabled", true)
	$".".frame = 0
	$".".stop()
