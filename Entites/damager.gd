extends Area2D

@export var bounce := false
@export var damage := 1
@export var bouncemulti := 1.15

func _process(delta: float) -> void:
	for bodies in get_overlapping_bodies():
		if bounce:
			if bodies.velocity.y > 0:
				if owner.has_method("hurt"):
					owner.hurt(1)
				bodies.bounce(bouncemulti)
			else:
				if bodies.has_method("hurt"):
					bodies.hurt(damage)
		else:
			if bodies.has_method("hurt"):
				bodies.hurt(damage)


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	process_mode = Node.PROCESS_MODE_INHERIT


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
