extends CharacterBody2D

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	move_and_slide()

func _on_area_2d_body_entered(body: Player) -> void:
	if body.velocity.y > 0:
		body.bounce(1.35)
		$AnimationPlayer.play("bounce")
