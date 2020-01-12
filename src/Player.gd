extends KinematicBody2D

onready var animation_player = $Player_AnimationPlayer

# Exports for editor
export var gravity = 320
export var max_jump = -224
export var move_speed = 96

# Constants
const UP = Vector2(0, -1)

# Player variables
var velocity = Vector2(0, 0)
var direction = 0
var double_jump = true

#onready var animation_player : AnimationPlayer = 

func _apply_gravity(delta):
	velocity.y += gravity * delta
	
func _apply_movement(delta):
	_apply_gravity(delta)
	velocity.x = lerp(velocity.x, move_speed * direction, 0.25)
	if direction == -1:
		$Sprite.flip_h = true
	elif direction == 1:
		$Sprite.flip_h = false
	velocity = move_and_slide(velocity, UP)

