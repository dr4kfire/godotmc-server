@icon("res://assets/oak_boat.png")
class_name ClientsHandler
extends Node


signal client_sent_packet(data: PackedByteArray, source: Client)

# @public
var active_clients: Array[Client]


func handle_clients() -> void:
	for client in active_clients:
		if not client:
			active_clients.erase(client)
			continue 
		
		client.stream.poll()
		
		if client.stream.get_status() in [StreamPeerTCP.STATUS_NONE, StreamPeerTCP.STATUS_ERROR]:
			active_clients.erase(client)
			continue
		
		if client.stream.get_available_bytes() > 0:
			_handle_incomming_packet(client)

func disconnect_all_clients() -> void:
	active_clients.clear()


# @private
func _on_client_connected(stream: StreamPeerTCP) -> void:
	var client := Client.new()
	client.stream = stream
	active_clients.append(client)

func _handle_incomming_packet(client: Client) -> void:
	var decode_return := MCTypes.decode_varint_from_stream(client.stream)
	if decode_return.error != OK:
		return
	
	var result: Array = client.stream.get_partial_data(decode_return.value as int)
	var error: Error = result[0]
	if error != OK:
		return
	var data: PackedByteArray = result[1]
	client_sent_packet.emit(data, client)
