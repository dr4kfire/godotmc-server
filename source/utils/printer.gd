class_name Printer
extends Object
## A collection of preformatted print functions for various neeeds

static func print_log(msg: String) -> void:
	print_rich("[b][LOG]:[/b] %s" % msg)

static func print_warning(msg: String) -> void:
	print_rich("[color=dark_orange][b][WARN]:[/b] %s[/color]" % msg)

static func print_error(msg: String) -> void:
	print_rich("[color=light_coral][b][ERR];[/b] %s[/color]" % msg)
