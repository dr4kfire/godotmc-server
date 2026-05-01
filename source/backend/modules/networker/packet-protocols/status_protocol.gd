class_name StatusProtocol
extends PacketProtocol
## CRITICAL: Should always be directly placed under the [PacketRouter] that is
## connected with this [PacketProtocol]
##
## For how this protocol works check [url=https://minecraft.wiki/w/Java_Edition_protocol/Server_List_Ping]
## this minecraft.wiki article[/url]


enum {
	ID_STATUS_REQUEST = 0x00,
	ID_PING_REQUEST = 0x01
	}


func get_response_packet(_stream: StreamPeerTCP, request: PackedByteArray) -> PackedByteArray:
	var decode := TypesConverter.decode_varint(request)
	if decode.error:
		return []
	
	match decode.value as int:
		ID_STATUS_REQUEST:
			return _handle_status_request()
		ID_PING_REQUEST:
			return _handle_ping_request(request.slice(1)) # Skip first byte (id)
		
	return []


# Private ------------------------------------------------------------------------------------------

func _handle_status_request() -> PackedByteArray:
	print("Handling Status Request")
	var data: Dictionary = {
		"version": {
			"name": "1.21.10",
			"protocol": 773
		},
		"players": {
			"max": 20,
			"online": 0
		},
		"description": {
			"text": "A Dot Minecraft server"
		},
		"favicon": "data:image/png;base64,0", # Ensure this is valid base64 or empty
		"enforcesSecureChat": false
	}
	var json_string := JSON.stringify(data)
	
	var response_payload := PackedByteArray()
	
	# Packet ID 0x00 for Response
	response_payload.append(0x00)
	# JSON String (VarInt length + String data)
	var encoded_string := TypesConverter.encode_string(json_string)
	response_payload.append_array(encoded_string)
	
	return response_payload


func _handle_ping_request(payload: PackedByteArray) -> PackedByteArray:
	# Ping Request contains exactly 8 bytes (the payload)
	if payload.size() != 8:
		printerr("Invalid Ping length: %d" % payload.size())
		return []
		
	# Pong Response Packet ID is 0x01
	var response := PackedByteArray()
	response.append(0x01) 
	response.append_array(payload) # Echo back the exact 8 bytes
	
	return response
