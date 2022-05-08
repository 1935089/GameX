extends Camera2D


onready var topLeft = $Limits/TopLeft
onready var bottomRight = $Limits/BottomRight

func _ready():
	limit_top = topLeft.position.y
	limit_left = topLeft.position.x
	limit_bottom = bottomRight.position.y
	limit_right = bottomRight.position.x






func _on_World2_tree_entered():
	GameManager.initialise_player()


func _on_World_tree_entered():
	GameManager.initialise_player()
