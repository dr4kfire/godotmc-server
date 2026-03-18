## Base class for all zlib compressed packet resources

@icon("uid://cxrx1t8ffqbnq") ## shulker_box.png
@abstract
class_name PacketCompressed
extends Packet

enum COMPRESSED_FIELD_NAMES {
	DATA_LENGTH = MCTypes.VARINT,
	DATA,
	}

@export var compressed: bool
