class_name Hexy
extends Node
## This class is used for nicely formatted hex values


static func format_to_xxd(data: PackedByteArray) -> String:
	var print_ready: String = ""
	for offset in range(0, data.size(), 16):
		var hex_line = ""
		var ascii_line = ""
		
		# Process 16 bytes per line
		for i in range(16):
			var idx = offset + i
			
			if idx < data.size():
				var byte = data[idx]
				var hex_str = "%02x" % byte
				var color = get_byte_color(byte)
				
				# Color and bold each hex byte
				hex_line += "[color=" + color + "][b]" + hex_str + "[/b][/color]"
				
				# Color and bold each ASCII character
				var char_str = char(byte) if (32 <= byte and byte <= 126) else "."
				ascii_line += "[color=" + color + "][b]" + char_str + "[/b][/color]"
			else:
				hex_line += "  "
				ascii_line += " "
			
			# Add spacing (space after every 4 hex chars / 2 bytes)
			if (i + 1) % 2 == 0 and i < 15:
				hex_line += " "
		
		# Yellow space before ASCII, then offset and colored hex/ASCII
		var output = "0x%04x: " % offset + hex_line.rpad(45) + " " + ascii_line
		if offset <= data.size():
			print_ready += "%s\n" % output
		else:
			print_ready += "%s" % output
	return print_ready


static func printxxd(data: PackedByteArray) -> void:
	for offset in range(0, data.size(), 16):
		var hex_line = ""
		var ascii_line = ""
		
		# Process 16 bytes per line
		for i in range(16):
			var idx = offset + i
			
			if idx < data.size():
				var byte = data[idx]
				var hex_str = "%02x" % byte
				var color = get_byte_color(byte)
				
				# Color and bold each hex byte
				hex_line += "[color=" + color + "][b]" + hex_str + "[/b][/color]"
				
				# Color and bold each ASCII character
				var char_str = char(byte) if (32 <= byte and byte <= 126) else "."
				ascii_line += "[color=" + color + "][b]" + char_str + "[/b][/color]"
			else:
				hex_line += "  "
				ascii_line += " "
			
			# Add spacing (space after every 4 hex chars / 2 bytes)
			if (i + 1) % 2 == 0 and i < 15:
				hex_line += " "
		
		# Yellow space before ASCII, then offset and colored hex/ASCII
		var output = "0x%04x: " % offset + hex_line.rpad(45) + " " + ascii_line
		print_rich(output)

static func get_byte_color(byte: int) -> String:
	if 32 <= byte and byte <= 126:  # Valid ASCII
		return "forest_green"
	elif byte == 0x00:  # Null byte
		return "white"
	elif byte == 0xff:  # Max value
		return "cornflower_blue"
	else:  # Invalid/non-printable
		return "maroon"
