extends KinematicBody2D

# Onready variables for nodes
onready var animation_player = $AnimationPlayer
onready var left_wall = $WallRaycasts/LeftWallRaycasts
onready var right_wall = $WallRaycasts/RightWallRaycasts

# Exports for editor
export var gravity = 320
export var max_jump = -224
export var move_speed = 128
export var wall_jump_speed = 64
export var h_weight = 0.25

# Constants
const UP = Vector2(0, -1)

# Player variables
var velocity = Vector2(0, 0)
var direction = 0
var wall_direction = 0
var double_jump = true

func _apply_gravity(delta):
	velocity.y += gravity * delta

func _h_movement():
	velocity.x = lerp(velocity.x, move_speed * direction, h_weight)
	if direction == -1:
		$Sprite.flip_h = true
	elif direction == 1:
		$Sprite.flip_h = false

func _update_wall_direction():
	var is_wall_left = _check_is_valid_wall(left_wall)
	var is_wall_right = _check_is_valid_wall(right_wall)
	if is_wall_left && is_wall_right:
		wall_direction = direction
	else:
		wall_direction = -int(is_wall_left) + int(is_wall_right)

# Check if a wall is able to be jumped on	
func _check_is_valid_wall(wall_raycasts):
	for raycast in wall_raycasts.get_children():
		if raycast.is_colliding():
			# acos for radians, detect a wall collision
			var dot = acos(Vector2.UP.dot(raycast.get_collision_normal()))
			# Check that walls arent sloped or too steep like a roof angle
			if dot > PI * 0.35 && dot < PI * 0.55:
				return true
	return false
	
func _apply_movement():
	velocity = move_and_slide(velocity, UP)

