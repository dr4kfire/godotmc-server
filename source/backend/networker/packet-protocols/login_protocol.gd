class_name LoginProtocol
extends PacketProtocol
## CRITICAL: Should always be directly placed under the [PacketsRouter] that is
## connected with this [PacketProtocol]
##
## For how this protocol works check [url=https://minecraft.wiki/w/Java_Edition_protocol/Packets#Login]
## this minecraft.wiki article[/url]


@export var server_id: String = ""
@export var public_key: PackedByteArray

@export var should_authenticate: bool = false
@export var encrypt: bool = false
@export var compress_packets: bool = false


enum {
	LOGIN_START = 0x00,
	ENCRYTPION_RESPONSE = 0x02,
	LOGIN_ACK = 0x03
	}


var _logger: BackendLogger


func get_response_packet(stream: StreamPeerTCP, request: PackedByteArray) -> PackedByteArray:
	var packets_router: PacketsRouter = self.get_parent()
	_logger = packets_router._logger
	var protocol_id: int = request[0] # Never bigger than one byte - read as a normal integer
	
	match protocol_id:
		LOGIN_START:
			var decode := TypesConverter.decode_string(request, 1)
			if decode.error:
				return []
			
			var player_name: String = decode.value
			var player_uuid: PackedByteArray = request.slice(decode.byte_length + 1)
			
			_logger.loginfo(
					"A player with name: \"%s\" and uuid: %s wants to login!" \
					% [player_name, player_uuid.hex_encode()])
			
			if encrypt:
				return _create_encryption_request_payload()
			elif compress_packets:
				return [] # TODO
			
			return _create_login_success_payload(player_uuid, player_name)
		
		LOGIN_ACK:
			packets_router._clients_manager.set_stream_state(
						stream, ClientsManager.ProtocolState.CONFIG
						)
			return []
	
	return [] # This is a handshake - dont send a response


# Private ------------------------------------------------------------------------------------------

func _create_encryption_request_payload() -> PackedByteArray:
	return []


func _create_login_success_payload(uuid: PackedByteArray, username: String) -> PackedByteArray:
	var payload: PackedByteArray
	payload.append(0x02)
	payload.append_array(uuid)
	payload.append_array(TypesConverter.encode_string(username))
	payload.append(0x00)
	return payload
