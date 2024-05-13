extends Node2D

var bullet_speed = 1000
var fire_rate = .1
var can_fire = true

@onready var bullet = preload("res://bullet/bullet.tscn")
@onready var cursor = preload("res://assets/sprites/bullet.png")

func _ready():
	can_fire = true

func _process(delta):
	look_at(get_global_mouse_position())
	
	#When left-mouse is held down
	if Input.is_mouse_button_pressed(1):
		
		#GPUParticles2D
		#$GPUParticles2D.emitting = true
		
		#bullets
		if can_fire:
			var bullet_instance = bullet.instantiate()
			bullet_instance.position = $GunBarrel.get_global_position()
			bullet_instance.rotation_degrees = rotation_degrees
			bullet_instance.apply_impulse(Vector2(bullet_speed, 0).rotated(rotation))
			get_tree().get_root().add_child(bullet_instance)
			can_fire = false
			await get_tree().create_timer(fire_rate).timeout
			can_fire = true
		
		
	else:
		
		#GPUParticles2D
		$GPUParticles2D.emitting = false
