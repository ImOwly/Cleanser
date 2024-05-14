extends Node2D

var rng = RandomNumberGenerator.new()
var can_fire = true
var bullet_speed = 500
var fire_rate_spray = 0.1
var fire_rate_shotgun = 0.5
var fire_rate_rifle = 1

# firing_angle_variation is the an angle in radians that the bullet is off by (divide by 2)
# 45° ~ 0.785398
# 90° ~ 1.5708
# 180° ~ 3.14159
var firing_angle_variation = 0.10472
var bullet_speed_variation = 100

enum Gun_Types {shotgun, rifle, spraygun}
var current_gun = Gun_Types.spraygun

@onready var spray = preload("res://projectiles/spray.tscn")
@onready var bullet_rifle = preload("res://projectiles/bullet_rifle.tscn")
@onready var bullet_shotgun = preload("res://projectiles/bullet_shotgun.tscn")
@onready var cursor = preload("res://assets/sprites/spray.png")

func _ready():
	can_fire = true

func _input(event):
	if (event is InputEventMouseButton and event.pressed):
		if event.button_index == MOUSE_BUTTON_RIGHT:
			print(current_gun)
			current_gun = (current_gun + 1) % 3

func _process(delta):
	look_at(get_global_mouse_position())
	
	#When left-mouse is held down
	if Input.is_mouse_button_pressed(1) and can_fire:
		#$GPUParticles2D.emitting = true
		match current_gun:
			Gun_Types.spraygun:
				spray_gun()
			Gun_Types.shotgun:
				shotgun()
			Gun_Types.rifle:
				rifle()
	
func rifle():
	fire_bullet(0, bullet_speed*3, bullet_rifle)
	fire_delay(fire_rate_rifle)
	
func shotgun():
	fire_bullet(0, bullet_speed*2, bullet_shotgun)
	var spread = 0.105
	for i in range(0, 2):
		fire_bullet(-spread, bullet_speed*2, bullet_shotgun)
		fire_bullet(spread, bullet_speed*2, bullet_shotgun)
	fire_delay(fire_rate_shotgun)
	
func spray_gun():
	fire_multiple_bullets(spray, 2)
	await get_tree().create_timer(.02).timeout
	fire_multiple_bullets(spray, 1)
	await get_tree().create_timer(.03).timeout
	fire_multiple_bullets(spray, 2)
	fire_delay(fire_rate_spray)
	
func fire_multiple_bullets(bullet, x):
	for i in range(0, x):
		var offset = rng.randf_range(-firing_angle_variation, firing_angle_variation)
		var velocity = bullet_speed + rng.randf_range(-bullet_speed_variation, bullet_speed_variation)
		velocity = abs(velocity)
		fire_bullet(offset, velocity, bullet)
	
func fire_bullet(offset, velocity, bullet):
	var bullet_instance = bullet.instantiate()
	bullet_instance.position = $GunBarrel.get_global_position()
	bullet_instance.rotation_degrees = rotation_degrees
	bullet_instance.apply_impulse(Vector2(velocity, 0).rotated(rotation-offset))
	get_tree().get_root().add_child(bullet_instance)
	
func fire_delay(time):
	can_fire = false
	await get_tree().create_timer(time).timeout
	can_fire = true
