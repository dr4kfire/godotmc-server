@icon("uid://sb11uu1fw04l")
class_name ClientsManager
extends BackendModule
## Manages the connected [StreamPeerTCP]s
##
## Used for keeping track of who, and in what state is connected as well as other
## useful stuff


## Used by the [PacketRouter] to know which protocol to use
enum ProtocolState {
	NONE,
	STATUS,
	LOGIN,
	CONFIG,
	PLAY,
	}


var _active_streams: Dictionary[StreamPeerTCP, ClientsManager.ProtocolState]

 
# Connection methods -------------------------------------------------------------------------------

## Disconnects the provided [param stream] and [method Object.free]s it
func disconnect_stream(stream: StreamPeerTCP) -> void:
	_active_streams.erase(stream)
	stream.disconnect_from_host()


## Updates the stream buffers with new information and disconnects streams that
## are in the error, disconnected or still connecting state
func poll_connections() -> void:
	for stream: StreamPeerTCP in _active_streams.keys():
		stream.poll()
		if not stream.get_status() == StreamPeerTCP.STATUS_CONNECTED:
			disconnect_stream(stream)


# Getters ------------------------------------------------------------------------------------------

## Returns an array of active [StreamPeerTCP]
func get_active_streams() -> Array[StreamPeerTCP]:
	var array: Array[StreamPeerTCP] = []
	for stream in _active_streams.keys():
		array.append(stream)
	return array


## Returns the [param stream]'s [enum ClientsManager.ProtocolState] 
func get_stream_state(stream: StreamPeerTCP) -> ClientsManager.ProtocolState:
	return _active_streams[stream]


# Setters ------------------------------------------------------------------------------------------

## Useed to add a new stream or change its state
func set_stream_state(stream: StreamPeerTCP, state := ProtocolState.NONE) -> void:
	_active_streams[stream] = state
