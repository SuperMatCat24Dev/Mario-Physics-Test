extends Area2D

func _on_body_entered(body: Node2D) -> void:
	SoundPlayer.play_sound("Coin")
	queue_free()
	Public.coins += 1
	Public.score += 100
