## The first packet to be sent by the client to the server
## to establish a connection

class_name HandshakePacket
extends Packet

const ID: int = PACKET_IDS.STATUS

enum DATA_FIELDS {
	PROTOCOL = MCTypes.VARINT,
	ADDRESS = MCTypes.STRING,
	PORT = MCTypes.UNSIGNED_SHORT,
	NEXT_STATE = MCTypes.VARINT
	}

@export var data: Dictionary[DATA_FIELDS, Variant]


static func generate_response(json_str: String) -> PackedByteArray:
	var new_packet := PackedByteArray()
	var encoded_json: PackedByteArray = MCTypes.encode_string(json_str)
	var length: PackedByteArray = MCTypes.encode_varint(encoded_json.size())
	new_packet.append_array(length)
	new_packet.append_array(encoded_json)
	return new_packet
