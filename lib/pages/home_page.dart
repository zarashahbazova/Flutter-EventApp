import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:staj_test1/themes/app_theme.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../events/event.dart';
import 'profile.dart';
import 'websocket_page.dart';

class HomePage extends StatefulWidget {
  final String name;
  final String email;

  const HomePage({super.key, required this.name, required this.email});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  List<Event> events = [];
  late WebSocketChannel channel;

  bool get isAdmin => widget.email == "zarifesahbazz@gmail.com";
  bool serverConnected = false;

  @override
  void initState() {
    super.initState();
    connectWebSocket();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkLocationDialog();
    });
  }

  Future<void> showLocationDialog() async {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppTheme.cardRadius),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(AppTheme.pagePadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.location_on,
                color: theme.colorScheme.primary,
                size: 60,
              ),
              const SizedBox(height: 20),
              Text("Konum Erişimi", style: theme.textTheme.titleLarge),
              const SizedBox(height: 15),
              Text(
                "Yakınınızdaki etkinlikleri gösterebilmek için konum bilginize erişmemize izin vermeniz gerekiyor.",
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    PermissionStatus status = await Permission.location
                        .request();
                    if (status.isGranted) {
                      debugPrint("Konum izni verildi.");
                    }
                  },
                  child: const Text("İzin Ver"),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Daha Sonra"),
              ),
              const SizedBox(height: 15),
            ],
          ),
        );
      },
    );
  }

  void showAddEventDialog() {
    final titleController = TextEditingController();
    final timeController = TextEditingController();
    final locationController = TextEditingController();
    final dateController = TextEditingController();
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppTheme.cardRadius),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: AppTheme.pagePadding,
            right: AppTheme.pagePadding,
            top: AppTheme.pagePadding,
            bottom:
                MediaQuery.of(context).viewInsets.bottom + AppTheme.pagePadding,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Etkinlik Ekle", style: theme.textTheme.titleLarge),
                const SizedBox(height: 20),
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: "Etkinlik Adı"),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: dateController,
                  decoration: const InputDecoration(
                    labelText: "Etkinlik Tarihi",
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: timeController,
                  decoration: const InputDecoration(labelText: "Saat"),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: locationController,
                  decoration: const InputDecoration(labelText: "Konum"),
                ),
                const SizedBox(height: 25),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (titleController.text.isEmpty ||
                          dateController.text.isEmpty ||
                          timeController.text.isEmpty ||
                          locationController.text.isEmpty) {
                        return;
                      }

                      final event = {
                        "type": "add",
                        "title": titleController.text,
                        "time": timeController.text,
                        "location": locationController.text,
                        "date": dateController.text,
                      };

                      if (serverConnected) {
                        channel.sink.add(jsonEncode(event));
                      } else {
                        setState(() {
                          events.add(
                            Event(
                              id: DateTime.now().millisecondsSinceEpoch,
                              title: titleController.text,
                              date: dateController.text,
                              time: timeController.text,
                              location: locationController.text,
                            ),
                          );
                        });
                      }

                      Navigator.pop(context);
                    },
                    child: const Text("Kaydet"),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showEventMenu(Event event) {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppTheme.cardRadius),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.edit, color: theme.colorScheme.primary),
                title: Text("Düzenle",
                style:theme.textTheme.bodyMedium),
                onTap: () {
                  Navigator.pop(context);
                  // Düzenleme mantığı
                },
              ),
              ListTile(
                leading: Icon(Icons.delete, color: theme.colorScheme.error),
                title: Text(
                  "Sil",
                  style: theme.textTheme.bodyMedium!.copyWith(
                    color: AppTheme.error,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  channel.sink.add(
                    jsonEncode({"type": "delete", "id": event.id}),
                  );
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  void connectWebSocket() {
    try {
      channel = WebSocketChannel.connect(Uri.parse("ws://localhost:8080"));
      serverConnected = true;

      channel.stream.listen(
        (message) {
          final data = jsonDecode(message);
          if (data["type"] == "events") {
            setState(() {
              events = (data["events"] as List)
                  .map((e) => Event.fromJson(e))
                  .toList();
            });
          }
        },
        onError: (error) {
          serverConnected = false;
          debugPrint("WebSocket Hatası: $error");
        },
        onDone: () {
          serverConnected = false;
          debugPrint("Websocket bağlantısı kapandı");
        },
      );
    } catch (e) {
      debugPrint("Bağlantı kurulamadı: $e");
    }
  }

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Günaydın";
    if (hour < 18) return "İyi Günler";
    return "İyi Akşamlar";
  }

  String getDate() {
    const days = [
      "Pazartesi",
      "Salı",
      "Çarşamba",
      "Perşembe",
      "Cuma",
      "Cumartesi",
      "Pazar",
    ];
    const months = [
      "Ocak",
      "Şubat",
      "Mart",
      "Nisan",
      "Mayıs",
      "Haziran",
      "Temmuz",
      "Ağustos",
      "Eylül",
      "Ekim",
      "Kasım",
      "Aralık",
    ];

    final now = DateTime.now();
    return "${days[now.weekday - 1]}, ${now.day} ${months[now.month - 1]}";
  }

  Widget homeScreen() {
    final theme = Theme.of(context);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.pagePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${getGreeting()},\n${widget.name}",
                        style: theme.textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 6),
                      Text(getDate(), style: theme.textTheme.bodyMedium),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isAdmin)
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        color: theme.colorScheme.primary,
                        iconSize: 28,
                        onPressed: showAddEventDialog,
                      ),
                    IconButton(
                      icon: const Icon(Icons.notifications_none),
                      color: theme.colorScheme.primary,
                      iconSize: 28,
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Etkinlikler Kartı
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.cardPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Etkinlikler", style: theme.textTheme.titleLarge),
                    const SizedBox(height: 20),
                    if (events.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                            "Bugün etkinlik yok.",
                            style: theme.textTheme.bodyMedium,
                          ),
                        ),
                      )
                    else
                      ...events.map((event) {
                        return GestureDetector(
                          onLongPress: () {
                            if (isAdmin) {
                              showEventMenu(event);
                            }
                          },
                          child: Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(
                              bottom: AppTheme.itemSpacing,
                            ),
                            padding: const EdgeInsets.all(AppTheme.cardPadding),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withValues(
                                alpha: 0.08,
                              ),
                              borderRadius: BorderRadius.circular(
                                AppTheme.radiusMedium,
                              ),
                              border: Border.all(
                                color: theme.colorScheme.primary.withValues(
                                  alpha: 0.15,
                                ),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  event.title,
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    fontWeight: AppTheme.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.access_time,
                                      size: 16,
                                      color: theme.colorScheme.primary,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      event.time,
                                      style: theme.textTheme.bodyMedium,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_on_outlined,
                                      size: 16,
                                      color: theme.colorScheme.primary,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      event.location,
                                      style: theme.textTheme.bodyMedium,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      homeScreen(),
      WebSocketPage(name: widget.name),
      ProfileScreen(name: widget.name, email: widget.email),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: "Ana Sayfa",
          ),
          NavigationDestination(
            icon: Icon(Icons.message_outlined),
            selectedIcon: Icon(Icons.message),
            label: "Mesajlar",
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: "Profil",
          ),
        ],
      ),
    );
  }
  
  void checkLocationDialog() {}
}
