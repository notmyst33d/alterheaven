extends Level

onready var player_node = get_node(player)
onready var dialog_ui = get_node(level_camera).get_node("UI/Control/DialogUI")

func _ready():
	if Global.variables.get("bedroom_dialog_finished"):
		return

	dialog_ui.connect("dialog_finished", self, "dialog_finished")
	dialog_ui.connect("control_changed", self, "control_changed")
	dialog_ui.load_ddf("res://ch1/dialog/asriel.tres")
	dialog_ui.initiate("bedroom_wakeup")

func control_changed(value):
	if value:
		player_node.disable_movement()
	else:
		player_node.enable_movement()

func dialog_finished():
	dialog_ui.disconnect("dialog_finished", self, "dialog_finished")
	dialog_ui.disconnect("control_changed", self, "control_changed")
	player_node.enable_movement()
	Global.variables["bedroom_dialog_finished"] = true
