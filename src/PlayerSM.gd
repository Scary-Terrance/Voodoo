extends "res://src/StateMachine.gd"

# Called when asset loaded into scene
func _ready():
	add_state("idle")
	add_state("run")
	add_state("jump")
	add_state("fall")
	add_state("wall_slide")
	call_deferred("set_state", states.idle)

func _input(event):
	if [states.idle, states.run].has(state):
		if event.is_action_pressed("jump"):
			parent.velocity.y = parent.max_jump
		if event.is_action_pressed("left"):
			parent.direction += -1
		elif event.is_action_released("left"):	
			parent.direction += 1
		if event.is_action_pressed("right"):
			parent.direction += 1
		elif event.is_action_released("right"):
			parent.direction += -1
			
	elif [states.fall, states.jump].has(state):
		# Handle double jump scenario
		if event.is_action_pressed("jump") && parent.double_jump == true:
			parent.velocity.y = parent.max_jump
			parent.double_jump = false
			parent.animation_player.play("jump")
		if event.is_action_pressed("left"):
			parent.direction += -1
		elif event.is_action_released("left"):	
			parent.direction += 1
		if event.is_action_pressed("right"):
			parent.direction += 1
		elif event.is_action_released("right"):
			parent.direction += -1
			
	elif state == states.wall_slide:
		if event.is_action_pressed("jump"):
			parent.velocity.y = parent.max_jump
			parent.direction = -parent.wall_direction
			parent.velocity.x += -parent.wall_direction * parent.move_speed

# Handle all logic based on current state
func _state_logic(delta):
	parent._update_wall_direction()
	parent._apply_gravity(delta)
	parent._h_movement()
	# Apply all movement for the player
	parent._apply_movement()

# Handle logic to determine if we should change state
func _get_transition(delta):
	match state:
		states.idle:
			if !parent.is_on_floor():
				if parent.velocity.y < 0:
					return states.jump
				elif parent.velocity.y > 0:
					return states.fall
			elif parent.direction != 0:
				return states.run
		states.run:
			if !parent.is_on_floor():
				if parent.velocity.y < 0:
					return states.jump
				elif parent.velocity.y > 0:
					return states.fall
			elif parent.direction == 0:
				return states.idle
		states.jump:
			if parent.is_on_floor():
				return states.idle
			elif parent.wall_direction != 0:
				return states.wall_slide
			elif parent.velocity.y >= 0:
				return states.fall
		states.fall:
			if parent.is_on_floor():
				return states.idle
			elif parent.wall_direction != 0:
				return states.wall_slide
			elif parent.velocity.y < 0:
				return states.jump
		states.wall_slide:
			if parent.is_on_floor():
				return states.idle
			elif parent.velocity.x != 0:
				if parent.velocity.y < 0:
					return states.jump
				elif parent.velocity.y >= 0:
					return states.fall

func _enter_state(new_state, old_state):
	match new_state:
		states.idle:
			parent.double_jump = true
			parent.animation_player.play("idle")
		states.run:
			parent.double_jump = true
			parent.animation_player.play("run")
		states.jump:
			parent.animation_player.play("jump")
		states.fall:
			parent.animation_player.play("fall")
		states.wall_slide:
			parent.double_jump = true
			self.flip_h = -parent.wall_direction
			parent.animation_player.play("idle")
			
func _exit_state(old_state, new_state):
	match old_state:
		states.wall_slide:
			parent.direction = 0
