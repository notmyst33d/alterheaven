extends Node

var CancellableTween = load("res://base/script/cancellable_tween.gd")

func create(obj, ttrans, tease, tspeed):
	var tween = CancellableTween.new(obj, ttrans, tease, tspeed)
	add_child(tween)
	return tween
