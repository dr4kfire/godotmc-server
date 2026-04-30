class_name ProtocolHandler
extends BackendModule
## Handles protocols of minecraft packets by collecting necessery data for
## a responce and sends it back
##
## For more information on each protocol and how they funciton check out 
## [url=https://minecraft.wiki/w/Java_Edition_protocol]minecraft.wiki[/url]

enum State {
	HANDSHAKE,
	STATUS,
	LOGIN,
	PLAY
}

var current_state = State.HANDSHAKE

# Packet IDs
const HANDSHAKE_ID = 0
const STATUS_REQUEST_ID = 0
const PING_REQUEST_ID = 1

func reset_state():
	"""Call this when a client disconnects and a new client connects."""
	current_state = State.HANDSHAKE

func handle_packet(packet: PackedByteArray) -> PackedByteArray:
	# Assuming the length prefix has already been removed by your stream reader
	# and 'packet' starts with the Packet ID.
	
	if packet.is_empty():
		return []

	# 1. Read Packet ID (VarInt)
	var id_result := MCTypes.decode_varint(packet, 0)
	if id_result.error != OK:
		return []
	
	var packet_id: int = id_result.value
	# Calculate where the payload starts (1 byte because ID 0 is 1 byte)
	# Note: We use id_result.byte_length in case packet IDs > 127 exist in future
	var offset := id_result.byte_length
	var payload := packet.slice(offset)
	
	# 2. Route based on State
	match current_state:
		State.HANDSHAKE:
			if packet_id == HANDSHAKE_ID:
				return _handle_handshake(payload)
				
		State.STATUS:
			if packet_id == STATUS_REQUEST_ID:
				return _handle_status_request()
			elif packet_id == PING_REQUEST_ID:
				return _handle_ping_request(payload)
				
	return []

# --- Handlers ---

func _handle_handshake(payload: PackedByteArray) -> PackedByteArray:
	# Handshake Format:
	# Protocol Version (VarInt)
	# Server Address (String)
	# Server Port (UShort)
	# Next State (VarInt) -> 1 for Status, 2 for Login
	
	var cursor := 0
	
	# 1. Read Protocol Version
	var protocol_version := MCTypes.decode_varint(payload, cursor)
	if protocol_version.error != OK:
		return []
	cursor += protocol_version.byte_length
	
	print("Client Protocol: %s" % protocol_version.value)
	
	# 2. Read Server Address (String -> VarInt Length + UTF-8 Bytes)
	var server_address_data := MCTypes.decode_string(payload, cursor)
	if server_address_data.error != OK:
		return []
	
	var server_address: String = server_address_data.value
	cursor += server_address_data.byte_length
	
	print("Client Host: %s" % server_address)
	
	# 3. Read Server Port (2 bytes, Big Endian)
	if payload.size() < cursor + 2:
		return []
	var server_port := payload.decode_u16(cursor)
	cursor += 2
	
	print("Client Port: %s" % server_port)
	
	# 4. Read Next State (VarInt)
	var next_state_data := MCTypes.decode_varint(payload, cursor)
	if next_state_data.error != OK:
		return []
	
	var next_state: int = next_state_data.value
	
	# CRITICAL: Update the server state based on what the client requested
	if next_state == 1:
		current_state = State.STATUS
		print("Client switched to STATUS state")
	elif next_state == 2:
		current_state = State.LOGIN
		print("Client switched to LOGIN state")
		
	# IMPORTANT: Do NOT send a response to a Handshake packet!
	return [] 

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
	var encoded_string := MCTypes.encode_string(json_string)
	response_payload.append_array(encoded_string)
	
	return response_payload

func _handle_ping_request(payload: PackedByteArray) -> PackedByteArray:
	print("Handling Ping Request")
	
	# Ping Request contains exactly 8 bytes (the payload)
	if payload.size() != 8:
		printerr("Invalid Ping length: %d" % payload.size())
		return []
		
	# Pong Response Packet ID is 0x01
	var response := PackedByteArray()
	response.append(0x01) 
	response.append_array(payload) # Echo back the exact 8 bytes
	
	print("Answered with Pong")
	return response
