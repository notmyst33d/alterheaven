tool
extends Area2D

class_name Marker

const Player = preload("res://base/script/player.gd")

export(String) var marker_name = "default"
export(String, FILE) var next_level = null
export(String) var next_level_marker_name = "default"
export(NodePath) var player_spawn = null
export(Player.Facing) var player_facing = Player.Facing.Down

var editor_player = null

func _ready():
    if Engine.editor_hint:
        if not marker_name:
            return

        editor_player = load("res://base/object/player.tscn").instance()
        add_child(editor_player)

func _process(delta):
    if Engine.editor_hint:
        if not editor_player or not marker_name:
            return

        if player_facing == Player.Facing.Up:
            editor_player.get_node("Sprite").animation = "Back"
        elif player_facing == Player.Facing.Down:
            editor_player.get_node("Sprite").animation = "Front"
        elif player_facing == Player.Facing.Left:
            editor_player.get_node("Sprite").animation = "Left"
        elif player_facing == Player.Facing.Right:
            editor_player.get_node("Sprite").animation = "Right"

        if player_spawn:
            editor_player.position = get_node(player_spawn).position
