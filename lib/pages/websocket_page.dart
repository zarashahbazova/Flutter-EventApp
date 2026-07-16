import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketPage extends StatefulWidget {
  const WebSocketPage({super.key});

  @override
  State<WebSocketPage> createState() => _WebSocketPageState();
}

class _WebSocketPageState extends State<WebSocketPage> {
  late final WebSocketChannel channel;

  final titleController = TextEditingController();
  final timeController = TextEditingController();
  final locationController = TextEditingController();

  Map<String, dynamic>? receivedEvent;

  @override
  void initState() {
    super.initState();

    channel = WebSocketChannel.connect(
      Uri.parse("ws://192.168.60.18:8080"), // kendi IP adresim 192.168.60.18

    );

    channel.stream.listen((message) {

      final event = jsonDecode(message);

      setState(() {
        receivedEvent = event;
      });
    });
  }

  @override
  void dispose() {
    channel.sink.close();
    titleController.dispose();
    timeController.dispose();
    locationController.dispose();
    super.dispose();
  }

  void sendEvent() {
    if (titleController.text.isEmpty ||
        timeController.text.isEmpty ||
        locationController.text.isEmpty) {
      return;
    }

    final event = {
      "title": titleController.text,
      "time": timeController.text,
      "location": locationController.text,
    };

    channel.sink.add(jsonEncode(event));

    titleController.clear();
    timeController.clear();
    locationController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            children: [

              const SizedBox(height: 20),

              const Text(
                "Etkinlik Yönetimi",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 9, 55, 45),
                ),
              ),

              const SizedBox(height: 35),

              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: "Etkinlik Adı",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: timeController,
                decoration: InputDecoration(
                  labelText: "Saat",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: locationController,
                decoration: InputDecoration(
                  labelText: "Konum",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 9, 55, 45),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: sendEvent,
                  child: const Text(
                    "Etkinlik Oluştur",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),

              const SizedBox(height: 35),

              const Divider(),

              const SizedBox(height: 20),

              const Text(
                "Sunucudan Gelen Veri",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                
                  child: receivedEvent == null
                   ? const Text(
                        "Henüz etkinlik yok.",
                        style: TextStyle(fontSize: 18),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Text(
                            "${receivedEvent!["title"]}",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 10),

                          Text(
                            "${receivedEvent!["time"]}",
                            style: const TextStyle(fontSize: 18),
                          ),

                          const SizedBox(height: 8),

                          Text(
                           "${receivedEvent!["location"]}",
                           style: const TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}