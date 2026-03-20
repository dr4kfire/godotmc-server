## Reads packets, sends signals based on those packets and
## constructs response packets

@icon("uid://c3b7s0x2b4fcu") ## chest_minecart.png
class_name PacketsHandler
extends Minecraft


enum STATES {
	NONE = 0,
	STATUS = 1,
	LOGIN = 2,
	TRANSFER = 3,
	}


@export var minecraft_server: MinecraftServer
@export var connection_handler: ConnectionHandler
var current_state: STATES = STATES.NONE
var packet_streams: Array[PackedByteArray]
var packet_stream_buffer: PackedByteArray = PackedByteArray()


func send_packet(packet: PackedByteArray) -> void:
	connection_handler.current_connection.put_data(packet)


func get_incomming_bytes() -> void:
	var conneciton: StreamPeerTCP = connection_handler.current_connection
	if connection_handler.current_connection.get_available_bytes() < 1:
		return
	
	while conneciton.get_available_bytes() >= 1:
		var byte: int = conneciton.get_8()
		packet_stream_buffer.append(byte)
	
	var buffer_copy := packet_stream_buffer.duplicate()
	while buffer_copy.size() > 0:
		var length := Packet.get_packet_length(buffer_copy)
		if length == 0:
			break
		var slice := buffer_copy.slice(0, length)
		buffer_copy = buffer_copy.slice(length)
		packet_streams.append(slice)
	packet_stream_buffer.clear()
	
	var raw_packet = packet_streams.pop_back()
	print("[INFO]: Got a packet: %s" % raw_packet)
	if not raw_packet:
		return
	handle_incomming_packet(raw_packet as PackedByteArray)


func handle_incomming_packet(raw_packet: PackedByteArray) -> void:
	var packet: Packet = Packet.decode_packet(raw_packet)
	print("[INFO]: Decoded packet's ID: %s" % packet.fields[Packet.FIELD_NAMES.ID])
	
	match packet.fields[Packet.FIELD_NAMES.ID]:
		## If the packet has data we should ignore it and wait for 
		## the next one which should be empty then we send the 
		## `status_response` packet to the connected client
		Packet.PACKET_IDS.STATUS:
			var data: PackedByteArray = packet.fields[Packet.FIELD_NAMES.DATA]
			if data.size() > 1 and not data.get(0) == 0x00:
				return
			var json_str: String = minecraft_server.get_status_json()
			var response: PackedByteArray = HandshakePacket.generate_response(json_str)
			connection_handler.send_packet(response)
		
		## just respond with the exact same packet
		Packet.PACKET_IDS.PING:
			print("[INFO]: Send pong packet back to client")
			send_packet(raw_packet)
