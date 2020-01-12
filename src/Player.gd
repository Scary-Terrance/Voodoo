extends KinematicBody2D

# Exports for editor
export var gravity = 128
export var max_jump = -128
export var move_speed = 64

# Constants
const UP = Vector2(0, -1)

# Player variables
var velocity = Vector2(0, 0)
var direction = 0
var jumping = false

#onready var animation_player : AnimationPlayer = 

func _apply_gravity(delta):
	velocity.y += gravity * delta
	
func _apply_movement(delta):
	_apply_gravity(delta)
	velocity.x = lerp(velocity.x, move_speed * direction, 0.25)
	if direction != 0:
		pass #$Body.scale.x = direction
	velocity = move_and_slide(velocity, UP)

