@icon("res://assets/chest_minecart.png")
class_name PacketsHandler
extends DotBackend


signal send_pong_answer(client: StreamPeerTCP, packet: PackedByteArray)


# @private
var _unhandled_packets: Array[Packet]


# @public
func handle_packets() -> void:
	for packet in _unhandled_packets:
		if packet.author.get_status() in [StreamPeerTCP.STATUS_ERROR, StreamPeerTCP.STATUS_NONE]:
			_unhandled_packets.erase(packet)
		_packet_id_matching(packet)


# @private
func _on_packet_recieved(data: PackedByteArray, source: StreamPeerTCP) -> void:
	var translated_packet := Packet.decode_packet(data)
	translated_packet.author = source
	_unhandled_packets.append(translated_packet)

func _packet_id_matching(packet: Packet) -> void:
	match packet.packet_id:
		Packet.STATUS:
			pass
		Packet.PING:
			send_pong_answer.emit(packet.author, packet._original_data)
