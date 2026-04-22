## Base class for all packet resources

@icon("res://assets/shulker_box.png")
class_name MCPacket
extends Resource


enum {
	ID_STATUS = 0x00,
	ID_PING = 0x01,
	ID_LOGIN_SUCCESS = 0x02,
	ID_SET_COMPRESSION = 0x03,
	}


@export var id: int = -1
@export var data: PackedByteArray


static func decode_packet(packet_body: PackedByteArray) -> MCPacket:
	var curr_offset: int = 0
	var result_body_len := MCTypes.decode_varint(packet_body)
	if not result_body_len.error == OK:
		return null
	curr_offset += result_body_len.byte_length
	var data_length: int = result_body_len.value
	if data_length != 0:
		print("Packet is compressed! Skipping...")
		return null
	
	var result_id := MCTypes.decode_varint(packet_body, curr_offset)
	var decoded_packet := MCPacket.new()
	decoded_packet.id = result_id.value
	decoded_packet.data = packet_body.slice(curr_offset + result_id.byte_length)
	return decoded_packet

static func decode_from_stream(stream: StreamPeerTCP) -> MCPacket:
	var result := MCTypes.decode_varint_from_stream(stream)
	if not result.error == OK:
		return null
	var packet_length: int = result.value
	var packet_body: PackedByteArray = stream.get_data(packet_length)
	return decode_packet(packet_body)

func encode_packet() -> PackedByteArray:
	var packet_body: PackedByteArray = []
	packet_body.append_array(MCTypes.encode_varint(self.id))
	packet_body.append_array(MCTypes.encode_varint(self.data.size()))
	packet_body.append_array(self.data)
	return MCTypes.encode_varint(packet_body.size()) + packet_body

#@export var is_zlib_compressed: bool = false
#@export var data_length: int = -1
#@export var packet_id: int = -1
#@export var packet_data: PackedByteArray

#static func decode_packet(data: PackedByteArray) -> Packet:
	#var raw_packet: PackedByteArray = data.duplicate()
	#var translated_packet: Packet = Packet.new()
	#
	#var len_result := MCTypes.decode_varint(raw_packet)
	#translated_packet.data_length = len_result.value as int
	#raw_packet = raw_packet.slice(len_result.byte_length)
	#
	#var id_result := MCTypes.decode_varint(raw_packet)
	#translated_packet.packet_id = id_result.value as int
	#
	#translated_packet.packet_data = raw_packet.slice(id_result.byte_length)
	#translated_packet._original_data = data
	#return translated_packet
#
#func encode_packet() -> PackedByteArray:
	#var data_len := MCTypes.encode_varint(packet_data.size())
	#var id := MCTypes.encode_varint(packet_id)
	#var packet_body: PackedByteArray = id + data_len + packet_data
	#var length := MCTypes.encode_varint(packet_body.size())
	#return length + packet_body
