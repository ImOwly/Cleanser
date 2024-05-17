extends Camera2D

@onready var player = get_parent().get_node("CharacterBody2D")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.position = Vector2(player.position.x, self.position.y)
