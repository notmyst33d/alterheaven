extends Node

func debug(tag, message):
	print("[Debug %s] %s" % [tag, message])

func info(tag, message):
	print("[Info  %s] %s" % [tag, message])

func error(tag, message):
	print("[Error %s] %s" % [tag, message])

func bug(tag, message):
	print("[Bug   %s] %s" % [tag, message])
