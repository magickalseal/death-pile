extends KinematicBody2D


const GRAVITY = 150
const SPEED = 100
const JUMP_HEIGHT = 5000
const JUMP_SPEED = 200
const COLLISION_IMPULSE_MULTIPLIER = 10

enum State {NORMAL, DEAD, JUMPING, FALLING}

var corpse_scene = preload("res://characters/corpse/corpse.tscn")

var jumped_distance = 0
var spawn_altar
var spawn_cross
var respawn_falling_mark
var status = State.NORMAL


func _physics_process(delta):
	if respawn_falling_mark and is_under(respawn_falling_mark.position):
		spawn_player()
		status = State.NORMAL
	
	if status == State.DEAD:
		jumped_distance = 0
		respawn_player()
		return
	
	if status == State.NORMAL and Input.is_action_just_pressed("player_jump"):
		status = State.JUMPING
	elif status == State.JUMPING and jumped_distance >= JUMP_HEIGHT:
		jumped_distance = 0
		status = State.FALLING
	elif status == State.FALLING and is_on_floor():
		status = State.NORMAL
	
	
	var velocity = Vector2()
	if Input.is_action_pressed("player_left"):
		velocity.x = -SPEED
	elif Input.is_action_pressed("player_right"):
		velocity.x = SPEED
	else:
		velocity.x = 0
	
	if status == State.JUMPING:
		velocity.y = -JUMP_SPEED
		jumped_distance += JUMP_SPEED
	elif !is_on_floor():
		velocity.y = GRAVITY
	else:
		velocity.y = 0
	
	move_and_slide(velocity, Vector2(0, -1), false, 4, 0.785398, false)
	
	var last_collision = get_last_slide_collision()
	if (last_collision and last_collision.collider is RigidBody2D):
		var modified_x_impulse = (
			last_collision.remainder.x * COLLISION_IMPULSE_MULTIPLIER
		)
		var horizontal_impulse = Vector2(modified_x_impulse, 0)
		print(str(last_collision.normal) + " " + str(last_collision.remainder) + " " + str(last_collision.travel))
		last_collision.collider.apply_central_impulse(horizontal_impulse)


func spawn_corpse(corpse_position: Vector2):
	var new_corpse = corpse_scene.instance()
	new_corpse.position = corpse_position
	get_parent().add_child(new_corpse)


func spawn_player():
	if spawn_cross:
		position = spawn_cross.position
	elif spawn_altar:
		position = spawn_altar.position
	else:
		print("ERROR: No Spawn Point defined.")


func respawn_player():
	var death_position = position
	
	spawn_player()
	spawn_corpse(death_position)
	
	status = State.NORMAL


func set_spawn_altar(new_spawn_altar: Node2D):
	spawn_altar = new_spawn_altar


func set_respawn_falling_mark(new_respawn_falling_mark: Node2D):
	respawn_falling_mark = new_respawn_falling_mark

func die():
	status = State.DEAD


func is_under(coordinate: Vector2) -> bool:
	var distance_coordinate_to_player = (
		Vector2(0,-1).dot(position)
		+ coordinate.y
	)
	
	if distance_coordinate_to_player < 0:
		return true
	else:
		return false
