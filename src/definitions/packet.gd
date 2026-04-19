## Base class for all packet resources

@icon("res://assets/chest.png")
class_name Packet
extends Resource


enum {
	STATUS = 0x00,
	PING   = 0x01,
	}


var author: StreamPeerTCP
@export var is_zlib_compressed: bool = false
@export var data_length: int = -1
@export var packet_id: int = -1
@export var packet_data: PackedByteArray

var _original_data: PackedByteArray


static func decode_packet(data: PackedByteArray) -> Packet:
	var raw_packet: PackedByteArray = data.duplicate()
	var translated_packet: Packet = Packet.new()
	
	var len_result := MCTypes.decode_varint(raw_packet)
	translated_packet.data_length = len_result.value as int
	raw_packet = raw_packet.slice(len_result.byte_length)
	
	var id_result := MCTypes.decode_varint(raw_packet)
	translated_packet.packet_id = id_result.value as int
	
	translated_packet.packet_data = raw_packet.slice(id_result.byte_length)
	translated_packet._original_data = data
	return translated_packet
