extends Node

@onready var dot_server: DotServer = $".."
@onready var dot_backend: DotBackend = $"../DotBackend"

var _is_server_running: bool = false


func _ready() -> void:
	print("Starting server")
	await dot_server.ready
	var err := dot_backend.start_server()
	if not err == OK:
		print("An unexpected error occured when starting the server: ")
		print(error_string(err))
		_stop_application()
		return
	print("Server started successfully on port: %s" % [dot_server.used_port])
	_is_server_running = true


func _process(_delta: float) -> void:
	if not _is_server_running:
		return
	dot_backend.handle_networking()


func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		_stop_application()

func _stop_application() -> void:
	dot_backend.stop_server()
	get_tree().quit()
