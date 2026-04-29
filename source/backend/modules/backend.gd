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


func _ready() -> void:
	Printer.print_log("Server is starting ...")
	var err := _networking.change_listening_state(true)
	if err:
		Printer.print_error(
				"An error occured while attempting to listen on port %s: %s" %\
				[25565, error_string(err)])
		return
	Printer.print_log("Server has started successfuly!")


func _on_networking_new_packet_recieved(ip: String, packet: PackedByteArray) -> void:
	Printer.print_log("Recieved a packet from ip: %s" % ip)
	Printer.print_log("Recieved packet: \n       %s" % Hexy.format_to_xxd(packet))
	var response := _protocol_handler.get_status_mode_response(packet)
	if response.is_empty():
		return
	var err := _networking.send_packet(ip, response)
	if err:
		Printer.print_warning("Couldn't send a response packet: %s" % error_string(err))
		return
	Printer.print_log("Answered with response packet: \n       %s" % Hexy.format_to_xxd(packet))
