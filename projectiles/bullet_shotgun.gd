extends RigidBody2D
var lifetime = .2

func _ready():
	await get_tree().create_timer(lifetime).timeout
	queue_free()
