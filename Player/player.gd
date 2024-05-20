extends CharacterBody2D

@export var SPEED: int = 155
@export var GRAVITY: int = 900
@export var JUMP_FORCE : int = 355
@onready var animated_sprite_2d = $AnimatedSprite2D

func _physics_process(delta):
	var direction = Input.get_axis("move_left" , "move_right")
	if direction == 1:
		animated_sprite_2d.play("walk")
		animated_sprite_2d.flip_h = false
	elif direction == -1:
		animated_sprite_2d.flip_h = true
		animated_sprite_2d.play("walk")

	if direction:
		velocity.x = direction * SPEED
	
	#not moving scenario
	else:
		animated_sprite_2d.stop()
		velocity.x = 0
		
	#gravity
	if not is_on_floor():
		velocity.y += GRAVITY * delta
		
	#jump
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y -= JUMP_FORCE
		
	move_and_slide()

func hit():
	get_tree().change_scene_to_file("res://game_over.tscn")

func unlock_rifle():
	self.find_child("GunManager").unlock_rifle()
	
func unlock_shotgun():
	self.find_child("GunManager").unlock_shotgun()
