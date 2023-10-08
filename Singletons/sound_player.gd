extends Node

var current_music : String

func play_music(snd):
	if $Music/Music.stream == load("res://Sounds/Music/" + snd + ".wav"): return
	current_music = snd
	$Music/Music.stream = load("res://Sounds/Music/" + snd + ".wav")
	$Music/Music.play()
	await $Music/Music.finished
	return true

func stop_music():
	$Music/Music.stop()

func play_sound(snd, spd := 1.0):
	get_node("/root/SoundPlayer/Sfx/" + snd).play()
	get_node("/root/SoundPlayer/Sfx/" + snd).pitch_scale = spd

func _on_music_finished() -> void:
	current_music = "null"
