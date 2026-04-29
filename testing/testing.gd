extends Node

#class PacketsServer extends SocketServer:
	#pass
#
#var socket_listener: PacketsServer

#extends Node;

const DEFAULT_PORT: int = 25565;
var server: TCPServer;


func use_stream(stream: StreamPeerTCP):
	var packet_len: int = -1
	var packet_data: PackedByteArray
	var varint_data: PackedByteArray
	
	# Keep polling until we have the complete packet
	while true:
		stream.poll()  # Poll repeatedly, not just once
		
		if packet_len == -1:
			# Still reading the VarInt length prefix
			if stream.get_available_bytes() > 0:
				var byte = stream.get_u8()
				varint_data.append(byte)
				
				if (byte & 0x80) == 0:
					# VarInt complete
					var decode = MCTypes.decode_varint(varint_data)
					if decode.error != OK:
						printerr("CONVERTING BYTES TO VARINT: %s" % error_string(decode.error))
						return
					packet_len = decode.value
					varint_data.clear()
		else:
			# Reading packet data
			if stream.get_available_bytes() >= packet_len:
				packet_data = stream.get_data(packet_len)[1]
				break
		
		await get_tree().process_frame  # Yield to avoid busy-waiting
	
	print("Data: 0x%s with len: %s" % [packet_data.hex_encode(), packet_len])



func _ready():
	server = TCPServer.new();
	server.listen(DEFAULT_PORT);


func _process(_dt: float):
	while server.is_connection_available():
		var stream: StreamPeerTCP = server.take_connection();
		use_stream(stream);
