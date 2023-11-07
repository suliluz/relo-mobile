import 'package:relo/business_logic/enums/message_type.dart';

class Media {
  final MessageTypeItem type;
  final String body;

  Media({required this.type, required this.body});

  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
      type: MessageTypeItem.values.firstWhere((e) => e.toString() == 'MessageTypeItem.${json['type']}'),
      body: json['body'],
    );
  }

  Map<String, dynamic> toJson() => {
    'type': type.toString().split('.').last,
    'body': body,
  };
}

class ChatMessage {
  final String id;
  final String sender;
  final Media media;
  final DateTime timestamp;
  late List<String> read = [];

  ChatMessage({required this.id, required this.sender, required this.media, required this.timestamp, this.read = const []});

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      sender: json['sender'],
      media: Media.fromJson(json['media']),
      timestamp: DateTime.parse(json['timestamp']),
      read: json['read'].cast<String>(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'sender': sender,
    'media': media.toJson(),
    'timestamp': timestamp.toIso8601String(),
    'read': read,
  };
}