extends Node;

const DEFAULT_PORT: int = 25565;
var server: TCPServer;


func use_stream(stream: StreamPeerTCP):
	stream.poll();
	var result := stream.get_data(stream.get_available_bytes());
	var err: Error = result[0];
	if err != OK:
		return
	var data: PackedByteArray = result[1]
	print("Data: 0x%s" % data.hex_encode())


func _ready():
	server = TCPServer.new();
	server.listen(DEFAULT_PORT);


func _process(_dt: float):
	while server.is_connection_available():
		var stream: StreamPeerTCP = server.take_connection();
		use_stream(stream);
