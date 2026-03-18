## Handles stuff like the tcp server etc.

@icon("uid://pgi0jn07dos0") ## chain_command_block.png
class_name MCTCPServerHandler
extends Minecraft


var server = TCPServer.new()


func start_server(port: int = 25565) -> Error:
	if server.is_listening():
		server.stop()
	return server.listen(port)
