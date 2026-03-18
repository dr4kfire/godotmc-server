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


func handle_incomming_packet(raw_packet: PackedByteArray) -> void:
	var packet: Packet = Packet.decode_packet(raw_packet)
	
	match packet.fields[Packet.FIELD_NAMES.ID]:
		Packet.PACKET_IDS.STATUS:
			var data: PackedByteArray = packet.fields[Packet.FIELD_NAMES.DATA]
			if data.size() > 1:
				return
			var json_str: String = minecraft_server.get_status_json()
			var response: PackedByteArray = HandshakePacket.generate_response(json_str)
			connection_handler.send_packet(response)
		
		Packet.PACKET_IDS.PING:
			connection_handler.send_packet(raw_packet)
