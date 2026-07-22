import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  late WebSocketChannel channel;

  void connect() {
    channel = WebSocketChannel.connect(Uri.parse("ws://localhost:8080"));
  }
}
