## Base class for all packet resources

@icon("uid://b4y87s026solw") ## chest.png
class_name Packet
extends Resource

enum FIELD_NAMES {
	LENGTH = MCTypes.VARINT,
	ID = MCTypes.UNSIGNED_SHORT,
	DATA,
	}

@export var raw_packet: PackedByteArray = []
@export var fields: Dictionary[FIELD_NAMES, Variant]


static func decode_packet(raw: PackedByteArray) -> Packet:
	var new_packet: Packet = Packet.new()
	
	var decode: Array = MCTypes.decode_varint(raw)
	if decode
	
	var packet_len: int = decode[2]
	var packet_id: int = raw.decode_u8(decode[1])
	var data: PackedByteArray = raw.slice(decode[1]+2)
	
	
	
	new_packet.fields.set(FIELD_NAMES.LENGTH, packet_len)
	new_packet.fields.set(FIELD_NAMES.ID, packet_id)
	new_packet.fields.set(FIELD_NAMES.DATA, data)
	new_packet.raw_packet = raw
	return new_packet

enum PACKET_IDS {
	STATUS = 0x00,
	PING = 0x01,
	}
