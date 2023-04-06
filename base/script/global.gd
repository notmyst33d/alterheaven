extends Node

onready var root = get_tree().get_root()
var viewport_mode = false
var size = null

var level = null

func _ready():
	if ProjectSettings.get("display/window/stretch/mode") == "2d":
		size = Vector2(ProjectSettings.get("display/window/size/width"), ProjectSettings.get("display/window/size/height"))
	else:
		viewport_mode = true

func _process(delta):
	if viewport_mode:
		size = root.size
