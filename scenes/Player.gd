extends KinematicBody2D

signal cat_hungry
signal cat_playfully
signal cat_sleepy

onready var sprite := $AnimatedSprite
onready var state_text := $StateText
onready var state_text_timer := $StateTextTimer
onready var pickup_sound: AudioStreamPlayer = $PickupSound
onready var hurt_sound: AudioStreamPlayer = $HurtSound

export var friction := 0.8
export var acceleration := 0.1

const FLOOR := Vector2(0, -1)
const JUMPSPEED := 350
const GRAVITY := 10

var current_state := ""
var recent_states := []
var states := {
	"sleepy": "on_sleepy",
	"hungry": "on_hungry",
	"playfully": "on_playfully",
}

var speed := 300
var velocity := Vector2()

func _ready():
	GlobalStore.connect("random_state", self, "_on_random_state")

func get_input():
	if Input.is_action_pressed("move_right"):
		velocity.x = +speed
	elif Input.is_action_pressed("move_left"):
		velocity.x = -speed
	else:
		velocity.x = 0

	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = -JUMPSPEED

	if velocity.x != 0:
		# accelerate when there's input
		sprite.play("cat_walk")
		sprite.flip_h = velocity.x < 0
	else:
		# slow down when there's no input
		sprite.play("cat_idle")

	# gravity
	velocity.y += GRAVITY
	move_and_slide(velocity, FLOOR)

func _physics_process(_delta):

	if current_state == "sleeping":
		return

	get_input()

func _on_random_state():
	var rng = RandomNumberGenerator.new()
	var states_keys = states.keys()

	if recent_states and recent_states.size() > 2:
		recent_states.clear()
		rng.randomize()

	if recent_states:
		for recent_state in recent_states:
			states_keys.erase(recent_state)

	var rand_index: int = rng.randi() % states_keys.size()
	var state_to_apply = states_keys[rand_index]
	recent_states.append(state_to_apply)

	call(states[state_to_apply])
	GlobalStore.cat_actual_state(state_to_apply, "increase")

func on_sleepy():
	state_text.text = "I'm sleepy"
	emit_signal("cat_sleepy")
	sprite.play("cat_sleep")
	current_state = "sleeping"
	state_text_timer.start()

func on_hungry():
	state_text.text = "I'm hungry"
	emit_signal("cat_hungry")
	state_text_timer.start()

func on_playfully():
	state_text.text = "I want to play"
	emit_signal("cat_playfully")
	state_text_timer.start()

func _on_StateTextTimer_timeout():
	state_text.text = ""
	current_state = ""
	
func play_wool_ball(_texture):
	pickup_sound.pitch_scale = rand_range(0.5, 1.5)
	pickup_sound.play()
	var state_to_apply = "playfully"
	GlobalStore.cat_actual_state(state_to_apply, "decrease")

func eat_chicken(_exture):
	pickup_sound.pitch_scale = rand_range(0.5, 1.5)
	pickup_sound.play()
	var state_to_apply = "hungry"
	GlobalStore.cat_actual_state(state_to_apply, "decrease")

func sleep(_texture):
	pickup_sound.pitch_scale = rand_range(0.5, 1.5)
	pickup_sound.play()
	var state_to_apply = "sleepy"
	GlobalStore.cat_actual_state(state_to_apply, "decrease")

func pressed_button(_texture, _body):
	pickup_sound.pitch_scale = rand_range(0.5, 1.5)
	pickup_sound.play()
	var state_to_apply = "playfully"
	GlobalStore.cat_actual_state(state_to_apply, "decrease")

func hit_cucumber(_texture):
	hurt_sound.pitch_scale = rand_range(0.5, 1.5)
	hurt_sound.play()

	var state_to_apply = "playfully"
	GlobalStore.cat_actual_state(state_to_apply, "increase", 2)
	state_to_apply = "hungry"
	GlobalStore.cat_actual_state(state_to_apply, "increase", 2)
	state_to_apply = "sleepy"
	GlobalStore.cat_actual_state(state_to_apply, "increase", 2)

