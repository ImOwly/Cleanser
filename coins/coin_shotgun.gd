extends Area2D
var turnedRight = false
@onready var animation_player = $AnimationPlayer

func _process(delta):
	if !turnedRight:
		animation_player.play("move_right")
		await get_tree().create_timer(.85).timeout
		turnedRight = true
	else:
		animation_player.play("move_left")
		await get_tree().create_timer(.85).timeout
		turnedRight = false
		
func _on_body_entered(body):
	if body.is_in_group("Player"):
		body.unlock_shotgun()
		queue_free()
