@icon("uid://de7exee6nph3f")
class_name ServerManager
extends BackendModule
## Node used for the low-level TCPServer handling connections, packets, etc.
##
## This class implements the backend functionality for the TCP server and
## handles the incomming traffic providing it to the server API for it to be
## later used by the plugins and other stuff.


var _tcp_server: TCPServer = TCPServer.new()


# Server state -------------------------------------------------------------------------------------

func start_listening(port: int, bind_addr: String = "*") -> Error:
	return _tcp_server.listen(port, bind_addr)


func stop_listening() -> void:
	_tcp_server.stop()


# Connections --------------------------------------------------------------------------------------

func take_incomming_connection() -> StreamPeerTCP:
	if not _tcp_server.is_listening() or not _tcp_server.is_connection_available():
		return null
	return _tcp_server.take_connection()


# Packets ------------------------------------------------------------------------------------------

func get_avaliable_packets(stream: StreamPeerTCP) -> PackedByteArray:
	if stream.get_available_bytes() == 0:
		return []
	
	var buffer: PackedByteArray = []
	var packet_len: int = -1
	while stream.get_status() == StreamPeerTCP.STATUS_CONNECTED:
		stream.poll()
		
		if packet_len == -1:
			# Lets try to decode the varint length
			var next_byte := stream.get_u8()
			buffer.append(next_byte)
			if (next_byte & 0x80) == 0:
				var decode := TypesConverter.decode_varint(buffer)
				if decode.error:
					return [] # Packet invalid - return
				packet_len = decode.value as int
		else:
			var result := stream.get_partial_data(packet_len)
			return result[1]
	return []


func send_packet(stream: StreamPeerTCP, packet: PackedByteArray, has_length: bool = false) -> Error:
	if not _tcp_server.is_listening():
		return Error.ERR_UNAVAILABLE
	if stream == null:
		return Error.ERR_DOES_NOT_EXIST
	
	if not has_length:
		var encode_ret := TypesConverter.encode_varint_ex(packet.size())
		if encode_ret.error:
			return encode_ret.error
			
		var new_packet: PackedByteArray = encode_ret.data
		new_packet.append_array(packet)
		packet = new_packet
	
	stream.put_data(packet)
	return Error.OK
