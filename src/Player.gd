extends KinematicBody2D

# Exports for editor
export var gravity = 9.8
export var max_jump = 50

# Constants
const UP = Vector2(0, -1)

# Player variables
var velocity = Vector2()
#onready var animation_player : AnimationPlayer = 

func _apply_gravity(delta):
	# Apply gravity
	velocity.y += gravity * delta
	
func _apply_movement():
	velocity = move_and_slide(velocity)
