extends Area2D

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Up") and visible:
		get_tree().paused = true

func _on_area_entered(area: Area2D) -> void:
	visible = true

func _on_area_exited(area: Area2D) -> void:
	visible = false
