extends Area2D

@export var Area := "Overworld"
@export var Music := "Overworld"

func _on_body_entered(body: Node2D) -> void:
	Hud.current_music = Music
	Hud.show_area(Area)
