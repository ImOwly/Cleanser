extends CharacterBody2D

const SPEED = 100
const ATTACK_DISTANCE = 170
var maxCollision = 6
var isAttacking = false
var isStunned = false
var attack_time = .5
var stun_time = 1
var can_turn = true
@onready var ray_cast_left = $RayCastLeft
@onready var ray_cast_right = $RayCastRight
@onready var ray_cast_up = $RayCastUp
@onready var ray_cast_edge_left = $RayCastEdgeLeft
@onready var ray_cast_edge_right = $RayCastEdgeRight
@onready var animation_player = $AnimationPlayer
@onready var player = get_parent().get_node("CharacterBody2D")
@export var GRAVITY: int = 100
@export var JUMP_FORCE : int = 50
enum {
	PASSIVE,
	ATTACK,
	STUNNED
}
var state = PASSIVE
var direction = 1
var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	
func isFacingLeft():
	if direction < 0:
		return true
	return false

func line_of_sight(player):
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(position, player.position)
	var result = space_state.intersect_ray(query)
	if result and result.collider_id == player.get_instance_id():
		return true
	return false

func update_State():
	var distance_to_target = position.distance_to(player.position)
	var x_distance = position.x - player.position.x
	var y_distance = position.y - player.position.y
	if !isAttacking:
		if isStunned:
			state = STUNNED
		elif !line_of_sight(player):
			state = PASSIVE
		elif distance_to_target > (ATTACK_DISTANCE):
			state = PASSIVE
		elif distance_to_target < (ATTACK_DISTANCE):
			if ((isFacingLeft() and x_distance > 0) or (!isFacingLeft() and x_distance < 0)) and abs(y_distance) < 14:
				state = ATTACK
				attack_delay(attack_time)
			else:
				state = PASSIVE
	
func randomly_negative(x):
	if (rng.randi_range(0, 1) == 0):
		return -x
	return x
	
func hit():
	queue_free()
	
func attack_delay(time):
	isAttacking = true
	await get_tree().create_timer(time).timeout
	isAttacking = false
	
func stun_delay(time):
	isStunned = true
	await get_tree().create_timer(time).timeout
	isStunned = false
	
func turn_delay(time):
	can_turn = false
	await get_tree().create_timer(time).timeout
	can_turn = true
	
func _process(delta):
	
	update_State()
	
	velocity.x = direction * SPEED
	if !is_on_floor():
		velocity.y += GRAVITY * delta
	var isLeft = isFacingLeft()
	match state:
		PASSIVE:
			if isLeft:
				animation_player.play("idleLeft")
			elif !isLeft:
				animation_player.play("idleRight")
			
			if ray_cast_left.is_colliding():
				var collision = ray_cast_right.get_collider()
				if !collision or !collision.is_in_group("Bullet"):
					direction = 1
					animation_player.play("idleRight")
			elif ray_cast_right.is_colliding():
				var collision = ray_cast_right.get_collider()
				if !collision or !collision.is_in_group("Bullet"):
					direction = -1
					animation_player.play("idleLeft")
			elif is_on_floor() and (!ray_cast_edge_left.is_colliding() or !ray_cast_edge_right.is_colliding()) and can_turn:
				turn_delay(.1)
				direction = -direction
			
			if isFacingLeft() and ray_cast_right.is_colliding():
					var collision = ray_cast_right.get_collider()
					if collision.is_in_group("Player"):
						collision.hit()
						return
			if !isFacingLeft() and ray_cast_left.is_colliding():
					var collision = ray_cast_left.get_collider()
					if collision.is_in_group("Player"):
						collision.hit()
						return
			if ray_cast_up.is_colliding():
					var collision = ray_cast_up.get_collider()
					if collision.is_in_group("Player"):
						collision.hit()
						return
			
			velocity.x += direction * SPEED * delta
			move_and_slide()
		ATTACK:
			velocity.x = 0
			if(isLeft):
				animation_player.play("prepareRight")
			else:
				animation_player.play("prepareLeft")
			
			if(isLeft):
				animation_player.play("attackLeft")
				velocity.x = -1 * SPEED	* 8
				if ray_cast_left.is_colliding():
					var collision = ray_cast_left.get_collider()
					if collision.is_in_group("Map"):
						isStunned = true
						stun_delay(stun_time)
						isAttacking = false
					if collision.is_in_group("Player"):
						collision.hit()
						return
			else:
				animation_player.play("attackRight")
				velocity.x = 1 * SPEED	* 8
				if ray_cast_right.is_colliding():
					var collision = ray_cast_right.get_collider()
					if collision.is_in_group("Map"):
						isStunned = true
						stun_delay(stun_time)
						isAttacking = false
					if collision.is_in_group("Player"):
						collision.hit()
						return
			move_and_slide()
		STUNNED:
			pass
