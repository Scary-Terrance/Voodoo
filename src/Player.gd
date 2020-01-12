extends KinematicBody2D

# Exports for editor
export var gravity = 9.8

# Constants
const UP = Vector2(0, -1)

# Player variables
var velocity = Vector2()

func _apply_gravity(delta):
	# Apply gravity
	velocity.y += gravity * delta
	
func _apply_movement():
	velocity = move_and_slide(velocity)
