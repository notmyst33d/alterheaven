extends Node

#
# Parser for dynamic dialog file format (DDF)
#
# Commands:
# {b:bool} - Block user control (until dialog ends) (default: true)
# {n:path} - Next dialog
# {s:int} - Set characters per second speed (default: 20)
# {w:float} - Wait for n seconds
# {spr:path} - Set sprite
# {sfx:path} - Set SFX
# {int} - Interrupt dialog
# {i:key} - Insert data from key
# {e:event} - Send an event
# {+} - Increment dialog counter
# {-} - Decrement dialog counter
#
# JSON syntax:
# "_assume" - Assume commands at the start of each dialog key in DDF file
#

const tag = "DDF"

enum Command {
	Block,
	Next,
	Speed,
	Wait,
	Sprite,
	SFX,
	Interrupt,
	Text,
	CounterIncrement,
	CounterDecrement
}

static func parse(filepath):
	Debug.log_debug_once(tag, "Parsing %s" % filepath)

	var fd = File.new()
	var err = fd.open(filepath, File.READ)
	Debug.log_debug_once(tag, err)
	var data = JSON.parse(fd.get_as_text())
	fd.close()

	if data.error:
		Debug.log_error_once(tag, "JSON.parse failed")
		return null

	var compiled = {}
	var first = true
	var assume = null

	for key in data.result.keys():
		if first and key == "_assume":
			assume = data.result[key]
			first = false
		elif first and key != "_assume":
			Debug.log_error_once(tag, "First key is not _assume")
			return null
		else:
			compiled[key] = compile(assume + data.result[key], key, compiled)

	return compiled

static func compile(ddfcode, key, complete):
	var i = 0
	var compiled = []

	while true:
		var start = ddfcode.find("{", i)
		if start != -1:
			var end = ddfcode.find("}", start)
			var commands = ddfcode.substr(start + 1, (end - start) - 1).split(",")
			var text = ddfcode.substr(i, start - i)

			if text:
				compiled.append({"type": Command.Text, "data": text})

			for command in commands:
				var inner = command.split(":")
				match inner[0]:
					"b":
						compiled.append({"type": Command.Block, "data": bool(inner[1])})
					"n":
						compiled.append({"type": Command.Next, "data": inner[1]})
					"s":
						compiled.append({"type": Command.Speed, "data": int(inner[1])})
					"w":
						compiled.append({"type": Command.Wait, "data": float(inner[1])})
					"spr":
						compiled.append({"type": Command.Sprite, "data": inner[1]})
					"sfx":
						compiled.append({"type": Command.SFX, "data": inner[1]})
					"int":
						compiled.append({"type": Command.Interrupt})
					"i":
						var value = complete.get(inner[1])
						if value:
							compiled.append_array(value)
						else:
							Debug.log_error_once(tag, "Compile failed at %s: %s isnt defined (caused by Command.Insert)" % [key, inner[1]])
							return null
					"+":
						compiled.append({"type": Command.CounterIncrement})
					"-":
						compiled.append({"type": Command.CounterDecrement})

			i = end + 1
		else:
			var text = ddfcode.substr(i)
			if text:
				compiled.append({"type": Command.Text, "data": ddfcode.substr(i)})
			break

	return compiled
