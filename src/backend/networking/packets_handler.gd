@icon("res://assets/chest_minecart.png")
class_name PacketsHandler
extends Networking


signal send_packet(reciever: Client, packet: PackedByteArray)


# @private
@export var _backend: DotBackend


# @private
func _on_packet_recieved(data: PackedByteArray, source: Client) -> void:
	var decoded_packet := MCPacket.decode_packet(data)
	_packet_id_matching(decoded_packet, source)


func _packet_id_matching(packet: MCPacket, client: Client) -> void:
	match packet.id:
		MCPacket.ID_STATUS:
			if client.state == Client.STATE_NONE:
				return
			send_packet.emit(client, _fetch_status_packet())
		MCPacket.ID_PING:
			send_packet.emit(client, packet.encode_packet())


func _fetch_status_packet() -> PackedByteArray:
	var data: Dictionary = _backend.game_server.get_server_status()
	var json_string: String = JSON.stringify(JSON.from_native(data))
	var serialized_data: PackedByteArray = MCTypes.encode_string(json_string)
	
	var packet_body: PackedByteArray = []
	packet_body.append(MCPacket.ID_STATUS)
	packet_body.append_array(MCTypes.encode_varint(serialized_data.size()))
	packet_body.append_array(serialized_data)
	
	return MCTypes.encode_varint(packet_body.size()) + packet_body
