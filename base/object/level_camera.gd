extends Camera2D

export(NodePath) var player = null

func _process(delta):
	if not player:
		return

	var player_position = get_node(player).position
	var center = Global.size / 2

	position = Vector2(
		clamp(
			-(center.x - player_position.x),
			0,
			abs(Global.size.x - limit_right)
		),
		clamp(
			-(center.y - player_position.y),
			0,
			abs(Global.size.y - limit_bottom)
		)
	)

func initiate_dialog():
	pass
