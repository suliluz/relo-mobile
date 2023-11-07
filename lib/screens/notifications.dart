import 'package:flutter/material.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
      ),
      body: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.notifications_active),
            title: const Text("Notifications"),
            subtitle: const Text("Receive notifications"),
            trailing: Switch(
              value: true,
              onChanged: (value) {},
            ),
          ),
          const Divider(),
          // Mark all as read aligns with the right side of the screen
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              child: const Text("Clear all"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              shrinkWrap: true,
              children: const [
                // Notification item
                ListTile(
                  isThreeLine: true,
                  title: Text("Check out our new features!"),
                  // Date
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Relo Team"),
                      Text("2021-01-01 12:00"),
                    ],
                  ),
                  trailing: Icon(Icons.delete),
                ),
                Divider(),
                // Notification item
                ListTile(
                  isThreeLine: true,
                  title: Text("Check out our new features!"),
                  // Date
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Relo Team"),
                      Text("2021-01-01 12:00"),
                    ],
                  ),
                  trailing: Icon(Icons.delete),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
