@icon("res://assets/comparator.png")
class_name DotBackend
extends Dot


const version_protocol: Dictionary[String, int] = {
	"1.21.10": 774
	}


@onready var dot_server: DotServer = $".."
# Networking
@onready var tcp_server_handler: TCPServerHandler = $Networking/TCPServerHandler
@onready var clients_handler: ClientsHandler = $Networking/ClientsHandler
@onready var packets_handler: PacketsHandler = $Networking/PacketsHandler
# Game
@onready var game_server: GameServer = $Game/GameServer


func start_server() -> Error:
	return tcp_server_handler.start_server(dot_server.used_port)
func stop_server() -> void:
	clients_handler.disconnect_all_clients()
	tcp_server_handler.stop_server()


func handle_networking() -> void:
	if not tcp_server_handler._server.is_listening():
		return
	tcp_server_handler.handle_server_connections()
	clients_handler.handle_clients()
