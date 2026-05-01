class_name BytesFormatter
extends UtilsModule
## This class is used for nicely formatted PackedByteArrays and hex values


static func xxdlike(data: PackedByteArray) -> String:
	var output: String = ""
	# Each line has 16 bytes - increment by 16
	for line in range(0, data.size(), 16):
		var hex_line := ""
		var ascii_line := ""
		
		# Process each byte separately
		for i in range(16):
			var byte_idx := line + i
			
			if byte_idx >= data.size(): # Outside of range - fill with empty space
				hex_line += "  "
				ascii_line += " "
				continue
			
			var byte_value := data[byte_idx]
			
			# Color and bold each hex byte
			var hex_str: String = "%02x" % byte_value # pad with two min two zeros
			var color: String = _get_byte_color(byte_value)
			hex_line += "[color=" + color + "][b]" + hex_str + "[/b][/color]"
			
			# Color and bold each ASCII character
			var ascii_char := "."
			if 32 <= byte_value and byte_value <= 126:
				ascii_char = char(byte_value)
			ascii_line += "[color=" + color + "][b]" + ascii_char + "[/b][/color]"
		
		# put "0x" in front, pad with 0 for min len of 4 and append the data
		output += "0x%04x: %s %s" % [line, hex_line.rpad(45), ascii_line]
		if line + 16 < data.size():
			output += "\n"
		
	return output


static func _get_byte_color(byte: int) -> String:
	if 32 <= byte and byte <= 126:  # Valid ASCII
		return "forest_green"
	elif byte == 0x00:  # Null byte
		return "white"
	elif byte == 0xff:  # Max value
		return "cornflower_blue"
	else:  # Invalid/non-printable
		return "maroon"
