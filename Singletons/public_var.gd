extends Node

var coins := 0
var totalcoins := 0
var time_left := 400.0
var score := 0
var total_score := 0
var lives := 5
var maxhealth := 8
@onready var health := maxhealth

@onready var defaultcoin = coins
@onready var defaulttime = time_left
@onready var defaultscore = score

var hurry = false

func _process(delta: float) -> void:
	time_left -= delta * 1.25
	if coins >= 100:
		coins -= 100
		lives += 1

func reset():
	health = maxhealth
	score = defaultscore
	coins = defaultcoin
	score = defaultscore
