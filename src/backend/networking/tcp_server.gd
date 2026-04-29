@icon("res://assets/chain_command_block.png")
class_name TCPServerHandler
extends Node


signal client_connected(client: StreamPeerTCP)


# @private
var _server: TCPServer


# @public
func start_server(port: int) -> Error:
	if not _server:
		_server = TCPServer.new()
	return _server.listen(port)


func stop_server() -> void:
	_server.stop()


func send_packet(client: StreamPeerTCP, packet: PackedByteArray) -> void:
	var err := client.put_data(packet)
	if err != OK:
		printerr(error_string(err))


func handle_server_connections() -> void:
	if not _server.is_listening():
		return
	if not _server.is_connection_available():
		return
	
	var client := _server.take_connection()
	client.set_no_delay(true)
	client_connected.emit(client)
