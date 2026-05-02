class_name ConfigProtocol
extends PacketProtocol
## CRITICAL: Should always be directly placed under the [PacketsRouter] that is
## connected with this [PacketProtocol]
##
## For how this protocol works check [url=https://minecraft.wiki/w/Java_Edition_protocol/Packets#Handshaking]
## this minecraft.wiki article[/url]


enum {
	CLIENT_INFO = 0x00
	}


func get_response_packet(stream: StreamPeerTCP, request: PackedByteArray) -> PackedByteArray:
	var packets_router: PacketsRouter = self.get_parent()
	
	var logger := packets_router._logger
	
	var packet_id: int = request.decode_u8(0)
	match packet_id:
		CLIENT_INFO:
			var client_info: Dictionary = {
				"locale": "",
				"view_distance": -1,
				"chat_mode": -1,
				"colors": null,
				"displayed_skin_parts": 0x00,
				"main_hand": -1,
				"enable_text_filtering": null,
				"allow_server_listings": null,
				"particle_status": -1,
				}
			
			var locale_decode := TypesConverter.decode_string(request, 1)
			if locale_decode.error:
				locale_decode.value = "en_us"
			client_info["locale"] = locale_decode.value
			
			client_info["view_distance"] = request[1 + locale_decode.byte_length]
			client_info["chat_mode"] = request[2 + locale_decode.byte_length]
			client_info["colors"] = request[3 + locale_decode.byte_length] as bool
			client_info["displayed_skin_parts"] = request[4 + locale_decode.byte_length]
			client_info["main_hand"] = request[5 + locale_decode.byte_length]
			client_info["enable_text_filtering"] = request[6 + locale_decode.byte_length] as bool
			client_info["allow_server_listings"] = request[7 + locale_decode.byte_length] as bool
			client_info["particle_status"] = request[8 + locale_decode.byte_length]
			
			logger.loginfo(
					"Player information: \nlocale: %s\nview_distance: %s" % 
					[client_info.locale, client_info.view_distance])
			
			# BUG: Replace with correct implementation in the future
			return _create_finish_config_payload()
	
	return [] # This is a handshake - dont send a response


# Private ------------------------------------------------------------------------------------------

func _create_finish_config_payload() -> PackedByteArray:
	return [0x03]
