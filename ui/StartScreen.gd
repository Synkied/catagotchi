extends CanvasLayer

# Variables
var intro_music = preload("res://assets/audio/catagochi_intro_2.wav")

func _ready():
	play_music()
	$HighScore.text += str(GlobalStore.highscore)

func _input(event):
	if event.is_action_pressed('start'):
		GlobalStore.new_game()

func _on_Button_pressed():
	GlobalStore.new_game()

func play_music():
	if !$AudioStreamPlayer.is_playing():
		$AudioStreamPlayer.stream = intro_music
		$AudioStreamPlayer.play()

func _on_AudioStreamPlayer_finished():
	play_music()
