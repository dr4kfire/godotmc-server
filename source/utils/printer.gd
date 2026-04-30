class_name Printer
extends Object
## A collection of preformatted print functions for various neeeds

static func printlog(msg: String) -> void:
	print_rich("[b][ log ]:[/b] %s" % msg)

static func printwarning(msg: String) -> void:
	print_rich("[color=dark_orange][b][ warn]:[/b] %s[/color]" % msg)

static func printerror(msg: String) -> void:
	print_rich("[color=light_coral][b][error]:[/b] %s[/color]" % msg)

static func printdebug(msg: String) -> void:
	print_rich("[color=dark_violet][b][debug]:[/b] %s[/color]" % msg)
