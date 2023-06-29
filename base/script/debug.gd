extends Node

var messages = []
var messages_once = []

func _process(_delta):
    return
    if not Global.level:
        return

    var camera = Global.level.get_node(Global.level.level_camera)
    if not camera:
        return

    if Input.is_action_just_pressed("debug1"):
        messages.clear()
        messages_once.clear()

    var debug_node = camera.get_node("UI/Control/Debug")
    debug_node.text = "Debugging %s\n" % ProjectSettings.get("application/config/name")
    debug_node.text += "\n".join(messages_once) + "\n"
    debug_node.text += "\n".join(messages)
    messages.clear()

func log_debug(tag, message):
    messages.append("[Debug %s] %s" % [tag, message])

func log_debug_once(tag, message):
    messages_once.append("[Debug %s] %s" % [tag, message])

func log_error_once(tag, message):
    messages_once.append("[Error %s] %s" % [tag, message])
