extends CharacterBody2D

var SPEED = 50
const ATTACK_DISTANCE = 80
const BUFFER = 10
const DRIFT_DISTANCE = 100
const DRIFT_TIME = 1
const PAUSE_TIME = 2

var firing_angle_variation = 0.10472
var bullet_speed = 100
var bullet_speed_variation = 0
var fire_rate = 1
var can_fire = true

var rndX
var rndY
var moving = false
var pause = false

var player
var rng = RandomNumberGenerator.new()
@onready var sprite2D = get_node("Sprite2D")
@onready var bullet = preload("res://projectiles/bullet_enemy.tscn")
@onready var animation_player : AnimationPlayer = $AnimationPlayer

var randomnum

enum {
	PASSIVE,
	APPROACH,
	ATTACK,
	DISTANCE,
}

var state = PASSIVE


func _ready():
	player = get_parent().get_node("CharacterBody2D")
	rng.randomize()
	randomnum = rng.randf()

func _physics_process(delta):
	# Check for player object
	if not player:
		return
	
	# Update state
	update_state()
		
	if (can_fire):
		var isRight = isFacingRight()
		match state:
			PASSIVE:
				if !moving and !pause:
					if(isRight):
						animation_player.play("idle_right")
					else:
						animation_player.play("idle_left")
					var screenSize = get_viewport().get_visible_rect().size
					rndX = min(rng.randi_range(0, DRIFT_DISTANCE),screenSize.x)
					rndY = randomly_negative(DRIFT_DISTANCE - rndX)
					rndX = randomly_negative(rndX)
					moving_delay(DRIFT_TIME, PAUSE_TIME)
				if !pause:
					move(self.position + Vector2(rndX, rndY), SPEED, true, delta)
			APPROACH:
				if(isRight):
					animation_player.play("idle_right")
				else:
					animation_player.play("idle_left")
				move(player.position, SPEED, true, delta)
			ATTACK:
				if(isRight):
					animation_player.play("attack_right")
				else:
					animation_player.play("attack_left")
				fire_delay(fire_rate)
				attack()
				await get_tree().create_timer(.1).timeout
				attack()
				await get_tree().create_timer(.1).timeout
				attack()
				await get_tree().create_timer(.1).timeout
				attack()
				await get_tree().create_timer(.1).timeout
				attack()
				await get_tree().create_timer(.1).timeout
			DISTANCE:
				if(isRight):
					animation_player.play("idle_right")
				else:
					animation_player.play("idle_left")
				move(player.position, SPEED, false, delta)
				
func move(target, speed, is_approach, delta):
	var direction = position.direction_to(target)
	if not is_approach:
		direction = -direction
	velocity = direction * speed
	move_and_slide()
	
func moving_delay(move_time, pause_time):
	moving = true
	await get_tree().create_timer(move_time).timeout
	pause = true
	await get_tree().create_timer(pause_time).timeout
	pause = false
	moving = false
	
func isFacingRight():
	var direction = self.position - player.position
	if direction.x < 0:
		return true
	return false 
	
func update_state():
	var distance_to_target = position.distance_to(player.position)
	if !line_of_sight(player):
		state = PASSIVE
	elif distance_to_target > (ATTACK_DISTANCE + BUFFER):
		state = APPROACH
	elif distance_to_target < (ATTACK_DISTANCE - BUFFER):
		state = DISTANCE
	else:
		state = ATTACK
		
func line_of_sight(player):
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(position, player.position)
	var result = space_state.intersect_ray(query)
	if result and result.collider_id == player.get_instance_id():
		return true
	return false
		
func randomly_negative(x):
	if (rng.randi_range(0, 1) == 0):
		return -x
	return x
	
func attack():
	var offset = rng.randf_range(-firing_angle_variation, firing_angle_variation)
	var velocity = bullet_speed + rng.randf_range(-bullet_speed_variation, bullet_speed_variation)
	velocity = abs(velocity)
	fire_bullet(offset, velocity, bullet)

func fire_bullet(offset, velocity, bullet):
	var bullet_instance = bullet.instantiate()
	bullet_instance.position = get_global_position()
	bullet_instance.look_at(player.position)
	var angle = get_angle_to(player.position)
	bullet_instance.apply_impulse(Vector2(velocity, 0).rotated(angle),player.position)
	get_parent().add_child(bullet_instance)
	
func fire_delay(time):
	can_fire = false
	await get_tree().create_timer(time).timeout
	can_fire = true
	
func hit():
	queue_free()
