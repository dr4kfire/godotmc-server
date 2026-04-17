class_name MinecraftServer
extends Minecraft

const VERSION_NAME: String = "1.21.11"
const PROTOCOL_VERSION: int = 774 ## 1.21.11
const SERVER_NAME: String = "dot"

@export var port: int = 25565
@export_multiline() var server_motd: String = "A Dot Minecraft server"
@export var server_icon: Texture2D
@export var offline_mode: bool
@export var max_players: int


#@export var port: int = 25565
#@export_multiline() var server_motd: String = "A Godot Minecraft server"
#@export var favicon: Texture2D
#@export var enforces_secure_chat: bool = false
#@export_group("Godot Node Setup")
#@export var tcp_server_handler: TCPServerHandler
#@export var connection_handler: ConnectionHandler
#
#@export_category("Game Settings")
#@export var max_players: int = 20
#@export var offline_mode: bool = false
#
#
#func _ready() -> void:
	#var error: Error = tcp_server_handler.start_server(port)
	#if error != OK:
		#printerr("[ERROR]: TCPServer could not start: %s" % error_string(error))
		#get_tree().quit(1)
	#print("[INFO]: Server started successfuly on port: %s" % port)
#
#func _process(_delta: float) -> void:
	#connection_handler.handle_connections()
