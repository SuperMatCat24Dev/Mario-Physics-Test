extends CharacterBody2D

@export var SPEED = 300.0
@export var HEALTH = 1.0
@export var SCORE = 500.0
@export var animation_player : AnimationPlayer

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction := Vector2.LEFT

var move = true

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	if move:
		if direction:
			velocity.x = direction.x * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()
	
	if is_on_wall():
		direction = -direction


func hurt(dmg):
	HEALTH -= dmg
	if HEALTH == 0:
		die()

func die():
	Public.score += SCORE
	move = false
	if animation_player:
		animation_player.play("die")
		call_deferred("set_process_mode", 4)
	else:
		queue_free()
