extends CharacterState

var direction = 0

# Called when the state machine enters this state.
func on_enter() -> void:
	direction = Input.get_axis("Left", "Right")
	if direction != 0:
		character.flip_sprite(direction < 0)


# Called every frame when this state is active.
func on_process(delta: float) -> void:
	var dir : int
	if $"../../Sprite".flip_h == true: dir = 1
	else: dir = -1
	character.play_animation("Spin", character.velocity.x / 80 * dir * -1)


func on_physics_process(delta: float) -> void:
	character.velocity.x = move_toward(character.velocity.x, 0, 200 * delta)
	character.move_and_slide()
	if not character.is_on_floor():
		change_state("FallState")
	if abs(character.velocity.x) <= 20:
		change_state("WalkState")


# Called when there is an input event while this state is active.
func on_input(event: InputEvent) -> void:
	if event.is_action_pressed("Jump"):
		change_state("JumpState")
		character.velocity.x *= 1.2
		
		if character.velocity.x > 250:
			character.velocity.x = 250
		elif character.velocity.x <= -250:
			character.velocity.x = -250

# Called when the state machine exits this state.
func on_exit() -> void:
	pass

