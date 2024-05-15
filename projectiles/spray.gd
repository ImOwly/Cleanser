extends RigidBody2D
var lifetime = .7
var colors = [Color(0.0, 255.0, 255.0, 1.0), 
			Color("06c3dd", 1.0), 
			Color("24909f", 1.0),
			Color("5e23dc", 1.0)]

func _ready():
	randomize()
	modulate = colors[randi() % colors.size()]
	await get_tree().create_timer(lifetime).timeout
	queue_free()
