extends Node2D

var rise = false
var rise_speed = 0.5
var rise_finished = false
var rise_to = null
var lock = false
var select_index = 0

var tween_trans = Tween.TRANS_CIRC
var tween_ease = Tween.EASE_OUT
var tween_speed = 0.2
var ignore = []

var box_raise = 28
var transition = null

onready var uibackground_node = $Control/UIBackground
onready var background_node = $Control/Background
onready var characters_node = $Control/UIBackground/Characters

func _ready():
	# The target position should be set in the editor
	rise_to = uibackground_node.rect_position

	# Reset stuff
	uibackground_node.rect_position = Vector2(uibackground_node.rect_position.x, 960)
	background_node.modulate = Color("00ffffff")

	# Do enter animation
	var tween1 = get_tree().create_tween().set_trans(Tween.TRANS_QUAD)
	var tween2 = get_tree().create_tween().set_trans(Tween.TRANS_QUAD)
	tween1.tween_property(uibackground_node, "rect_position", rise_to, rise_speed)
	tween2.tween_property(background_node, "modulate", Color("ffffffff"), rise_speed)

	#join()
	#join()
	#join()

func _setup_animator(animator):
	animator.play("battle_box_retract")
	animator.advance(animator.current_animation_length)

func join():
	var box = load("base/object/battle_box.tscn").instance()
	#box.position.y += box_raise
	box.get_node("BoxPolygon").modulate = Color("00ffffff")
	box.get_node("BoxPolygonInner").modulate = Color("00ffffff")
	#call_deferred("_setup_animator", box.get_node("Animator"))
	characters_node.add_child(box)

	# Recompose UI elements
	recompose()

	if characters_node.get_child(0) == box:
		call_deferred("select", 0)

func select(index):
	if index < 0 or index > characters_node.get_child_count() - 1:
		return null

	var old = characters_node.get_child(select_index)
	var new = characters_node.get_child(index)

	#tween_old_position.tween_property(old, "position", Vector2(old.position.x, old.position.y + box_raise), tween_speed)
	#tween_new_position.tween_property(new, "position", Vector2(new.position.x, new.position.y - box_raise), tween_speed)
	#tween_old_modulate_box_polygon.tween_property(old.get_node("BoxPolygon"), "modulate", Color("00ffffff"), tween_speed)
	#tween_new_modulate_box_polygon.tween_property(new.get_node("BoxPolygon"), "modulate", Color("ffffffff"), tween_speed)
	#tween_old_modulate_box_polygon_inner.tween_property(old.get_node("BoxPolygonInner"), "modulate", Color("00ffffff"), tween_speed)
	#tween_new_modulate_box_polygon_inner.tween_property(new.get_node("BoxPolygonInner"), "modulate", Color("ffffffff"), tween_speed)
	old.get_node("AnimationPlayer").play("Popdown")
	new.get_node("AnimationPlayer").play("Popup")

	select_index = index

func recompose():
	# Positioning stuff
	var root_center_x = Global.root.size.x / 2
	var last_size_x = 0
	var children = characters_node.get_children()
	var children_len = len(children)

	for i in range(children_len):
		if children[i] in ignore:
			continue

		var size = children[i].get_node("Size")
		if i == 0:
			children[i].position.x = last_size_x
			last_size_x += size.position.x
		else:
			children[i].position.x = last_size_x + 32
			last_size_x += size.position.x + 32

	var target_x = root_center_x - last_size_x / 2
	for child in children:
		if child in ignore:
			continue

		child.position.x += target_x

func _process(_delta):
	if Input.is_action_just_pressed("primary"):
		join()

	if Input.is_action_just_pressed("tertiary"):
		recompose()

	#if Input.is_action_just_pressed("x"):
	#	detach()

	#if Input.is_action_pressed("up"):
	#	characters_node.get_child(0).position.y -= 2

	#if Input.is_action_pressed("down"):
	#	characters_node.get_child(0).position.y += 2

	if Input.is_action_just_pressed("left"):
		select(select_index - 1)
	#	characters_node.get_child(0).position.x -= 2

	if Input.is_action_just_pressed("right"):
		select(select_index + 1)
	#	characters_node.get_child(0).position.x += 2
