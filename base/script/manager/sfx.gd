extends Node

func play(sfx):
	var player = AudioStreamPlayer.new()
	Global.root.add_child(player)
	player.stream = load(sfx)
	player.play()
