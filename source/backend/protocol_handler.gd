
class_name ProtocolHandler
extends BackendModule
## Handles protocols of minecraft packets by collecting necessery data for
## a responce and sends it back
##
## For more information on each protocol and how they funciton check out 
## [url=https://minecraft.wiki/w/Java_Edition_protocol]minecraft.wiki[/url]


enum status_ids {
	STATUS_REQUEST = 0x00, 
	STATUS_RESPONSE = 0x00,
	
	PING_REQUEST = 0x01,
	PING_RESPONSE = 0x01
	}

enum login_ids {
	LOGIN,
	DISCONNECT,
	}


func get_status_mode_response(packet: PackedByteArray) -> PackedByteArray:
	var packet_id: int = _decode_protocol_id(packet)
	if packet_id == -1:
		return []
	match packet_id:
		status_ids.STATUS_REQUEST:
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
				"favicon": "data:image/png;base64,0%s" % [""],
				"enforcesSecureChat": false
			}
			var string := MCTypes.encode_string(JSON.stringify(data))
			var response: PackedByteArray = [0]
			response.append_array(string)
			return response
		status_ids.PING_REQUEST:
			return packet
		_:
			return []


func _decode_protocol_id(packet: PackedByteArray) -> int:
	var decode := MCTypes.decode_varint(packet)
	if decode.error:
		return -1
	return decode.value
