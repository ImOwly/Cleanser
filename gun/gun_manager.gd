extends Node2D

var rng = RandomNumberGenerator.new()
var can_fire = true
var bullet_speed = 500
var fire_rate_spray = 0.1
var fire_rate_shotgun = 0.5
var fire_rate_rifle = 1
var fire_rate_pistol = .9

# firing_angle_variation is the an angle in radians that the bullet is off by (divide by 2)
# 45° ~ 0.785398
# 90° ~ 1.5708
# 180° ~ 3.14159
var firing_angle_variation = 0.10472
var bullet_speed_variation = 100

enum Gun_Types {shotgun, rifle, spraygun, pistol}
var selected_gun = Gun_Types.spraygun
var current_gun
var gen_gun = true
var owned_guns = []
var flip_sprite

# Bullets
@onready var spray = preload("res://projectiles/spray.tscn")
@onready var bullet_rifle = preload("res://projectiles/bullet_rifle.tscn")
@onready var bullet_shotgun = preload("res://projectiles/bullet_shotgun.tscn")
@onready var bullet_pistol = preload("res://projectiles/bullet_pistol.tscn")

# Guns
@onready var spraygun = preload("res://gun/spraygun.tscn")
@onready var rifle = preload("res://gun/rifle.tscn")
@onready var shotgun = preload("res://gun/shotgun.tscn")
@onready var pistol = preload("res://gun/pistol.tscn")


func _ready():
	current_gun = spraygun.instantiate()
	can_fire = true
	$SprayButton.visible = false
	$ShotgunButton.visible = false
	$RifleButton.visible = false
	$PistolButton.visible = false
	owned_guns.append(Gun_Types.spraygun)
	owned_guns.append(Gun_Types.pistol)

func _input(event):
	if (event is InputEventMouseButton and event.pressed):
		if event.button_index == MOUSE_BUTTON_RIGHT:
			toggle_gun_menu()

func _process(delta):
	
	generate_gun()
	current_gun.position = Vector2(3,8)
	current_gun.look_at(get_global_mouse_position())
	
	if (get_global_mouse_position().x < global_position.x):
		current_gun.find_child("GunSprite").flip_v = true
		flip_sprite = true
	else:
		current_gun.find_child("GunSprite").flip_v = false
		flip_sprite = false
	
	#When left-mouse is held down
	if Input.is_mouse_button_pressed(1) and can_fire:
		match selected_gun:
			Gun_Types.spraygun:
				fire_spray_gun()
			Gun_Types.shotgun:
				fire_shotgun()
			Gun_Types.rifle:
				fire_rifle()
			Gun_Types.pistol:
				fire_pistol()
	
func generate_gun():
	if gen_gun:
		gen_gun = false
		add_child(current_gun)
	
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
	
func fire_pistol():
	fire_bullet(0, bullet_speed/2, bullet_pistol)
	fire_delay(fire_rate_pistol)
	
func fire_multiple_bullets(bullet, x):
	for i in range(0, x):
		var offset = rng.randf_range(-firing_angle_variation, firing_angle_variation)
		var velocity = bullet_speed + rng.randf_range(-bullet_speed_variation, bullet_speed_variation)
		velocity = abs(velocity)
		fire_bullet(offset, velocity, bullet)

func fire_bullet(offset, velocity, bullet):
	var bullet_instance = bullet.instantiate()
	var barrel_local_position = current_gun.find_child("GunBarrel").get_global_position() - self.get_global_position()
	if flip_sprite:
		barrel_local_position = current_gun.find_child("GunBarrelFlipped").get_global_position() - self.get_global_position()
	bullet_instance.position = barrel_local_position
	bullet_instance.rotation_degrees = current_gun.rotation_degrees
	bullet_instance.apply_impulse(Vector2(velocity, 0).rotated(current_gun.rotation-offset))
	add_child(bullet_instance)
	queue_redraw()
	
func fire_delay(time):
	can_fire = false
	await get_tree().create_timer(time).timeout
	can_fire = true

func toggle_gun_menu():
	generate_menu()
	if (!$SprayButton.visible):
		for gun in owned_guns:
			match gun:
				Gun_Types.spraygun:
					$SprayButton.visible = true
				Gun_Types.shotgun:
					$ShotgunButton.visible = true
				Gun_Types.rifle:
					$RifleButton.visible = true
				Gun_Types.pistol:
					$PistolButton.visible = true
	else:
		$SprayButton.visible = false
		$ShotgunButton.visible = false
		$RifleButton.visible = false
		$PistolButton.visible = false
		
func generate_menu():
	for i in range(1, len(owned_guns)+1):
		var start_rads = (TAU/2 * (i - 1)) / (len(owned_guns))
		var end_rads = (TAU/2 * i) / (len(owned_guns))
		var mid_rads = (start_rads + end_rads) / 2.0 * -1
		var radious = 30
		var offset = Vector2(-9,-9)
		var icon_pos = radious * Vector2.from_angle(mid_rads) + offset
		match owned_guns[i-1]:
			Gun_Types.spraygun:
				$SprayButton.position = icon_pos
			Gun_Types.shotgun:
				$ShotgunButton.position = icon_pos
			Gun_Types.rifle:
				$RifleButton.position = icon_pos
			Gun_Types.pistol:
				$PistolButton.position = icon_pos
		
func _on_spray_button_button_down():
	can_fire = false
	selected_gun = Gun_Types.spraygun
	current_gun.queue_free()
	current_gun = spraygun.instantiate()
	add_child(current_gun)
	toggle_gun_menu()
	can_fire = true

func _on_shotgun_button_button_down():
	can_fire = false
	selected_gun = Gun_Types.shotgun
	current_gun.queue_free()
	current_gun = shotgun.instantiate()
	add_child(current_gun)
	toggle_gun_menu()
	can_fire = true

func _on_rifle_button_button_down():
	can_fire = false
	selected_gun = Gun_Types.rifle
	current_gun.queue_free()
	current_gun = rifle.instantiate()
	add_child(current_gun)
	toggle_gun_menu()
	can_fire = true

func _on_pistol_button_button_down():
	can_fire = false
	selected_gun = Gun_Types.pistol
	current_gun.queue_free()
	current_gun = pistol.instantiate()
	add_child(current_gun)
	toggle_gun_menu()
	can_fire = true
	
func unlock_rifle():
	if !owned_guns.has(Gun_Types.rifle):
		owned_guns.append(Gun_Types.rifle)
	
func unlock_shotgun():
	if !owned_guns.has(Gun_Types.shotgun):
		owned_guns.append(Gun_Types.shotgun)
