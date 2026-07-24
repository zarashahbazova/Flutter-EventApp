import 'dart:convert';
import 'dart:async';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../chat/chat_message.dart';
import 'package:flutter/material.dart';
import '../themes/app_theme.dart';

class WebSocketPage extends StatefulWidget {
  final String
  name; //loginden gelen kullanici adi. değiştirilmeyen deger (final)

  const WebSocketPage({super.key, required this.name});

  @override
  State<WebSocketPage> createState() => _WebSocketPageState();
}

class _WebSocketPageState extends State<WebSocketPage> {
  WebSocketChannel? channel;
  StreamSubscription? _subscription;
  bool blink = true;
  Timer? blinkTimer;
  bool connected = false;
  bool loading = true;
  List<ChatMessage> messages = [];
  final TextEditingController messageController = TextEditingController();
  final ScrollController _scrollController =
      ScrollController(); // Otomatik kaydırma için

      @override
      void initState() {
        print("INIT");
        super.initState();
        blinkTimer = Timer.periodic(
          // yanip sönen nokta
          const Duration(milliseconds: 500),
          (_) {
            if (!mounted) return;

            setState(() {
              blink = !blink;
            });
          },
        );

    try {
      //hata yakalamak icin
      channel = WebSocketChannel.connect(
        Uri.parse("ws://localhost:8080"),
      ); //modejse bağlanmayi baslatir

      channel!
          .ready //bağlantının kurulmasını bekle
          .then((_) {
            //başarılı olursa bu kodu calistir
            if (!mounted) return;

            setState(() {
              connected = true;
            });
          })
          .catchError((e) {
            //basarısız olursa bu kodu calistir
            if (!mounted) return;

            setState(() {
              connected = false;
            });

            debugPrint("Bağlantı kurulamadı: $e");
          });

      // ignore: unused_label
      _subscription = channel!.stream.listen(
        (message) {
          if (!mounted) return;

          print("mesaj geldi");

          final data = jsonDecode(message);

          if (data["type"] == "chat") {
            setState(() {
              messages = (data["messages"] as List)
                  .map((e) => ChatMessage.fromJson(e))
                  .toList();
            });

            Future.delayed(const Duration(milliseconds: 100), () {
              if (!mounted) {
                return;
              }
              _scrollToBottom();
            });
          }
        },
        onError: (_) {
          if (!mounted) return;
          setState(() {
            connected = false;
          });
        },
        onDone: () {
          if (!mounted) return;
          setState(() {
            connected = false;
          });
        },
      );
    } catch (e) {
      connected = false;
    }
  }

  @override
  void dispose() {
    blinkTimer?.cancel();
    //sayfa uygulamadan kaldrılırken bi kere çalısır, kullandıgı tüm kaynakları temizletşr
    print("DISPOSE ");
    _subscription?.cancel();
    channel?.sink.close(); //websockeet bağlantısını kapatıyor
    messageController.dispose(); //controlleri temizler
    _scrollController.dispose(); //listeyi kontrol eder dispose da temizler
    super.dispose();
  }

