extends Node

var _scene = null

func set_scene(path):
	if _scene:
		_scene.queue_free()

	var scene = load(path).instance()
	get_node("/root").call_deferred("add_child", scene)

	_scene = scene

func change_scene_transition(path):
	if _scene:
		_scene.queue_free()

	var scene = load(path).instance()
	get_node("/root").call_deferred("add_child", scene)

	_scene = scene
