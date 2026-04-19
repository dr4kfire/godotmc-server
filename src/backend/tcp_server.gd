@icon("res://assets/chain_command_block.png")
class_name TCPServerHandler
extends DotBackend


signal packet_recieved(data: PackedByteArray, source: StreamPeerTCP)


# @private
var _server: TCPServer
var _connected_clients: Array[StreamPeerTCP] = []


# @public
func start_server(port: int) -> Error:
	return _server.listen(port)

func stop_server() -> void:
	_server.stop()

func send_packet(client: StreamPeerTCP, packet: PackedByteArray) -> void:
	var err := client.put_data(packet)
	if err != OK:
		printerr(error_string(err))

func handle_server_connections() -> void:
	if _server.is_listening():
		_handle_icomming_connections()
		_handle_clients()


# @private
func _handle_icomming_connections() -> void:
	if _server.is_connection_available():
		var client := _server.take_connection()
		client.set_no_delay(true)
		_connected_clients.append(client)
func _handle_clients() -> void:
	for client in _connected_clients:
		client.poll()
		if client.get_status() in [StreamPeerTCP.STATUS_NONE, StreamPeerTCP.STATUS_ERROR]:
			_connected_clients.erase(client)
			continue
		if client.get_available_bytes() > 0:
			_handle_incomming_packet(client)
func _handle_incomming_packet(stream: StreamPeerTCP) -> void:
	var decode_return := MCTypes.decode_varint_from_stream(stream)
	if decode_return.error != OK:
		return
	
	var result: Array = stream.get_partial_data(decode_return.value as int)
	var error: Error = result[0]
	if error != OK:
		return
	var data: PackedByteArray = result[1]
	packet_recieved.emit(data)
