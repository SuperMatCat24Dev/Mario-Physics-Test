extends CharacterBody2D
class_name Player

@onready var sprite_animations: AnimationPlayer = $SpriteAnimations
@onready var sprite: Sprite2D = $Sprite

var triplejump = 0
var triplejumpbypass = false

var dead := false
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

func play_animation(anim, speed_scale = 1):
	sprite_animations.play(anim)
	sprite_animations.speed_scale = speed_scale
	await sprite_animations.animation_finished
	return true

func flip_sprite(flip):
	sprite.flip_h = flip

func hurt(dmg):
	if dead: return
	if not $HitFlash.is_playing():
		$HitFlash.play("Flash")
		Public.health -= dmg
		if Public.health <= 0:
			die()

func die():
	dead = true
	$FiniteStateMachine.process_mode = Node.PROCESS_MODE_DISABLED
	$HitFlash.play("RESET")
	await play_animation("Die")
	Public.lives -= 1
	Public.health = Public.maxhealth
	await Transitions.transition("DiagIn")
	await get_tree().reload_current_scene()
	Transitions.transition("DiagOut")
	Public.reset()

func bounce(multi):
	%SpriteAnimations.play("Jump")
	if Input.is_action_pressed("Jump"):
		velocity.y = %JumpState.jump_velocity * multi
	else:
		velocity.y = %JumpState.jump_velocity / 1.5 * multi
	$FiniteStateMachine.change_state("FallState")
