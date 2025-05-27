class ChatMessage {
  final String id;
  final String content;
  final String type;
  final DateTime createdAt;
  final ChatSender sender;

  ChatMessage({
    required this.id,
    required this.content,
    required this.type,
    required this.createdAt,
    required this.sender,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['_id'] ?? '',
      content: json['content'] ?? '',
      type: json['type'] ?? 'text',
      createdAt: DateTime.parse(json['createdAt']),
      sender: ChatSender.fromJson(json['sender']),
    );
  }
}

class ChatSender {
  final String id;
  final String name;

  ChatSender({required this.id, required this.name});

  factory ChatSender.fromJson(Map<String, dynamic> json) {
    return ChatSender(id: json['_id'] ?? '', name: json['name'] ?? 'Unknown');
  }
}
