@icon("uid://clyal71chi4w1")
class_name Backend
extends BackendModule
## This node handles the backend of the server and provides basic functionality
## to the API. 
##
## This node is used by the Dot Server for stuff like [Networking], UUIDs,
## World gen, logger and file access. It provides easy access to the functionality
## of it's submodules


signal peer_connected(stream: StreamPeerTCP)
signal peer_disconnected(ip: String)
signal packet_recieved(payload: PackedByteArray)


@export_range(1024, 65535) var port: int = 25565
@export var bind_address: String = "*"
@export var autostart: bool = true


@onready var logger: BackendLogger = $Logger as BackendLogger

@onready var _server_manager: ServerManager = $Networker/ServerManager as ServerManager
@onready var _clients_manager: ClientsManager = $Networker/ClientsManager as ClientsManager
@onready var _packet_router: PacketsRouter = $Networker/PacketRouter as PacketsRouter


# EXPOSED "API" ------------------------------------------------------------------------------------

func start_server() -> void:
	logger.loginfo("Starting TCP server...")
	
	var err := _server_manager.start_listening(port, bind_address)
	if err:
		logger.logerror(
				"TCP server did not start - error occurred: %s"\
				% [error_string(err)])
		return
	
	logger.loginfo(
			"TCP server started successfully on port: %s with bind address: \"%s\""\
			% [port, bind_address])


func stop_server() -> void:
	logger.loginfo("Stopping the TCP server...")
	_server_manager.stop_listening()
	logger.loginfo("TCP server stopped!")



# Private functionality ----------------------------------------------------------------------------


func _ready() -> void:
	if autostart:
		start_server()


func _process(_delta: float) -> void:
	if not _server_manager._tcp_server.is_listening():
		return
	
	var new_peer: StreamPeerTCP = _server_manager.take_incomming_connection()
	if new_peer != null:
		logger.loginfo(
				"New peer connected: %s:%s" \
				% [new_peer.get_connected_host(), new_peer.get_connected_port()])
		_clients_manager.set_stream_state(new_peer) 
	
	_clients_manager.poll_connections()
	
	var active_streams: Array[StreamPeerTCP] = _clients_manager.get_active_streams()
	if active_streams.is_empty():
		return
	
	for stream in active_streams:
		var packet: PackedByteArray = _server_manager.get_incomming_payload(stream)
		if packet.is_empty():
			continue
		
		logger.loginfo(
				"Server recieved a packet of length: %s and payload: \n%s" \
				% [packet.size(), BytesFormatter.xxdlike(packet)])
		var response: PackedByteArray = _packet_router.route_packets(stream, packet)
		if response.is_empty():
			continue
		
		logger.loginfo(
				"Server answers with packet of length: %s and payload: \n%s" \
				% [response.size(), BytesFormatter.xxdlike(response)])
		var err := _server_manager.send_packet(stream, response)
		if err:
			logger.logwarning(
				"There was an unexpected error while trying to send a response packet: %s" \
				% [error_string(err)])
	# end
