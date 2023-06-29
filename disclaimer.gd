extends Node

var time = 0

func _process(delta):
    time += delta

    if time > 5:
        SceneManager.call_deferred("change_scene", "res://ch1/level/bedroom.tscn")
