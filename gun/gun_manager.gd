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
var selected_gun = Gun_Types.spraygun
var current_gun
var gen_gun = true

@onready var spray = preload("res://projectiles/spray.tscn")
@onready var bullet_rifle = preload("res://projectiles/bullet_rifle.tscn")
@onready var bullet_shotgun = preload("res://projectiles/bullet_shotgun.tscn")
@onready var shotgun = preload("res://gun/shotgun.tscn")
@onready var rifle = preload("res://gun/rifle.tscn")
@onready var spraygun = preload("res://gun/spraygun.tscn")

func _ready():
	current_gun = spraygun.instantiate()
	can_fire = true
	$SprayButton.visible = false
	$ShotgunButton.visible = false
	$RifleButton.visible = false

func _input(event):
	if (event is InputEventMouseButton and event.pressed):
		if event.button_index == MOUSE_BUTTON_RIGHT:
			toggle_gun_menu()

func _process(delta):
	generate_gun()
	current_gun.position = self.get_global_position()
	current_gun.look_at(get_global_mouse_position())
	
	#When left-mouse is held down
	if Input.is_mouse_button_pressed(1) and can_fire:
		match selected_gun:
			Gun_Types.spraygun:
				fire_spray_gun()
			Gun_Types.shotgun:
				fire_shotgun()
			Gun_Types.rifle:
				fire_rifle()
	
func generate_gun():
	if gen_gun:
		gen_gun = false
		get_tree().get_root().add_child(current_gun)
	
func fire_rifle():
	fire_bullet(0, bullet_speed*3, bullet_rifle)
	fire_delay(fire_rate_rifle)
	
func fire_shotgun():
	fire_bullet(0, bullet_speed*2, bullet_shotgun)
	var spread = 0.105
	for i in range(0, 2):
		fire_bullet(-spread, bullet_speed*2, bullet_shotgun)
		fire_bullet(spread, bullet_speed*2, bullet_shotgun)
	fire_delay(fire_rate_shotgun)
	
func fire_spray_gun():
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
	bullet_instance.position = current_gun.find_child("GunBarrel").get_global_position()
	bullet_instance.rotation_degrees = current_gun.rotation_degrees
	bullet_instance.apply_impulse(Vector2(velocity, 0).rotated(current_gun.rotation-offset))
	get_tree().get_root().add_child(bullet_instance)
	
func fire_delay(time):
	can_fire = false
	await get_tree().create_timer(time).timeout
	can_fire = true

func toggle_gun_menu():
	if (!$SprayButton.visible or !$ShotgunButton.visible or !$RifleButton.visible):
		$SprayButton.visible = true
		$ShotgunButton.visible = true
		$RifleButton.visible = true
	else:
		$SprayButton.visible = false
		$ShotgunButton.visible = false
		$RifleButton.visible = false
		
func _on_spray_button_button_down():
	selected_gun = Gun_Types.spraygun
	current_gun.queue_free()
	current_gun = spraygun.instantiate()
	get_tree().get_root().add_child(current_gun)
	toggle_gun_menu()
	can_fire = true

func _on_shotgun_button_button_down():
	selected_gun = Gun_Types.shotgun
	current_gun.queue_free()
	current_gun = shotgun.instantiate()
	get_tree().get_root().add_child(current_gun)
	toggle_gun_menu()
	can_fire = true

func _on_rifle_button_button_down():
	selected_gun = Gun_Types.rifle
	current_gun.queue_free()
	current_gun = rifle.instantiate()
	get_tree().get_root().add_child(current_gun)
	toggle_gun_menu()
	can_fire = true
