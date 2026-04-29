class_name ProtocolResource
extends Resource

enum BIND {
	SERVERBOUND,
	CLIENTBOUND
	}

@export var protocol_version: int = 773
@export_enum("1.21.10") var version: String

@export var packet_id: int = 0x00
@export var bind: BIND = BIND.SERVERBOUND
@export var structure: Dictionary[String, MCTypes.TYPES] = {}
