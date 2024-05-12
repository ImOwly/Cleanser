extends CharacterBody2D

@export var SPEED: int = 155
@export var GRAVITY: int = 900
@export var JUMP_FORCE : int = 355

func _physics_process(delta):
	var direction = Input.get_axis("move_left" , "move_right")
	if direction:
		velocity.x = direction * SPEED
	
	#not moving scenario
	else:
		velocity.x = 0
		
	#gravity
	if not is_on_floor():
		velocity.y += GRAVITY * delta
		
	#jump
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y -= JUMP_FORCE
		
	move_and_slide()
