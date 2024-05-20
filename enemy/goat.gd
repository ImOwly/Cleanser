extends CharacterBody2D

const SPEED = 60
const BUFFER = 10
const ATTACK_DISTANCE = 120
var collisionCount = 0
var maxCollision = 6
var alreadyAttacked = false
@onready var ray_cast_left = $RayCastLeft
@onready var ray_cast_right = $RayCastRight
@onready var animation_player = $AnimationPlayer
@onready var player = get_parent().get_node("CharacterBody2D")
@export var GRAVITY: int = 100
@export var JUMP_FORCE : int = 50
enum {
	PASSIVE,
	ATTACK,
}
var state = PASSIVE
var direction = 1
var rng = RandomNumberGenerator.new()
var randomNum = 1


func _ready():
	rng.randomize()
	randomNum = rng.randf()
	
func isFacingRight():
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
	if !line_of_sight(player):
		state = PASSIVE
	elif distance_to_target > (ATTACK_DISTANCE + BUFFER):

		state = PASSIVE
	elif distance_to_target < (ATTACK_DISTANCE - BUFFER):
		if alreadyAttacked == true:
			await get_tree().create_timer(3.0).timeout
		state = ATTACK
		alreadyAttacked = false
	else:
		await get_tree().create_timer(3.0).timeout
		state = ATTACK
		alreadyAttacked = false
	
func randomly_negative(x):
	if (rng.randi_range(0, 1) == 0):
		return -x
	return x
	
func hit():
	queue_free()
	
func _process(delta):
	collisionCount=0
	update_State()
	
	velocity.x = direction * SPEED
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	var isRight = isFacingRight()
	match state:
		PASSIVE:
			if isRight:
				animation_player.play("idleLeft")
			elif !isRight:
				animation_player.play("idleRight")
			
			if ray_cast_left.is_colliding():
				direction = 1
				animation_player.play("idleRight")
			if ray_cast_right.is_colliding():
				direction = -1
				animation_player.play("idleLeft")
			
			velocity.x += direction * SPEED * delta
			move_and_slide()
		ATTACK:
			velocity.x = 0
			if(isRight):
				animation_player.play("prepareRight")
			else:
				animation_player.play("prepareLeft")
			
			if(isRight):
				animation_player.play("attackLeft")
				velocity.x = -1 * SPEED	* 8
				alreadyAttacked = true
				if ray_cast_left.is_colliding():
					var collision = ray_cast_left.get_collider()
					if collision.is_in_group("Player"):
						collision.hit()
						return
			else:
				animation_player.play("attackRight")
				velocity.x = 1 * SPEED	* 8
				alreadyAttacked = true
				if ray_cast_right.is_colliding():
					var collision = ray_cast_right.get_collider()
					if collision.is_in_group("Player"):
						collision.hit()
						return
				
			move_and_slide()
