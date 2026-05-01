class_name NoneProtocol
extends PacketProtocol
## CRITICAL: Should always be directly placed under the [PacketRouter] that is
## connected with this [PacketProtocol]
##
## For how this protocol works check [url=https://minecraft.wiki/w/Java_Edition_protocol/Packets#Handshaking]
## this minecraft.wiki article[/url]


func get_response_packet(stream: StreamPeerTCP, request: PackedByteArray) -> PackedByteArray:
	var packets_router: PacketsRouter = self.get_parent()
	var intent: int = request.decode_u8(-1) # Never bigger than one byte - read as a normal integer
	
	match intent:
		1:
			packets_router._clients_manager.set_stream_state(
					stream, ClientsManager.ProtocolState.STATUS
					)
		_:
			packets_router._clients_manager.set_stream_state(
					stream, ClientsManager.ProtocolState.LOGIN
					)
	
	return [] # This is a handshake - dont send a response
