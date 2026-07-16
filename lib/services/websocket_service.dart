import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {

  late WebSocketChannel channel;

  void connect() {

    channel = WebSocketChannel.connect(
      Uri.parse("ws://192.168.60.18:8080"),
    );

  }

}