extends Node2D

class_name Level

export(NodePath) var level_camera = null
export(NodePath) var level_change_trigger = null
export(NodePath) var player = null
export(String, FILE) var next_level = null

func _ready():
	Global.level = self

	if level_change_trigger:
		get_node(level_change_trigger).connect("body_entered", self, "_level_changed")
	else:
		print("[Level] Level change trigger is not set")

	if level_camera:
		var fade = get_node(level_camera).get_node("Fade")
		var tween = get_tree().create_tween()
		fade.modulate = Color("ffffffff")
		tween.tween_property(fade, "modulate", Color("00ffffff"), 0.5)
	else:
		print("[Level] Level camera is not set")

func _level_changed(body):
	if not next_level:
		print("[Level] Cannot change level because there is no next level")
		return

	get_node(player).emit_signal("level_changed")

	var fade = get_node(level_camera).get_node("Fade")
	var tween = get_tree().create_tween()
	fade.modulate = Color("00ffffff")
	tween.tween_property(fade, "modulate", Color("ffffffff"), 0.5)
	tween.tween_callback(self, "_level_changed_finished")

func _level_changed_finished():
	get_tree().change_scene(next_level)
