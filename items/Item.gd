extends Node2D

# Signals
signal player_chicken_thigh_pickup
signal player_wool_ball_pickup
signal player_pillow_pickup
signal player_pressed_button
signal player_hit_cucumber

const HFRAME = 4
const VFRAME = 1

# Variables
var type
var textures = {
	'chicken_thigh': 'res://assets/chicken_thigh.png',
	'wool_ball': 'res://assets/wool_ball.png',
	'pillow': 'res://assets/pillow.png',
	'button': 'res://assets/button.png',
	'cucumber': 'res://assets/cucumber.png',
}

func init(_type, pos):
	$AnimatedSprite.frames = SpriteFrames.new()
	$AnimatedSprite.frames.set_animation_loop("default", true)
	$AnimatedSprite.frames.set_animation_speed("default", 5.0)

	for i in range(HFRAME):
		var texture := load(textures[_type])
		var atlas_texture := AtlasTexture.new()
		var region := Rect2( i * 64, 0, 64, 64 )
		atlas_texture.set_atlas(texture)
		atlas_texture.set_region(region)

		$AnimatedSprite.frames.add_frame("default", atlas_texture, i)

	type = _type
	position = pos

func player_pickup(body):
	match type:
		'chicken_thigh':
			emit_signal('player_chicken_thigh_pickup', textures[type])
		'wool_ball':
			emit_signal('player_wool_ball_pickup', textures[type])
		'pillow':
			emit_signal('player_pillow_pickup', textures[type])
		'button':
			emit_signal('player_pressed_button', textures[type], body)
		'cucumber':
			emit_signal('player_hit_cucumber', textures[type])
	$Tween.start()


func _on_Item_player_chicken_thigh_pickup(_texture):
	queue_free()

func _on_Item_player_wool_ball_pickup(_texture):
	queue_free()

func _on_Item_player_pillow_pickup(_texture):
	queue_free()

func _on_Item_player_hit_cucumber(_texture):
	queue_free()

func _on_Item_body_entered(body):
	if body.is_in_group('players'):
		player_pickup(body)

func _on_Item_player_pressed_button():
	pass 

