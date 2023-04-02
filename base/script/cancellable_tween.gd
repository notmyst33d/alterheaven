extends Node

class_name CancellableTween

var _object = null
var _transition_type = null
var _ease_type = null
var _speed = null
var _tween = null
var _tween_property = null

var previous = null
var current = null

func _init(object, transition_type, ease_type, speed):
	_object = object
	_transition_type = transition_type
	_ease_type = ease_type
	_speed = speed

func _ready():
	_tween_new()

func _tween_new():
	_tween = get_tree().create_tween().set_trans(_transition_type).set_ease(_ease_type)

func _tween_current():
	_tween_new()
	_tween.call_deferred("tween_property", _object, _tween_property, current, _speed)

func _tween_previous():
	_tween_new()
	_tween.call_deferred("tween_property", _object, _tween_property, previous, _speed)

func tween_position(x, y):
	previous = _object.position
	current = Vector2(x, y)
	_tween_property = "position"
	_tween_current()

func tween_modulate(c):
	previous = _object.modulate
	current = c
	_tween_property = "modulate"
	_tween_current()

func backward():
	_tween_previous()
