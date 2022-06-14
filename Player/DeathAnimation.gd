extends AnimatedSprite


var enemies 
var player
func _ready():
	
	
# warning-ignore:return_value_discarded
	get_parent().connect("death_anim", self, "play_animation")
	
func play_animation():
	enemies = get_tree().get_root().get_node(PlayerData.player_data["Player"]["World"]).get_node("YSort/Bat").get_children()
	for enemy in enemies:
		enemy.get_node("PlayerDetectionZone/CollisionShape2D").set_deferred("disabled", true)
		enemy.get_node("Hitbox/CollisionShape2D").set_deferred("disabled", true)
	$".".visible = true
	$".".play("Death")
	get_parent().get_node("Hurtbox/CollisionShape2D").set_deferred("disabled", true)

func _on_DeathAnimation_animation_finished():
	
	$".".visible = false
	PlayerData.can_save = true
	get_parent().get_node("Sprite").visible = true
	get_parent().get_node("ShadowSprite").visible = true
	PlayerStats.health = PlayerStats.max_health
	$".".stop()
	get_parent().get_node("Sprite").offset.y = 0
	PlayerData.dead = false
	get_parent().global_position = PlayerData.checkpoint
	$Timer.start(0.5)
	

func _on_Timer_timeout():
	$Timer.stop()
	for enemy in enemies:
		enemy.get_node("PlayerDetectionZone/CollisionShape2D").set_deferred("disabled", false)
		enemy.get_node("Hitbox/CollisionShape2D").set_deferred("disabled", false)
	get_parent().get_node("Hurtbox/CollisionShape2D").set_deferred("disabled", false)
