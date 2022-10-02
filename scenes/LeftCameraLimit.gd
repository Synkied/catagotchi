extends StaticBody2D

func _process(_delta):
	var ctrans = get_canvas_transform()
	var min_pos = -ctrans.get_origin() / ctrans.get_scale()
	position.x = min_pos.x
