extends "res://src/StateMachine.gd"

# Called when asset loaded into scene
func _ready():
	add_state("idle")
	add_state("walk")
	call_deferred("set_state", states.idle)

# Handle all logic based on current state
func _state_logic(delta):
	# Apply Gravity for the Player
	parent._apply_gravity(delta)
	parent._apply_movement()
	

# Handle logic to determine if we should change state
func _get_transition(delta):
	match state:
		states.idle:
			pass
		states.walk:
			pass

func _enter_state(new_state, old_state):
	match new_state:
		states.idle:
			pass
			#parent.animation_player.play("idle")
		states.walk:
			pass
			#parent.animation_player.play("idle")
