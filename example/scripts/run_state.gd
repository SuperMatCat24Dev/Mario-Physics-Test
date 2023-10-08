class_name RunState
extends BaseState


func on_input(event: InputEvent) -> void:
	if event.is_action_released("Run"):
		change_state("WalkState")
