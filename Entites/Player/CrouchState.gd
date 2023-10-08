extends CharacterState


# Called when the state machine enters this state.
func on_enter() -> void:
	pass


# Called every frame when this state is active.
func on_process(delta: float) -> void:
	character.play_animation("Crouch")


# Called every physics frame when this state is active.
func on_physics_process(delta: float) -> void:
	character.velocity.x = move_toward(character.velocity.x, 0, 400 * delta)
	character.move_and_slide()
	if not character.is_on_floor():
		change_state("FallState")


# Called when there is an input event while this state is active.
func on_input(event: InputEvent) -> void:
	if event.is_action_pressed("Jump"):
		change_state("JumpState")
	if event.is_action_released("Down"):
		change_state("WalkState")


# Called when the state machine exits this state.
func on_exit() -> void:
	pass

