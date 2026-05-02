@icon("uid://cb3icoilb53jm")
class_name PacketsRouter
extends BackendModule
## This node routs the packets through the right protocol modules to insure
## correct communication


enum ProtocolState {
	NONE = 0,
	STATUS = 1,
	LOGIN = 2,
	TRANSFER = 3,
	PLAY = 4
	}


@export var _protocols: Dictionary[PacketsRouter.ProtocolState, PacketProtocol]
@export var _clients_manager: ClientsManager
@export var _logger: BackendLogger


# Routing methods ----------------------------------------------------------------------------------

func route_packets(sender_stream: StreamPeerTCP, packet: PackedByteArray) -> PackedByteArray:
	var state := _clients_manager.get_stream_state(sender_stream) as PacketsRouter.ProtocolState
	
	if _protocols.has(state):
		var protocol: PacketProtocol = _protocols[state]
		return protocol.get_response_packet(sender_stream, packet)
	
	return []
