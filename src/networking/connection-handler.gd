@icon("uid://df88igcu7fbgg")
class_name ConnectionHandler
extends Minecraft

signal connection_established
signal connection_bytes_avaliable
signal connection_closed


@export var server: MCTCPServerHandler
var current_connection: StreamPeerTCP
var accept_incomming_connections: bool = true


func handle_connections() -> void:
	if accept_incomming_connections:
		_try_accept_connection()
	
	if current_connection and not _is_connection_healthy():
		_close_connection()
		accept_incomming_connections = true
	
	if current_connection and current_connection.get_available_bytes() > 1:
		connection_bytes_avaliable.emit()


func _ready() -> void:
	connection_established.connect(func():
		accept_incomming_connections = false
		)


func _try_accept_connection() -> void:
	current_connection = server.server.take_connection()
	if current_connection:
		print("[INFO]: Established connection with: %s" % current_connection.get_connected_host())
		connection_established.emit()

func _is_connection_healthy() -> bool:
	if current_connection.get_status() in [StreamPeerTCP.STATUS_ERROR, StreamPeerTCP.STATUS_NONE]:
		return false
	return true

func _close_connection() -> void:
	if not current_connection:
		return
	print("[INFO]: Closed conneciton with: %s" % current_connection.get_connected_host())
	current_connection.disconnect_from_host()
	current_connection = null
	connection_closed.emit()
