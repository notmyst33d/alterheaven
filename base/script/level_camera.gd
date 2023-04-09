extends Camera2D

class_name LevelCamera

export(NodePath) var player = null
var player_node = null

func _ready():
	if not player:
		print("[LevelCamera] Player not set")
		return

	player_node = get_node(player)

	if OS.has_feature("mobile"):
		add_child(load("res://base/object/touch_buttons.tscn").instance())

func _process(delta):
	if not player_node:
		return

	var player_position = player_node.position
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
