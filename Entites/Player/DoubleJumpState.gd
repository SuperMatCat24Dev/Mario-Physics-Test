extends JumpState

func on_enter() -> void:
	character.velocity.y = jump_velocity
	character.play_animation("DoubleJump")
