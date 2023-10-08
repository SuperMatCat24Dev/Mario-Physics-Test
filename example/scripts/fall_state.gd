extends CharacterState
class_name FallState

enum {WALK, TURN, STOP}
var substate = WALK

@onready var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var fallspeed = 20

@export var maxfallspeed: float = 300.0
@export var acceleration: float = 300.0
@export var deacceleration: float = 300.0
@export var turnacceleration: float = 300.0

var speed: float = 100.0

func on_enter() -> void:
	if Input.is_action_pressed("Run"):
		speed = %RunState.speed
	else:
		speed = %WalkState.speed

func on_input(event: InputEvent) -> void:
	if event.is_action_pressed("Run"):
		speed = %RunState.speed
	if event.is_action_released("Run"):
		speed - %WalkState.speed
	if event.is_action_pressed("Down"):
		change_state("PoundState")

# Called every frame when this state is active.
func on_process(delta: float) -> void:
	var direction := Input.get_axis("Left", "Right")
	
	substate_check(direction)
	move(delta, direction)
	
	character.velocity.y += gravity * delta
	if character.velocity.y >= 0:
		character.velocity.y += fallspeed
	if character.velocity.y >= maxfallspeed:
		character.velocity.y = maxfallspeed
	
	if Input.is_action_just_pressed("Jump"):
		if $"../../CoyoteTimer".time_left != 0:
			change_state("JumpState")
		else:
			$"../../BufferTimer".start()

# Called every physics frame when this state is active.
func on_physics_process(_delta: float) -> void:
	character.move_and_slide()
	if not %SpriteAnimations.current_animation == "DoubleJump" and not %SpriteAnimations.current_animation == "Spin":
		character.play_animation("Jump")
	handle_wall_slide()
	if character.is_on_floor():
		$"../../TripleJumpTimer".start()
		change_state("WalkState")

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

func handle_wall_slide():
	if not character.is_on_wall_only(): return
	var wall_normal = character.get_wall_normal()
	if wall_normal != Vector2.ZERO:
		change_state("WallState")
