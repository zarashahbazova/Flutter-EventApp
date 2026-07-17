class ChatMessage {
  final String user;
  final String message;

  ChatMessage({
    required this.user,
    required this.message,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      user: json["user"],
      message: json["message"],
    );
  }
}