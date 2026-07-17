import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

import '../chat/chat_message.dart';

import 'package:flutter/material.dart';

class WebSocketPage extends StatefulWidget {
  
  final String name;
  
  const WebSocketPage({
    super.key,
    required this.name});

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
    print("WEBSOCKET PAGE INIT");
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
    print("WEBSOCKET PAGE DISPOSE");
    channel.sink.close();
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text(
          "Mesajlar",
          style: TextStyle(
            color:Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(175, 9, 55, 45),
        elevation: 6,
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
                              margin: const EdgeInsets.only(top: 4), //mesaj kutusu aralık ve boyutları
                              padding: const EdgeInsets.all(12),

                              decoration: BoxDecoration( //mesaj kutusu renkleri
                                color: const Color.fromARGB(55, 48, 109, 89),
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

                    cursorColor: const Color(0xFF496860),

                    decoration: InputDecoration(

                      hintText: "Mesaj yaz...",

                      hintStyle: const TextStyle(
                        color: Colors.grey,
                      ),

                      filled: true,
                      fillColor: Colors.white,

                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),

                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: const BorderSide(
                          color: Color.fromARGB(123, 35, 33, 5),
                          width: 2,
                        ),
                      ),

                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: const BorderSide(
                          color: Color.fromARGB(175, 9, 55, 45),
                          width: 3,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                Container(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(175, 9, 55, 45),
                    shape: BoxShape.circle,
                  ),

                  child: IconButton(
                    onPressed: () {

                      if (messageController.text.trim().isEmpty) {
                        return;
                      }

                      final chat = {
                        "type": "chat",
                        "user": widget.name,
                        "message": messageController.text.trim(),
                      };

                      channel.sink.add(jsonEncode(chat));

                      messageController.clear();
                    },
                    icon: const Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                  ),
                ),

              ],
            ),
          ),

        ],
      ),
    );
  }
}