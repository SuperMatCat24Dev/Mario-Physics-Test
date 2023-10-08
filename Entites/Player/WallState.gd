extends CharacterState

@export var wall_jump_speed := 200
@export var wall_slide_speed := 200
@export var wall_friction := 400

var wall_normal : Vector2
# Called when the state machine enters this state.
func on_enter() -> void:
	character.triplejump = 0


# Called every frame when this state is active. 
func on_process(delta: float) -> void:
	character.velocity.y = move_toward(character.velocity.y, wall_slide_speed, wall_friction * delta)
	character.play_animation("WallSlide")


# Called every physics frame when this state is active.
func on_physics_process(delta: float) -> void:
	var direction := Input.get_axis("Left", "Right")
	character.velocity.x = direction * 10
	character.move_and_slide()
	wall_normal = character.get_wall_normal()
	character.flip_sprite(wall_normal.x < 0)
	if not character.is_on_wall_only():
		change_state("FallState")


# Called when there is an input event while this state is active.
func on_input(event: InputEvent) -> void:
	if event.is_action_pressed("Jump"):
		handle_wall_jump()

# Called when the state machine exits this state.
func on_exit() -> void:
	pass

func handle_wall_jump():
	character.velocity.x = wall_normal.x * wall_jump_speed
	change_state("JumpState")
