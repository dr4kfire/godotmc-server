
class_name Client
extends Resource

enum {
	STATE_NONE,
	STATE_STATUS,
	STATE_LOGIN
	}
var state := STATE_NONE
var protocol_version: int = -1
var stream: StreamPeerTCP
