extends Node

var tvres = Vector2(1280, 960)
var wideres = Vector2(1536, 960)

func _ready():
    #OS.window_size = wideres
    #get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_VIEWPORT, SceneTree.STRETCH_ASPECT_KEEP, wideres)

    # Yes fuck you filter my fucking viewport
    get_node("/root").get_texture().flags = Texture.FLAG_FILTER

    # For testing
    get_tree().change_scene("res://ch1/level/bedroom.tscn")
