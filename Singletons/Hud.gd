extends CanvasLayer

@onready var lives: Label = $HBoxContainer/Lives
@onready var coins: Label = $HBoxContainer/Coins
@onready var time: Label = $HBoxContainer/Time
@onready var score: Label = $HBoxContainer/Score
@onready var health: Sprite2D = $HBoxContainer/HealthBar/Sprite2D

var current_music := "Overworld"

var hurry = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_text()
	health.frame = clamp(Public.health, 0, INF)
	music_player()
	

func update_text():
	time.text = "TIME: " + str(round(Public.time_left))
	coins.text = "COINS: " + str(Public.coins)
	score.text = "SCORE: " + str(Public.score)
	lives.text = "LIVES: " + str(Public.lives)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Pause"):
		_on_unpause_pressed()

func show_area(txt: String):
	$AreaHandler/AreaText.text = txt
	$AreaHandler/AnimationPlayer.play("Show")

func music_player():
	if SoundPlayer.current_music == "Ouch":
		return
	if Public.health <= 0:
		SoundPlayer.play_music("Ouch")
	elif Public.time_left <= 100 and not hurry:
		await SoundPlayer.play_music("Hurry")
		hurry = true
	elif Public.time_left > 100:
		if current_music != "":
			SoundPlayer.play_music(current_music)
		else:
			SoundPlayer.stop_music()
	elif hurry and not SoundPlayer.current_music == "Hurry":
		if current_music != "":
			SoundPlayer.play_music(current_music + "Hurry")
		else:
			SoundPlayer.stop_music()

func _on_unpause_pressed() -> void:
	get_tree().paused = not get_tree().paused
	$PauseScreen.visible = not $PauseScreen.visible

func _on_quit_pressed() -> void:
	get_tree().quit()
