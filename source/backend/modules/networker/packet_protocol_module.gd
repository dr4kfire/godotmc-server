@icon("uid://drmog4y2ugqni")
@abstract
class_name PacketProtocol
extends BackendModule
## A base abstract class for protocol handling nodes
##
## CRITICAL: Should always be directly placed under the [PacketRouter] that is
## connected with this [PacketProtocol]


@abstract func get_response_packet(stream: StreamPeerTCP, request: PackedByteArray) -> PackedByteArray
