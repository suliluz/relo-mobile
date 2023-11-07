import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart' as cupertino;
import 'package:relo/screens/chatroom_space.dart';

class ChatroomPage extends StatefulWidget {
  const ChatroomPage({super.key});

  @override
  State<ChatroomPage> createState() => _ChatroomPageState();
}

class _ChatroomPageState extends State<ChatroomPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          bottom: const TabBar(
            indicatorColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: Colors.white,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(text: 'Chat'),
              Tab(text: 'History'),
            ],
          ),
          backgroundColor: Theme.of(context).primaryColor,
          title: const Text('Chatroom', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        body: TabBarView(
          children: [
            _chatList(),
            _historyList()
          ],
        )
      ),
    );
  }

  Widget _chatList() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: [
          ListTile(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ChatroomSpace(chatroomId: "1",)));
            },
            leading: const CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage('https://picsum.photos/200'),
            ),
            title: const Text('John Doe'),
            subtitle: Row(
              children: [
                Icon(Icons.check, color: Theme.of(context).primaryColor, size: 15),
                const SizedBox(width: 5),
                const Text('Hello'),
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
          ),
        ],
      ),
    );
  }

  Widget _historyList() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: [
          ListTile(
            leading: const CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage('https://picsum.photos/200'),
            ),
            title: const Text('John Doe'),
            subtitle: const Row(
              children: [
                Icon(Icons.call_received, color: Colors.red, size: 15),
                SizedBox(width: 5),
                // Time and date
                Text('January 1, 2022 10:00', style: TextStyle(fontSize: 14),),
              ],
            ),
            trailing: Icon(Icons.call, color: Theme.of(context).primaryColor, size: 30),
          ),
        ],
      ),
    );
  }
}
