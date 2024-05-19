extends Area2D
@onready var animation_player = $AnimationPlayer
var turnedRight = false
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
		body.unlock_rifle()
		queue_free()
