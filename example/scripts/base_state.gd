class_name BaseState
extends CharacterState

enum {WALK, TURN, STOP}
var substate = WALK

@export var speed: float = 300.0
@export var acceleration: float = 300.0
@export var deacceleration: float = 300.0
@export var turnacceleration: float = 300.0

var jump_state = 0

func on_enter() -> void:
	if character.find_child("BufferTimer").time_left != 0:
		change_state("JumpState")

# Called every frame when this state is active.
func on_process(delta: float) -> void:
	# Basic movement
	var direction := Input.get_axis("Left", "Right")
	
	substate_check(direction)
	move(delta, direction)
	
	# Change to jump state
	if Input.is_action_just_pressed("Jump"):
		change_state("JumpState")
	elif  Input.is_action_pressed("Down"):
		change_state("CrouchState")
	# Update animation
	if substate == TURN:
		character.play_animation("Turn")
	elif substate == WALK:
		character.play_animation("Walk", character.velocity.x / 65)
	elif abs(character.velocity.x) <= 25:
		character.play_animation("Idle")
	
	if direction != 0:
		character.flip_sprite(direction < 0)
	
	if not character.is_on_floor():
		change_state("FallState")
		character.find_child("CoyoteTimer").start()

# Called every physics frame when this state is active.
func on_physics_process(_delta: float) -> void:
	character.move_and_slide()
	if character.find_child("TripleJumpTimer").time_left == 0:
		character.triplejump = 0


func substate_check(dir):
	if dir == 1 and character.velocity.x >= 0 or dir == -1 and character.velocity.x <= 0:
		substate = WALK
	elif dir == 0:
		substate = STOP
	elif dir <= 1 and character.velocity.x >= 1 or dir >= -1 and character.velocity.x <= -1:
		substate = TURN

func move(delta, dir):
	match substate:
		WALK:
			character.velocity.x = move_toward(character.velocity.x, speed * dir, acceleration * delta)
		STOP:
			character.velocity.x = move_toward(character.velocity.x, 0, deacceleration * delta)
		TURN:
			character.velocity.x = move_toward(character.velocity.x, speed * dir, turnacceleration * delta)
