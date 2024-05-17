extends RigidBody2D
var lifetime = 2

func _ready():
	await get_tree().create_timer(lifetime).timeout
	queue_free()

func _on_body_entered(body):
	if body.is_in_group("Map"):
		queue_free()
	if body.is_in_group("Player"):
		body.hit()
		queue_free()
	if body.is_in_group("Enemy"):
		pass
