@icon("res://assets/oak_boat.png")
class_name ClientsHandler
extends DotBackend


enum ClientState {
	LURKER,
	LOGIN,
	}


var active_clients: Dictionary[StreamPeerTCP, ClientState]
