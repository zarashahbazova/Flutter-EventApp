import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'profile.dart';
import 'websocket_page.dart';
import '../events/event.dart';


class HomePage extends StatefulWidget {
  final String name;
  final String email;

  const HomePage({
    super.key,
    required this.name,
    required this.email,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  List<Event> events = [];

  late WebSocketChannel channel;

  bool get isAdmin => widget.email == "admin@staj.com";
  bool serverConnected = false;

@override
void initState() {
  super.initState();

  connectWebSocket();

  WidgetsBinding.instance.addPostFrameCallback((_) {
   showLocationDialog();
  });
}

Future<void> showLocationDialog() async {
  showModalBottomSheet(
    context: context,
    isDismissible: false,
    enableDrag: false,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(25),
      ),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            const Icon(
              Icons.location_on,
              color: Color.fromARGB(190, 9, 55, 45),
              size: 60,
            ),

            const SizedBox(height: 20),

            const Text(
              "Konum Erişimi",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            const Text(
              "Yakınınızdaki etkinlikleri gösterebilmek için konum bilginize erişmemize izin vermeniz gerekiyor.",
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: const Color.fromARGB(200, 9, 55, 45),
                  foregroundColor: Colors.white,
                ),
              
                onPressed: () async {

                  Navigator.pop(context);

                  PermissionStatus status =
                      await Permission.location.request();

                  if (status.isGranted) {
                    print("Konum izni verildi.");
                  }

                },
                child: const Text("İzin Ver"),
              ),
            ),

            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: const Color.fromARGB(255, 9, 55, 45)
              ),
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

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(25),
      ),
    ),
    builder: (context) {

      return Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              const Text(
                "Etkinlik Ekle",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: "Etkinlik Adı",
                ),
              ),

              TextField(
                controller: dateController,
                decoration: const InputDecoration(
                  labelText: "Etkinlik Tarihi",
                ),
              ),
              const SizedBox(height: 15),

              TextField(
                controller: timeController,
                decoration: const InputDecoration(
                  labelText: "Saat",
                ),
              ),

              const SizedBox(height: 15),

              TextField(
                controller: locationController,
                decoration: const InputDecoration(
                  labelText: "Konum",
                ),
              ),

              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                child: FilledButton(
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

  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(25),
      ),
    ),
    builder: (context) {

      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text("Düzenle"),
              onTap: () {
                Navigator.pop(context);

                // Düzenleme kısmını birazdan yapacağız.
              },
            ),

            ListTile(
              leading: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
              title: const Text(
                "Sil",
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {

                Navigator.pop(context);

                channel.sink.add(
                  jsonEncode({
                    "type": "delete",
                    "id": event.id,
                  }),
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
    channel = WebSocketChannel.connect(
      Uri.parse("ws://localhost:8080"),
    );

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
    }
    catch (e) {
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
      "Pazartesi","Salı","Çarşamba","Perşembe",
      "Cuma","Cumartesi","Pazar"
    ];
    const months = [
      "Ocak","Şubat","Mart","Nisan","Mayıs","Haziran",
      "Temmuz","Ağustos","Eylül","Ekim","Kasım","Aralık"
    ];

    final now = DateTime.now();
    return "${days[now.weekday - 1]}, ${now.day} ${months[now.month - 1]}";
  }




  Widget homeScreen() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
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
                        "${getGreeting()}, \n${widget.name} ",
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        getDate(),
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),

                // IconButton(
                //     hoverColor: Colors.transparent,
                //     highlightColor: const Color.fromARGB(10, 111, 27, 27),
                //     splashColor: Colors.transparent,
                //   icon: const Icon(Icons.notifications_none, size: 30),
                //   color: Color.fromARGB(255, 9, 55, 45),
                //   onPressed: () {},
                // )

                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    if (isAdmin)
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        color: const Color.fromARGB(255, 9, 55, 45),
                        onPressed: () {

                          showAddEventDialog();

                        },
                      ),

                    IconButton(
                      icon: const Icon(Icons.notifications_none),
                      color: const Color.fromARGB(255, 9, 55, 45),
                      onPressed: () {},
                    ),

                  ],
                ),

              ],
            ),

            const SizedBox(height: 40),
            Container(
              width: double.infinity,

              margin: const EdgeInsets.symmetric(
                horizontal: 10,
              ),

              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(
                color: Colors.white,

                borderRadius: BorderRadius.circular(30),

                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 12,
                    offset: Offset(0,5),
                  )
                ],
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const Text(
                    "Etkinlikler",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  if(events.isEmpty)

                    const Center(
                      child: Text("Bugün etkinlik yok."),
                    )

                  else

                    ...events.map((event){

                      return GestureDetector(

                        onLongPress: () {
                          if (isAdmin) {
                            showEventMenu(event);
                          }
                        },

                      

                        child: Container(

                          width: double.infinity,  

                          margin: const EdgeInsets.only(bottom:15),

                          padding: const EdgeInsets.all(16),

                          decoration: BoxDecoration(

                            color: const Color(0xFFEAF6F2),

                            borderRadius: BorderRadius.circular(20),

                          ),

                          child: Column(

                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [

                              Text(
                                "${event.title}",
                                style: const TextStyle(
                                  fontSize:18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height:8),

                              Text(
                                "${event.time}",
                              ),

                              const SizedBox(height:5),

                              Text(
                                "${event.location}",
                              ),




                            ],

                          ),

                    
                        )


                        );

                    }),

                ],
              ),
            )

          
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

    WebSocketPage(
      name: widget.name,
    ),

    ProfileScreen(
      name: widget.name,
      email: widget.email,
    ),
  ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          iconTheme: WidgetStateProperty.resolveWith(
            (states) {
              if (states.contains(WidgetState.selected)) {
                return const IconThemeData(
                  color: Color.fromARGB(255, 9, 55, 45),
                );
              }

              return const IconThemeData(
                color: Color.fromARGB(255, 9, 48, 48),
              );
            },
          ),
        ),
        child: NavigationBar(

          backgroundColor: Colors.white,

          indicatorColor: const Color.fromARGB(40, 9, 55, 45),
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) {
            setState(() => _currentIndex = index);
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: "Ana Sayfa",
            ),
            NavigationDestination(
              icon: Icon(Icons.grid_view_outlined),
              selectedIcon: Icon(Icons.grid_view),
              label: "Mesajlar",
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: "Profil",
            ),
          ]
        ),
      ),
    );
  }
}

// ignore: unused_element
class _QuickCard extends StatelessWidget {
  final IconData icon;
  final String title;

  const _QuickCard({
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
          hoverColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: const Color.fromARGB(0, 143, 46, 46),
        onTap: () {},
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 42),
            const SizedBox(height: 12),
            Text(title),
          ],
        ),
      ),
    );
  }

}
