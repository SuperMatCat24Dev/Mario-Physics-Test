class_name WalkState
extends BaseState

func on_enter() -> void:
	if Input.is_action_pressed("Run"):
		change_state("RunState")

func on_input(event: InputEvent) -> void:
	if event.is_action_pressed("Run"):
		change_state("RunState")
