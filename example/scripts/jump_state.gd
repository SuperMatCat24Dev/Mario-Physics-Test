class_name JumpState
extends CharacterState

enum {WALK, TURN, STOP}
var substate = WALK

@onready var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var jump_velocity = -400

@export var speed: float = 300.0
@export var acceleration: float = 300.0
@export var deacceleration: float = 300.0
@export var turnacceleration: float = 300.0

var anim = 0

func on_enter() -> void:
	if Input.is_action_pressed("Run"):
		speed = %RunState.speed
	else:
		speed = %WalkState.speed
	
	if character.triplejump == 1:
		character.velocity.y = jump_velocity
		SoundPlayer.play_sound("Jump")
		anim = 1
	elif character.triplejump == 2:
		character.velocity.y = jump_velocity * 1.15
		SoundPlayer.play_sound("Jump", 1.125)
		anim = 2
	else:
		character.triplejump = 1
		character.velocity.y = jump_velocity * 1.22
		SoundPlayer.play_sound("Jump", 1.25)
		anim = 3
	
	character.triplejump += 1
	if not character.triplejumpbypass:
		if %FiniteStateMachine.previous_state == %RunState and abs(character.velocity.x) >= %RunState.speed - 50:
			character.triplejump += 1
		else:
			character.triplejump = 1
	
	character.velocity.y -= abs(character.velocity.x) / 6
	character.triplejumpbypass = false
	
	call_deferred("animate")

func on_input(event: InputEvent) -> void:
	if event.is_action_pressed("Run"):
		speed = %RunState.speed
	if event.is_action_released("Run"):
		speed - %WalkState.speed
	if event.is_action_pressed("Down"):
		change_state("PoundState")
	elif event.is_action_pressed("Dive"):
		change_state("DiveState")

# Called every frame when this state is active.
func on_process(delta: float) -> void:
	var direction := Input.get_axis("Left", "Right")
	
	substate_check(direction)
	move(delta, direction)
	
	if not Input.is_action_pressed("Jump"):
		if character.triplejump == 1:
			character.velocity.y /= 1.85
		elif character.triplejump == 2:
			character.velocity.y /= 1.65
		elif character.triplejump == 3:
			character.velocity.y /= 1.5
		change_state("FallState")
	if character.is_on_floor():
		change_state("WalkState")
	character.velocity.y += gravity * delta
	if character.velocity.y >= 10.0:
		change_state("FallState")

# Called every physics frame when this state is active.
func on_physics_process(_delta: float) -> void:
	character.move_and_slide()
	ceiling_detection()

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
			if character.velocity.x > speed or character.velocity.x < -speed: return
			character.velocity.x = move_toward(character.velocity.x, speed * dir, acceleration * delta)
		STOP:
			character.velocity.x = move_toward(character.velocity.x, 0, deacceleration * delta)
		TURN:
			character.velocity.x = move_toward(character.velocity.x, speed * dir, turnacceleration * delta)

func ceiling_detection():
	var realvelocity = character.velocity
	if $"../../Middle".is_colliding(): return
	if $"../../LeftFar".is_colliding():
		if $"../../LeftFar".get_collision_normal() != Vector2.DOWN: return
		for i in range(6):
			character.global_position.x += 1
			character.move_and_slide()
			if not $"../../LeftFar".is_colliding():
				character.velocity = realvelocity
				break
	elif $"../../RightFar".is_colliding():
		if $"../../RightFar".get_collision_normal() != Vector2.DOWN: return
		for i in range(6):
			character.global_position.x += -1
			character.move_and_slide()
			if not $"../../RightFar".is_colliding():
				character.velocity = realvelocity
				break

func animate():
	print(anim)
	if anim == 1:
		character.play_animation("Jump")
	elif anim == 2:
		character.play_animation("DoubleJump")
	else:
		character.play_animation("Spin", 1.5)
