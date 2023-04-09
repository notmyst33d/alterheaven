extends Node2D

class_name Level

const Player = preload("res://base/script/player.gd")

export(NodePath) var level_camera = null
export(Array, NodePath) var markers = []
export(NodePath) var player = null

func _ready():
	Global.level = self

	if markers:
		teleport_player_to_marker("default")
		for marker in markers:
			get_node(marker).connect("body_entered", self, "_level_changed", [marker])
	else:
		print("[Level] Marker list is empty")

	if level_camera:
		var fade = get_node(level_camera).get_node("Fade")
		var tween = get_tree().create_tween()
		fade.modulate = Color("ffffffff")
		tween.tween_property(fade, "modulate", Color("00ffffff"), 0.5)
	else:
		print("[Level] Level camera is not set")

func _level_changed(body, marker):
	print("Triggered by: %s" % get_node(marker).marker_name)

	get_node(player).emit_signal("level_changed")

	var fade = get_node(level_camera).get_node("Fade")
	var tween = get_tree().create_tween()
	fade.modulate = Color("00ffffff")
	tween.tween_property(fade, "modulate", Color("ffffffff"), 0.5)
	tween.tween_callback(self, "_level_changed_finished", [marker])

func _level_changed_finished(marker):
	var level = load(get_node(marker).next_level).instance()
	level.call_deferred("teleport_player_to_marker", get_node(marker).next_level_marker_name)
	get_tree().get_root().add_child(level)
	queue_free()

func teleport_player_to_marker(marker_name):
	for marker in markers:
		if get_node(marker).marker_name == marker_name:
			print("Teleporting to: %s" % marker_name)
			get_node(player).global_position = get_node(marker).get_node(get_node(marker).player_spawn).global_position
			get_node(player).facing = get_node(marker).player_facing
			if get_node(player).facing == Player.Facing.Up:
				get_node(player).get_node("Sprite").animation = "Back"
			elif get_node(player).facing == Player.Facing.Down:
				get_node(player).get_node("Sprite").animation = "Front"
			elif get_node(player).facing == Player.Facing.Left:
				get_node(player).get_node("Sprite").animation = "Left"
			elif get_node(player).facing == Player.Facing.Right:
				get_node(player).get_node("Sprite").animation = "Right"
