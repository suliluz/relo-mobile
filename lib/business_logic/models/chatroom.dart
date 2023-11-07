import 'package:relo/business_logic/models/chat_message.dart';

class Participant {
  final String accountId;
  final DateTime lastSeen;

  Participant({required this.accountId, required this.lastSeen});

  factory Participant.fromJson(Map<String, dynamic> json) {
    return Participant(
      accountId: json['account_id'],
      lastSeen: DateTime.fromMillisecondsSinceEpoch(json['last_seen']),
    );
  }

  Map<String, dynamic> toJson() => {
    'accountId': accountId,
    'lastSeen': lastSeen.toIso8601String(),
  };
}

class Chatroom {
  final String id;
  final List<Participant> participants;
  final List<ChatMessage> chats;
  final DateTime createdAt;
  final DateTime updatedAt;

  Chatroom({required this.id, required this.participants, required this.chats, required this.createdAt, required this.updatedAt});

  factory Chatroom.fromJson(Map<String, dynamic> json) {
    return Chatroom(
      id: json['_id'],
      participants: json['participants'].map<Participant>((e) => Participant.fromJson(e)).toList(),
      chats: json['chats'].map<ChatMessage>((e) => ChatMessage.fromJson(e)).toList(),
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['created_at']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'participants': participants.map((e) => e.toJson()).toList(),
    'chats': chats.map((e) => e.toJson()).toList(),
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };
}