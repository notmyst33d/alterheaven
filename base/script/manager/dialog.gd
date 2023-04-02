extends Node

func start():
	var dialog = load("res://base/object/dialogui.tscn").instance()
	get_node("/root").add_child(dialog)
	dialog.load_ddf("res://ch1/dialog/cutscene.tres")
	dialog.initiate("magicdoor01")
