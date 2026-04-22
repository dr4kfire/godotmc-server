
@icon("res://assets/command_block.png")
class_name GameServer
extends Dot

# @public
@export_enum("1.21.10") var minecraft_version: String
@export_multiline() var motd: String = "A dot Minecraft Server"
@export var icon: Texture2D
@export var max_players: int = 20
@export var offline_mode: bool = false

var online_players: Array

# @public
func get_server_status() -> Dictionary:
	var img := icon.get_image()
	img.resize(64, 64, Image.INTERPOLATE_NEAREST)
	
	var favicon: String = Marshalls.raw_to_base64(img.save_png_to_buffer())
	return \
	{
		"version": {
			"name": minecraft_version,
			"protocol": DotBackend.version_protocol[minecraft_version]
		},
		"players": {
			"max": max_players,
			"online": online_players.size(),
			"sample": []
		},
		"description": {
			"text": motd
		},
		"favicon": "data:image/png;base64,%s" % [favicon],
		"enforcesSafeChat": false
	}
