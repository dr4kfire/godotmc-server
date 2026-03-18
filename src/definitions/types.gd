## Used for converting PackedByteArrays into Godot readable
## types and Godot types into PackedByteArrays
##
## look at https://minecraft.wiki/w/Java_Edition_protocol/Packets
## for more info

@icon("uid://ceieefi4pf28n") ## knowledge_book
@abstract
class_name MCTypes
extends Minecraft


enum { ## TYPES
	BYTE = 1,                ## INT8
	UNSIGNED_BYTE = BYTE,    ## UNSIGNED INT8
	BOOLEAN = BYTE,          ## INT8
	   
	SHORT = 2,               ## INT16
	UNSIGNED_SHORT = 2,      ## UNSIGNED INT16
	INT = 4,                 ## INT32
	LONG = 8,                ## INT64
	
	FLOAT = 4,               ## FLOAT (32 bit)
	DOUBLE = 8,              ## FLOAT (64 bit)
	
	STRING = 0,              ## 1..(n*3)+3
	TEXT_COMPONENT = -1,     ## VARIES
	JSON_TEXT_COMPONENT = 0, ## 1..32767
	
	VARINT = 0,              ## 1..5  INT32
	VARLONG = 0,             ## 1..10 INT64
	}



## Returns an array [ERROR, NEW_OFFSET (next byte after the last one), 
## decoded value (null if unsuccessful)]
static func decode_boolean(packet: PackedByteArray, offset: int = 0) -> Array:
	if _is_outside_of_range(packet, offset):
		return [ERR_FILE_EOF, offset, null]
	var byte: int = packet[offset]
	if byte < 0 || byte > 1:
		return [ERR_INVALID_DATA, offset, null]
	return [OK, offset+1, byte as bool]


## Returns an array [ERROR, NEW_OFFSET (next byte after the last one), 
## decoded value (null if unsuccessful)]
static func decode_varint(packet: PackedByteArray, offset: int = 0) -> DecodeReturn:
	var ret := DecodeReturn.new()
	if _is_outside_of_range(packet, offset):
		ret.error = ERR_FILE_EOF
		return ret
	const SEGMENT_BITS := 0x7f
	const CONTINUE_BIT := 0x80
	
	var value: int = 0
	var position: int = 0
	var current_byte: int = 0x00
	var current_offset: int = offset
	while true:
		current_byte = packet.decode_u8(current_offset)
		var unmasked_value := (current_byte & SEGMENT_BITS) << position
		value = value | unmasked_value
		
		position += 7
		current_offset += 1
		
		if (current_byte & CONTINUE_BIT) == 0: break
		if (position >= 32):
			ret.error = ERR_INVALID_DATA
			return ret
	ret.byte_length = packet.slice(offset, current_offset).size()
	ret.error = OK
	ret.value = value as int
	return ret

static func decode_varint_(packet: PackedByteArray, offset: int) -> DecodeReturn:
	if _is_outside_of_range(packet, offset):
		return DecodeReturn.quick(null, 0, ERR_FILE_EOF)
	
	return null

static func decode_varint_from_stream(stream: StreamPeerTCP) -> Array:
	# Returns [error_code, value, bytes_read]
	const SEGMENT_BITS := 0x7f
	const CONTINUE_BIT := 0x80
	
	var value: int = 0
	var position: int = 0
	var bytes_read: int = 0
	var current_byte: int = 0x00
	
	while true:
		if stream.get_available_bytes() < 1:
			return [ERR_UNAVAILABLE, 0, 0]
		
		current_byte = stream.get_u8()
		var unmasked_value := (current_byte & SEGMENT_BITS) << position
		value = value | unmasked_value
		
		position += 7
		bytes_read += 1
		
		if (current_byte & CONTINUE_BIT) == 0:
			break
		
		if position >= 32:  # Or 21 if you want to enforce the 3-byte limit
			return [ERR_INVALID_DATA, 0, 0]
	
	return [OK, value, bytes_read]





## Returns an array [ERROR, NEW_OFFSET (next byte after the last one), 
## decoded value (null if unsuccessful)]
static func decode_string(packet: PackedByteArray, offset: int = 0) -> Array:
	var result: Array = decode_varint(packet, offset)
	if result[0] != OK:
		return [result[0], offset, null]
	var current_offset: int = result[1]
	var bytes_len: int = result[2]
	var string_bytes = packet.slice(current_offset, current_offset+bytes_len)
	return [OK, current_offset+bytes_len, string_bytes]



## Returns a PackedByteArray
static func encode_boolean(value: bool) -> PackedByteArray:
	if value: return [0x01]
	return [0x00]


static func encode_varint(value: int) -> PackedByteArray:
	const SEGMENT_MASK := 0x7f
	const CONTINUE_BIT := 0x80
	
	var varint: PackedByteArray
	while true:
		if (value & ~SEGMENT_MASK) == 0:
			varint.append(value & 0xff) # mask to 8 bits (one byte)
			break
		varint.append((value & SEGMENT_MASK) | CONTINUE_BIT)
		value = _unsigned_right_shift(value, 7)
	return varint


static func encode_string(value: String) -> PackedByteArray:
	var str_buffer := value.to_utf8_buffer()
	var result := encode_varint(str_buffer.size())
	result.append_array(str_buffer)
	return result



static func _is_outside_of_range(array: Array, index: int) -> bool:
	return index >= array.size()

static func _unsigned_right_shift(value: int, shift_ammount: int) -> int:
	if value >= 0:
		return value >> shift_ammount
	var mask = (1 << (32 - shift_ammount)) - 1
	return (value >> shift_ammount) & mask


class DecodeReturn:
	var value: Variant = null
	var byte_length: int = 0
	var error: Error = ERR_UNCONFIGURED
	
	static func quick(value: Variant, byte_length: int, error: Error) -> DecodeReturn:
		var new: DecodeReturn = DecodeReturn.new()
		new.byte_length = byte_length
		new.value = value
		new.error = new.error
