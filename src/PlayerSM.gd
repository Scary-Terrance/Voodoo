extends "res://src/StateMachine.gd"

# Called when asset loaded into scene
func _ready():
	add_state("idle")
	add_state("run")
	add_state("jump")
	add_state("fall")
	call_deferred("set_state", states.idle)

func _input(event):
	if [states.idle, states.run].has(state):
		if event.is_action_pressed("jump"):
			parent.velocity.y = parent.max_jump
		if event.is_action_pressed("left"):
			parent.direction = -1
			if event.is_action_pressed("right"):
				parent.direction = 0
		elif event.is_action_released("left"):
			parent.direction = 0
		if event.is_action_pressed("right"):
			parent.direction = 1
			if event.is_action_pressed("left"):
				parent.direction = 0
		elif event.is_action_released("right"):
			parent.direction = 0

# Handle all logic based on current state
func _state_logic(delta):
	# Apply all movement for the player
	parent._apply_movement(delta)

# Handle logic to determine if we should change state
func _get_transition(delta):
	match state:
		states.idle:
			if !parent.is_on_floor():
				if parent.velocity.y < 0:
					return states.jump
				elif parent.velocity.y > 0:
					return states.fall
			elif parent.velocity.x != 0:
				return states.run
		states.run:
			pass
		states.jump:
			if parent.is_on_floor():
				return states.idle
			elif parent.velocity.y >= 0:
				return states.fall
		states.fall:
			if parent.is_on_floor():
				return states.idle
			elif parent.velocity.y < 0:
				return states.jump

func _enter_state(new_state, old_state):
	match new_state:
		states.idle:
			parent.animation_player.play("idle")
		states.run:
			parent.animation_player.play("idle")
