@icon("res://assets/icons/clipboard2-pulse-fill.svg")
class_name BackendLogger
extends BackendModule
## A module containing usefull methods which check the verbosity level and log 
## to the console based on the chosen verbosity level


enum verbosity {
	SILENT,
	ERROR,
	WARNING,
	INFO,
	DEBUG,
	}


var current_verbosity: verbosity = verbosity.DEBUG


func logdebug(msg: String) -> void:
	if current_verbosity < verbosity.DEBUG:
		return # Turned off
	
	if msg.contains("\n"):
		var sliced := msg.split("\n", true)
		sliced[0] = "[color=dark_violet][b][debug]:[/b] %s[/color]" % sliced[0]
		for line in sliced:
			print_rich("[color=dark_violet]          %s[/color]" % line)
		return
	
	print_rich("[color=dark_violet][b][debug]:[/b] %s[/color]" % msg)


func loginfo(msg: String) -> void:
	if current_verbosity < verbosity.INFO:
		return # Turned off
	
	if msg.contains("\n"):
		var sliced := msg.split("\n", true)
		sliced[0] = "[color=white][b][ log ]:[/b] %s[/color]" % sliced[0]
		for line in sliced:
			print_rich("[color=white]          %s[/color]" % line)
		return
	
	print_rich("[color=white][b][ log ]:[/b] %s[/color]" % msg)


func logwarning(msg: String) -> void:
	if current_verbosity < verbosity.WARNING:
		return # Turned off
	
	if msg.contains("\n"):
		var sliced := msg.split("\n", true)
		sliced[0] = "[color=dark_orange][b][ warn]:[/b] %s[/color]" % sliced[0]
		for line in sliced:
			print_rich("[color=dark_orange]          %s[/color]" % line)
		return
	
	print_rich("[color=dark_orange][b][ warn]:[/b] %s[/color]" % msg)


func logerror(msg: String) -> void:
	if current_verbosity < verbosity.ERROR:
		return # Turned off
	
	if msg.contains("\n"):
		var sliced := msg.split("\n", true)
		sliced[0] = "[color=light_coral][b][error]:[/b] %s[/color]" % sliced[0]
		for line in sliced:
			print_rich("[color=light_coral]          %s[/color]" % line)
		return
	
	print_rich("[color=light_coral][b][error]:[/b] %s[/color]" % msg)
