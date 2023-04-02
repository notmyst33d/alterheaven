extends Node2D

class_name Node2DRow

const Alignment = preload("res://base/script/ui/alignment.gd").Alignment

export(Alignment) var align = Alignment.Start
export(int) var spacing = 4

func _process(_delta):
	var root_center_x = Global.root.size.x / 2
	var last_size_x = 0
	var children = get_children()
	var children_len = len(children)

	for i in range(children_len):
		var size = children[i].get_node("Size")
		if i == 0:
			#print(last_size_x)
			children[i].position.x = last_size_x
			last_size_x += size.position.x
		else:
			children[i].position.x = last_size_x + spacing
			last_size_x += size.position.x + spacing

	# TODO: Add left and right align
	match align:
		Alignment.Center:
			var target_x = root_center_x - last_size_x / 2
			for child in get_children():
				child.position.x += target_x
