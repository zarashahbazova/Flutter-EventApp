import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

import '../chat/chat_message.dart';

import 'package:flutter/material.dart';

class WebSocketPage extends StatefulWidget {
  const WebSocketPage({super.key});

  @override
  State<WebSocketPage> createState() => _WebSocketPageState();

}

class _WebSocketPageState extends State<WebSocketPage> {

  late WebSocketChannel channel;

  List<ChatMessage> messages = [];

  final TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    super.initState();

    print("Chat sayfası açıldı");

    channel = WebSocketChannel.connect(
      Uri.parse("ws://localhost:8080"),
    );

    print("WebSocket oluşturuldu");

    channel.stream.listen(
      (message) {
        print("SUNUCUDAN GELDİ: $message");

        final data = jsonDecode(message);

        if (data["type"] == "chat") {
          setState(() {
            messages = (data["messages"] as List)
                .map((e) => ChatMessage.fromJson(e))
                .toList();
          });
        }
      },

      onError: (error) {
        print("WEBSOCKET HATASI: $error");
      },

      onDone: () {
        print("WEBSOCKET KAPANDI");
      },
    );
  }

  @override
  void dispose() {
    channel.sink.close();
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text("Mesajlar"),
        centerTitle: true,
      ),

      body: Column(

        children: [

          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: messages.isEmpty
                  ? [
                      const Center(
                        child: Text("Henüz mesaj yok."),
                      )
                    ]
                  : messages.map((msg) {

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [

                            Text(
                              msg.user,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            Container(
                              margin: const EdgeInsets.only(top: 4),
                              padding: const EdgeInsets.all(12),

                              decoration: BoxDecoration(
                                color: const Color(0xFFEAF6F2),
                                borderRadius: BorderRadius.circular(15),
                              ),

                              child: Text(msg.message),
                            ),

                          ],
                        ),
                      );

                    }).toList(),
            ),
          ),

          const Divider(height: 1),

          Padding(
            padding: const EdgeInsets.all(12),

            child: Row(

              children: [

                Expanded(

                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: "Mesaj yaz...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),

                ),

                const SizedBox(width: 10),

                IconButton(
                  onPressed: () {

                    print("Gönder butonuna basıldı");

                    if (messageController.text.trim().isEmpty) {
                      return;
                    }
                    final chat = {
                      "type": "chat",
                      "user": "Kullanıcı1",
                      "message": messageController.text.trim(),
                    };

                    print(chat);

                    channel.sink.add(jsonEncode(chat));
                    channel.sink.add(
                      jsonEncode({
                        "type": "chat",
                        "user": "Kullanıcı1",
                        "message": messageController.text.trim(),
                      }),
                    );
                    print("Mesaj sunucuya gönderildi.");
                    messageController.clear();

                  },

                  icon: const Icon(Icons.send),
                ),

              ],
            ),
          ),

        ],
      ),
    );
  }
}