  void _scrollToBottom() {
    //yeni mesaj geldiginde otomatik olarak ekran en alta kayar
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage() {
    if (messageController.text.trim().isEmpty) {
      return;
    }

    final chat = {
      "type": "chat",
      "user": widget.name,
      "message": messageController.text.trim(),
    };

    if (!connected || channel == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Sunucuya bağlanılamadı.")));
      return;
    }

    channel!.sink.add(jsonEncode(chat));
    messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Sohbet Odası",
              style: theme.textTheme.titleLarge!.copyWith(
                color: AppTheme.white,
                fontWeight: AppTheme.bold,
              ),
            ),

            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedOpacity(
                  opacity: blink ? 1.0 : 0.2,
                  duration: const Duration(seconds: 1),
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: connected ? Colors.green : Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),

                const SizedBox(width: 6),

                Text(
                  connected ? "Canlı Bağlantı" : "Bağlantı Yok",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.white.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Mesaj Listesi Alanı
          Expanded(
            child: !connected
                ? const Center(child: Text("Sunucuya bağlanılamadı."))
                : messages.isEmpty
                ? _buildEmptyState(theme)
                : ListView.separated(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(AppTheme.pagePadding),
                    itemCount: messages.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: AppTheme.itemSpacing),
                    itemBuilder: (context, index) {
                      final msg = messages[index];
                      final isMe = msg.user == widget.name; // Mesaj benden mi?
                      return _buildMessageBubble(msg, isMe, theme, colorScheme);
                    },
                  ),
          ),
          // Mesaj Giriş Alanı (Alt Kısım)
          _buildMessageInputArea(theme, colorScheme, isDark),
        ],
      ),
    );
  }

  // Mesaj Yoksa Gösterilecek Alan
  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 80,
            color: theme.colorScheme.primary.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 20),
          Text(
            "Henüz mesaj yok.\nİlk mesajı sen yaz!",
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.textTheme.bodyMedium?.color,
            ),
          ),
        ],
      ),
    );
  }

  // Modern Mesaj Balonu Tasarımı
  Widget _buildMessageBubble(
    ChatMessage msg,
    bool isMe,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return Column(
      crossAxisAlignment: isMe
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        // Başkasının mesajıysa kullanıcı adını göster
        if (!isMe)
          Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 4),
            child: Text(
              msg.user,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: AppTheme.bold,
                color: colorScheme.primary,
              ),
            ),
          ),

        // Balonun kendisi
        Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75, // Ekranın %75'i
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.cardPadding,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            // Senin mesajın Mor, başkasınınki Surface (Gri/Beyaz)
            color: isMe ? colorScheme.primary : colorScheme.surface,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(AppTheme.radiusMedium),
              topRight: const Radius.circular(AppTheme.radiusMedium),
              bottomLeft: Radius.circular(
                isMe ? AppTheme.radiusMedium : 0,
              ), // Kuyruk efekti
              bottomRight: Radius.circular(
                isMe ? 0 : AppTheme.radiusMedium,
              ), // Kuyruk efekti
            ),
            // Başkasının mesajına hafif gölge/kenarlık
            border: isMe
                ? null
                : Border.all(color: colorScheme.primary.withValues(alpha: 0.1)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            msg.message,
            style: theme.textTheme.bodyLarge?.copyWith(
              // Senin mesajının metni beyaz, diğerleri temanın metin rengi
              color: isMe ? AppTheme.white : colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }

  // Modern Mesaj Giriş Alanı Tasarımı
  Widget _buildMessageInputArea(
    ThemeData theme,
    ColorScheme colorScheme,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? colorScheme.surface : AppTheme.lightSurface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Metin Giriş Kutusu
            Expanded(
              child: TextField(
                controller: messageController,
                cursorColor: colorScheme.primary,
                style: theme.textTheme.bodyLarge,
                decoration: InputDecoration(
                  hintText: "Mesajınızı buraya yazın...",
                  hintStyle: theme.textTheme.bodyMedium?.copyWith(
                    color: isDark ? AppTheme.grey500 : AppTheme.grey600,
                  ),
                  filled: true,
                  // Giriş kutusunun arka planı
                  fillColor: isDark
                      ? colorScheme.onSecondary
                      : AppTheme.grey100,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                  // Bu sayfaya özel tam yuvarlak kenarlıklar
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none, // Kenarlık yok
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(
                      color: colorScheme.primary.withValues(alpha: 0.5),
                      width: 1,
                    ),
                  ),
                ),
                textCapitalization:
                    TextCapitalization.sentences, // Cümle başı büyük harf
              ),
            ),

            const SizedBox(width: 12),

            // Gönder Butonu (Yuvarlak)
            Material(
              color: colorScheme.primary,
              shape: const CircleBorder(),
              elevation: 3,
              shadowColor: colorScheme.primary.withValues(alpha: 0.4),
              child: IconButton(
                onPressed: _sendMessage,
                icon: const Icon(
                  Icons.send_rounded, // Daha modern bir gönder ikonu
                  color: AppTheme.white,
                  size: 22,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
