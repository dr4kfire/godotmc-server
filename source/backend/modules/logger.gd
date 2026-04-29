@icon("res://assets/goat_horn.png")
class_name DotLogger
extends Object
## A static class containing usefull methods which check the verbosity level
## and log based on them
##
## Accessable globaly - this class is just using [method print] with diffrent
## styling as well as what is logged depending on the verbosity level


enum verbosity {
	SILENT,
	ERROR,
	WARNING,
	DEBUG,
	}


static func printlog(v: verbosity, err: Error) -> void:
	match v:
		verbosity.SILENT:
			return
		verbosity.ERROR:
			push_error("")
