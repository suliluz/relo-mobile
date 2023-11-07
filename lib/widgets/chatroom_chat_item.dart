import 'package:flutter/material.dart';

class ChatroomChatItem extends StatelessWidget {
  ChatroomChatItem({
    super.key,
    required this.profileImage,
    required this.name,
    required this.lastMessage,
    required this.unreadCount,
    required this.lastMessageTime,
  });

  final String profileImage;
  final String name;
  late Map<String, dynamic> lastMessage = {
    'type': 'text',
    'content': 'Hello',
    'time': DateTime.now(),
    'sender': {
      'name': 'John Doe',
      'id': '1234567890',
    },
  };

  final int unreadCount;
  final DateTime lastMessageTime;



  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 30,
        backgroundImage: NetworkImage(profileImage),
      ),
      title: Text(name),
      subtitle: Row(
        children: [
          Icon(Icons.check, size: 14, color: Theme.of(context).primaryColor),
          const SizedBox(width: 2),
          Text(lastMessage['content']),
        ],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('10:00', style: TextStyle(color: Colors.grey, fontSize: 14)),
          const SizedBox(height: 2),
          CircleAvatar(
            radius: 10,
            backgroundColor: Theme.of(context).primaryColor,
            child: const Text('1', style: TextStyle(color: Colors.white, fontSize: 12)),
          ),
        ],
      ),
    );
  }
}
