extends Area2D

var finished = false
var ongoing = false

func _on_BattleTest_body_entered(body):
	if not ongoing:
		ongoing = true
		get_node("/root/Bedroom").add_child(load("common/object/battleui.tscn").instance())
