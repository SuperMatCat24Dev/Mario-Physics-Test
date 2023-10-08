extends CharacterState

@export var pound_speed = 300

var can_cancel := false
var dive_safe := false
var large_jump := false

# Called when the state machine enters this state.
func on_enter() -> void:
	large_jump = false
	dive_safe = false
	can_cancel = false
	character.velocity.y = 0
	await character.play_animation("GroundPound", 1.8)
	if dive_safe: return
	can_cancel = true
	character.velocity.y = pound_speed


# Called every frame when this state is active.
func on_process(delta: float) -> void:
	if $PoundTimer.time_left == 0 and character.is_on_floor():
		change_state("WalkState")


# Called every physics frame when this state is active.
func on_physics_process(delta: float) -> void:
	character.velocity.x = move_toward(character.velocity.x, 0, 1000 * delta)
	character.move_and_slide()
	if character.is_on_floor() and not large_jump:
		SoundPlayer.play_sound("Bump")
		$PoundTimer.start()
		large_jump = true


# Called when there is an input event while this state is active.
func on_input(event: InputEvent) -> void:
	if event.is_action_pressed("Up") and can_cancel:
		change_state("FallState")
	elif event.is_action_pressed("Jump") and large_jump:
		character.triplejumpbypass = true
		character.triplejump = 2
		change_state("JumpState")

# Called when the state machine exits this state.
func on_exit() -> void:
	character.velocity.y /= 4
