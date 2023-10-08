extends CharacterState

@onready var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var dive_speed := 250
# Called when the state machine enters this state.
func on_enter() -> void:
	character.play_animation("Dive")
	var direction := Input.get_axis("Left", "Right")
	if direction:
		speed_cap(dive_speed, direction)
	elif $"../../Sprite".flip_h == true: 
		speed_cap(dive_speed, -1)
	else: 
		speed_cap(dive_speed, 1)
	await get_tree().process_frame
	flip()
	character.velocity.y = -125


# Called every frame when this state is active.
func on_process(delta: float) -> void:
	character.velocity.y += gravity * delta


# Called every physics frame when this state is active.
func on_physics_process(delta: float) -> void:
	character.move_and_slide()
	if character.is_on_floor():
		change_state("RollState")
	elif character.is_on_wall():
		change_state("FallState")

# Called when there is an input event while this state is active.
func on_input(event: InputEvent) -> void:
	pass

# Called when the state machine exits this state.
func on_exit() -> void:
	pass

func speed_cap(amount, dir):
	if abs(character.velocity.x) < amount:
		character.velocity.x = amount * dir
	

func flip():
	if character.velocity.x < 0:
		character.flip_sprite(true)
	else:
		character.flip_sprite(false)
