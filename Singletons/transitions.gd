extends CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func transition(name:String):
	animation_player.play(name)
	await animation_player.animation_finished
	return true
