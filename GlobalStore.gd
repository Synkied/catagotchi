extends Node

signal random_state
signal cat_actual_state

# Variables
var current_level = 0
var main_screen = 'res://scenes/Main.tscn'
var start_screen = 'res://ui/StartScreen.tscn'
var end_screen = 'res://ui/EndScreen.tscn'
var score = 0
var highscore = 0
var score_file = "user://highscore.txt"

func _ready():
	setup()

func setup():
	var f = File.new()

	if f.file_exists(score_file):
		f.open(score_file, File.READ)
		var content = f.get_as_text()
		highscore = int(content)
		f.close()

func new_game():
	score = 0
	get_tree().change_scene(main_screen)

func save_score():
	var f = File.new()
	f.open(score_file, File.WRITE)
	f.store_string(str(0))
	f.close()

func game_over():
	if score > highscore: highscore = score
	save_score()
	get_tree().change_scene(end_screen)


func random_state():
	emit_signal("random_state")

func cat_actual_state(state, action, value = null):
	emit_signal("cat_actual_state", state, action, value)
