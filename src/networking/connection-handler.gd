## Takes care of StreamPeerTCP (recieves packets, sends packets)

@icon("uid://df88igcu7fbgg") ## fishing_rod.png
class_name ConnectionHandler
extends Minecraft


signal new_packet_recieved(packet: PackedByteArray)

@export var server: MCTCPServerHandler
var current_connection: StreamPeerTCP


func handle_connections() -> void:
	var stream: StreamPeerTCP = current_connection
	if not stream:
		current_connection = server.server.take_connection()
		return
	elif stream.get_status() in [StreamPeerTCP.STATUS_ERROR, StreamPeerTCP.STATUS_NONE]:
		stream.disconnect_from_host()
		current_connection = server.server.take_connection()
		return
	
	stream.poll()
	
	if stream.get_status() == StreamPeerTCP.STATUS_CONNECTING:
		return
	
	# Read the packet length VarInt from stream
	var decode: Array = MCTypes.decode_varint_from_stream(stream)
	if decode[0] != OK:
		printerr("[ERROR]: Error decoding varint from stream: %s" % error_string(decode[0]))
		return
	
	var packet_length: int = decode[1]
	var length_bytes_read: int = decode[2]
	
	# Read the packet data (everything after the length VarInt)
	var remaining_bytes = packet_length - length_bytes_read
	var packet_body_result: Array = stream.get_partial_data(remaining_bytes)
	if packet_body_result[0] != OK:
		printerr("[ERROR]: Error fetching packet body: %s" % error_string(packet_body_result[0]))
		return
	
	# Reconstruct full packet: length VarInt + packet data
	var packet := MCTypes.encode_varint(packet_length)
	packet.append_array(packet_body_result[1] as PackedByteArray)
	
	new_packet_recieved.emit(packet)


func send_packet(packet: PackedByteArray) -> void:
	var error: Error = current_connection.put_data(packet)
	if error != OK:
		printerr("[ERROR]: Unexpected error occured while sending packet: %s" % error_string(error))
