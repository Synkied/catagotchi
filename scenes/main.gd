extends Node2D

export (PackedScene) var Item

onready var camera = $Player/Camera2D
onready var player = $Player

export var camera_left_padding = 300
onready var items = $Items
onready var actionables = $Actionables


func _physics_process(_delta):
	if (player.position.x - camera_left_padding) > camera.limit_left:
		camera.limit_left = player.position.x - camera_left_padding

func _ready():
	items.hide()
	actionables.hide()
	spawn_items()
	spawn_actionables()

func spawn_actionables():
	for cell_position in actionables.get_used_cells():

		var id = actionables.get_cellv(cell_position)
		var type = actionables.tile_set.tile_get_name(id)
		var pos = actionables.map_to_world(cell_position) + actionables.cell_size / 2

		match type:
			'button':
				var button_grass = Item.instance()
				button_grass.init(type, pos)
				add_child(button_grass)
				button_grass.connect('player_pressed_button', player, 'pressed_button')


func spawn_items():
	for cell_position in items.get_used_cells():
		var id = items.get_cellv(cell_position)
		var type = items.tile_set.tile_get_name(id)
		var pos = items.map_to_world(cell_position) + items.cell_size / 2

		match type:
			'chicken_thigh':
				var chicken_thigh = Item.instance()
				chicken_thigh.init(type, pos)
				add_child(chicken_thigh)
				chicken_thigh.connect('player_chicken_thigh_pickup', player, 'eat_chicken')

			'wool_ball':
				var wool_ball = Item.instance()
				wool_ball.init(type, pos)
				add_child(wool_ball)
				wool_ball.connect('player_wool_ball_pickup', player, 'play_wool_ball')

			'pillow':
				var pillow = Item.instance()
				pillow.init(type, pos)
				add_child(pillow)
				pillow.connect('player_pillow_pickup', player, 'sleep')

			'cucumber':
				var cucumber = Item.instance()
				cucumber.init(type, pos)
				add_child(cucumber)
				cucumber.connect('player_hit_cucumber', player, 'hit_cucumber')

func get_cell_rotation(tilemap, cell_position):
	var transposed = tilemap.is_cell_transposed(cell_position.x, cell_position.y)
	var flipX = tilemap.is_cell_x_flipped(cell_position.x, cell_position.y)
	var flipY = tilemap.is_cell_y_flipped(cell_position.x, cell_position.y)

	if (!transposed && !flipX && !flipY):
		return 0

	if (transposed && !flipX && flipY):
		return PI / 2

	if (!transposed && flipX):
		return PI

	if (transposed && flipX && !flipY):
		return PI / 2

	print("Unknown", transposed, flipX, flipY)
	return 0
