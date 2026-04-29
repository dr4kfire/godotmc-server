@icon("res://assets/command_block.png")
class_name Networking
extends BackendModule
## Node used for the low-level TCPServer handling connections, packets, etc.
##
## This class implements the backend functionality for the TCP server and
## handles the incomming traffic providing it to the server API for it to be
## later used by the plugins and other stuff.


## Emitted when a new valid packet is recieved
signal new_packet_recieved(from: String, packet: PackedByteArray)


## The verbosity level 
enum verbosity {
	SILENT = 0,
	ERRORS = 1,
	WARNINGS = 2,
	INFO = 3,
	DEBUG = 4,
}


var used_verbosity := verbosity.ERRORS
var active_connections: Array[StreamPeerTCP]
var _server := TCPServer.new()
var _stream_buffers: Dictionary = {}


func _process(_dt: float) -> void:
	if not _server.is_listening():
		return
	
	while _server.is_connection_available():
		var new_stream := _server.take_connection()
		new_stream.set_no_delay(true)
		active_connections.append(new_stream)
		_validate_or_remove_stream_buffer(new_stream)
	
	for i in range(active_connections.size()-1, -1, -1):
		var stream := active_connections[i]
		stream.poll()
		
		if stream.get_status() != StreamPeerTCP.STATUS_CONNECTED:
			active_connections.remove_at(i)
			_validate_or_remove_stream_buffer(stream)
			continue
		
		var packet: PackedByteArray = _try_read_packet(stream)
		if packet.size() > 0:
			var client_ip: String = stream.get_connected_host()
			new_packet_recieved.emit(client_ip, packet)
		
		_validate_or_remove_stream_buffer(stream)


func change_listening_state(listen: bool, port: int = 25565) -> Error:
	if listen:
		return _server.listen(port)
	elif _server.is_listening():
		_server.stop()
		return OK
	return ERR_SKIP


func disconnect_peer(ip: String) -> Error:
	var found_stream := _find_stream_by_ip(ip)
	if found_stream:
		found_stream.disconnect_from_host()
		return OK
	else:
		return ERR_DOES_NOT_EXIST


func send_packet(ip: String, packet: PackedByteArray) -> Error:
	var found_stream := _find_stream_by_ip(ip)
	if found_stream:
		var full_packet := MCTypes.encode_varint(packet.size())
		full_packet.append_array(packet)
		return found_stream.put_data(full_packet)
	else:
		return ERR_DOES_NOT_EXIST


func _try_read_packet(stream: StreamPeerTCP) -> PackedByteArray:
	_validate_or_remove_stream_buffer(stream)
	var buffer: Dictionary = _stream_buffers[stream]
	var packet_len: int = buffer["packet_len"]
	var data: PackedByteArray = buffer["data"]
	
	if packet_len != -1:
		if stream.get_available_bytes() >= packet_len:
			var request: PackedByteArray = stream.get_data(packet_len)[1]
			return request
	else:
		var next_byte := stream.get_u8()
		data.append(next_byte)
		if (next_byte & 0x80) == 0:
			var decode := MCTypes.decode_varint(data)
			if decode.error:
				return []
			buffer["packet_len"] = decode.value
			data.clear()
		buffer["data"] = data
	return []


func _find_stream_by_ip(ip: String) -> StreamPeerTCP:
	for stream in active_connections:
		if stream.get_connected_host() == ip:
			return stream
	return null


func _validate_or_remove_stream_buffer(stream: StreamPeerTCP) -> void:
	if not _stream_buffers.has(stream):
		_stream_buffers[stream] = {"packet_len": -1, "data": PackedByteArray()}
	elif not active_connections.has(stream):
		_stream_buffers.erase(stream)
