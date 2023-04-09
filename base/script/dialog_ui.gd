extends Control

signal dialog_finished
signal control_changed
signal counter_changed

const DDF = preload("res://base/lib/ddf.gd")

var strings = null

var current = null
var current_index = 0
var next = null
var text = null
var text_index = null
var text_time = null
var text_cps = null
var wait = null
var wait_time = null
var skip = false
var pressed_primary_previously = false
var pressed_primary_previously_different = false
var pressed_primary_previously_different_triggered = false
var touch_primary = false
var waste_frame = false

onready var face_node = $BoxControl/Container/Contents/FaceControl/Face
onready var text_node = $BoxControl/Container/Contents/FaceControl/TypeControl/Container/StarControl/TextControl/Text

func load_ddf(file):
	strings = DDF.parse(file)

func _type_char():
	text_node.text += text[text_index]
	text_index += 1
	$SFX.play()

func _reset():
	current_index = 0
	#Log.debug("Test", text_node)
	text_node.text = ""
	face_node.texture = null
	skip = false
	pressed_primary_previously_different = false
	pressed_primary_previously_different_triggered = false
	_reset_text()
	_reset_text_cps()
	_reset_wait()

func _reset_current_next():
	current = null
	current_index = 0
	next = null

func _reset_text():
	text = null
	text_index = null
	text_time = null

func _reset_text_cps():
	text_cps = null

func _reset_wait():
	wait = null
	wait_time = null

func _finish():
	current = null
	visible = false
	emit_signal("dialog_finished")

func initiate(dialog):
	_reset()
	_reset_current_next()
	current = strings[dialog]
	visible = true

func _process(delta):
	if not current:
		return

	if primary_pressed() and not pressed_primary_previously:
		#skip = true
		if not pressed_primary_previously_different_triggered:
			pressed_primary_previously_different = true
			pressed_primary_previously_different_triggered = true
	else:
		pressed_primary_previously = false

	if skip:
		if text and text_cps:
			text_node.text += text.substr(text_index)
			_reset_text()
		elif wait:
			wait = null
			wait_time = null

	if text and text_cps and not skip:
		if text_index < len(text):
			text_time += delta
			var time_target = 1.0 / text_cps
			while text_time > time_target and text_index < len(text):
				_type_char()
				text_time -= time_target
		else:
			_reset_text()
	elif wait and not skip:
		wait_time += delta
		if wait_time > wait:
			wait = null
			wait_time = null
	else:
		if current and current_index < len(current):
			var one_frame = true
			while current_index < len(current) and one_frame:
				#print(current[current_index]["type"])
				match current[current_index]["type"]:
					DDF.Command.Block:
						emit_signal("control_changed", current[current_index]["data"])
					DDF.Command.Next:
						next = strings[current[current_index]["data"].get_slice("/", 1)]
					DDF.Command.Text:
						if skip:
							text_node.text += current[current_index]["data"]
						else:
							text = current[current_index]["data"]
							text_index = 0
							text_time = 0
							one_frame = false
							_type_char()
					DDF.Command.Speed:
						text_cps = current[current_index]["data"]
					DDF.Command.Sprite:
						face_node.texture = load(current[current_index]["data"])
					DDF.Command.Wait:
						if not skip:
							wait = current[current_index]["data"]
							wait_time = 0
							one_frame = false
					DDF.Command.SFX:
						$SFX.stream = load(current[current_index]["data"])
					DDF.Command.CounterIncrement:
						emit_signal("counter_changed", 1)
					DDF.Command.CounterDecrement:
						emit_signal("counter_changed", -1)
				current_index += 1
		else:
			if primary_pressed():
				if next:
					pressed_primary_previously = true
					current = next
					next = null
					_reset()
					_process(0)
				elif not pressed_primary_previously_different:
					_finish()
				else:
					pressed_primary_previously_different = false

	touch_primary = false

func primary_pressed():
	if touch_primary:
		return true

	return Input.is_action_just_pressed("primary")

func _on_PrimaryButton_pressed():
	touch_primary = true
