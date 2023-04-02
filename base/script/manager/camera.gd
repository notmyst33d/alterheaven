extends Node

var _camera = null

func set_camera(camera):
	_camera.current = false
	_camera = camera
	_camera.current = true
