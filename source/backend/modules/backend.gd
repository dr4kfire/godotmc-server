@icon("res://assets/comparator.png")
class_name Backend
extends BackendModule
## This node handles the backend of the server and provides basic functionality
## to the API. 
##
## This node is used by the Dot Server for stuff like [Networking], UUIDs,
## World gen, logger and file access


@export var _networking: Networking
@export var _protocol_handler: ProtocolHandler

@export var _logger: BackendLogger


func _ready() -> void:
	_logger.loginfo("Server is starting ...")
	var err := _networking.change_listening_state(true)
	if err:
		_logger.logerror(
				"An error occured while attempting to listen on port %s: %s" %\
				[25565, error_string(err)])
		return
	_logger.loginfo("Server has started successfuly!")


func _on_networking_new_packet_recieved(ip: String, packet: PackedByteArray) -> void:
	_logger.loginfo("Recieved a packet from ip: %s" % ip)
	_logger.loginfo("Recieved packet: \n%s" % Hexy.format_to_xxd(packet))
	var response: PackedByteArray = _protocol_handler.handle_packet(packet)
	if response.is_empty():
		return
	var err := _networking.send_packet(ip, response)
	if err:
		_logger.loginfo("Couldn't send a response packet: %s" % error_string(err))
		return
	_logger.loginfo("Answered with response packet: \n%s" % Hexy.format_to_xxd(response))
