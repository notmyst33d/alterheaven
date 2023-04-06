extends Area2D

const Player = preload("res://base/script/player.gd")

export(NodePath) var player = null
export(NodePath) var level_camera = null
export(String, FILE) var dialog_file = null
export(String) var dialog_key = null
export(bool) var dialog_counter = false
export(Array, Player.Facing) var should_face = []

onready var player_node = get_node(player)
onready var dialog_ui = get_node(level_camera).get_node("UI/Control/DialogUI")

var counter = 0

func _ready():
	player_node.connect("interacted", self, "player_interacted")

func player_interacted():
	if dialog_ui.current:
		return

	for body in get_overlapping_bodies():
		if body != player_node:
			continue

		for face in should_face:
			if player_node.facing == face:
				dialog_ui.connect("dialog_finished", self, "dialog_finished")
				dialog_ui.connect("control_changed", self, "control_changed")
				if dialog_counter:
					dialog_ui.connect("counter_changed", self, "counter_changed")
				dialog_ui.load_ddf(dialog_file)
				if dialog_counter:
					dialog_ui.initiate(dialog_key % counter)
				else:
					dialog_ui.initiate(dialog_key)

func dialog_finished():
	dialog_ui.disconnect("dialog_finished", self, "dialog_finished")
	dialog_ui.disconnect("control_changed", self, "control_changed")
	if dialog_counter:
		dialog_ui.disconnect("counter_changed", self, "counter_changed")
	player_node.enable_movement()

func control_changed(value):
	if value:
		player_node.disable_movement()
	else:
		player_node.enable_movement()

func counter_changed(value):
	counter += value
