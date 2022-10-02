extends CanvasLayer

# Onready
onready var message = $Message
onready var message_tween = $MessageTween
onready var message_timer = $MessageTimer
onready var timer := $Timer
onready var timer_label := $Label
onready var sleep_bar := $SleepBar
onready var play_bar := $PlayBar
onready var hunger_bar := $HungerBar
onready var music := $AudioStreamPlayer

# Variables
var base_music = preload('res://assets/audio/catagochi_main.wav')

func _ready():
	GlobalStore.connect("cat_actual_state", self, "_on_cat_actual_state")
	play_music()
	timer.start()

func _process(_delta):
	timer_label.text = str(int(timer.get_time_left())) + " seconds left"

func play_music():
	if !music.is_playing():
		music.stream = base_music
		music.play()

func _on_AudioStreamPlayer_finished():
	play_music()


func _on_MessageTimer_timeout():
	message_tween.interpolate_property(
		message,
		"rect_position",
		Vector2(0, 0),
		Vector2(0, 1000),
		0.3,
		Tween.TRANS_QUAD,
		Tween.EASE_IN_OUT
	)
	message_tween.start()


func _on_MessageTween_tween_completed(_object, _key):
	message.queue_free()
	message_timer.queue_free()

func _on_Timer_timeout():
	GlobalStore.random_state()

func _on_cat_actual_state(state, action, value = null):
	if hunger_bar.value >= 10 or play_bar.value >= 10 or sleep_bar.value >= 10:
		GlobalStore.game_over()
	
	if not value:
		if action == "increase":
			value = 1
		if action == "decrease":
			value = -1

	match (state):
		"hungry":
			hunger_bar.value += value
		"playfully":
			play_bar.value += value
		"sleepy":
			sleep_bar.value += value

