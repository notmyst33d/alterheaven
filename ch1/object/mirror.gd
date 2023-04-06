extends Node2D

export(NodePath) var player = null
onready var player_node = get_node(player)
onready var player_sprite = get_node(player).get_node("Sprite")
onready var mirror_player = $MirrorPlayer
onready var mirror_player_sprite = $MirrorPlayer/Sprite
onready var mirror_player_shape = $MirrorPlayer/Shape

func _ready():
	mirror_player_shape.disabled = true

func _physics_process(delta):
	var relative_player_position = player_node.global_position - global_position
	mirror_player_sprite.frame = player_sprite.frame
	if player_sprite.animation == "Front":
		mirror_player_sprite.animation = "Back"
	elif player_sprite.animation == "Back":
		mirror_player_sprite.animation = "Front"
	else:
		mirror_player_sprite.animation = player_sprite.animation
	mirror_player.position = Vector2(relative_player_position.x, -relative_player_position.y)
