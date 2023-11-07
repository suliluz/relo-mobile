import 'package:flutter/material.dart';

class SecuritySettings extends StatefulWidget {
  const SecuritySettings({super.key});

  @override
  State<SecuritySettings> createState() => _SecuritySettingsState();
}

class _SecuritySettingsState extends State<SecuritySettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Security"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Account ID
              ListTile(
                leading: const Icon(Icons.security, color: Colors.black54, size: 24),
                title: const Text("Account ID"),
                subtitle: const Text("johndoe"),
                onTap: () {},
              ),
              const Divider(),
              // Email
              ListTile(
                leading: const Icon(Icons.email, color: Colors.black54, size: 24),
                title: const Text("Email"),
                subtitle: const Text("johndoe@example.com"),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {},
              ),
              const Divider(),
              // Change password
              ListTile(
                leading: const Icon(Icons.lock, color: Colors.black54, size: 24),
                title: const Text("Change password"),
                subtitle: const Text("Change your password"),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {},
              ),
              const Divider(),
              // 6 pin code
              ListTile(
                leading: const Icon(Icons.lock, color: Colors.black54, size: 24),
                title: const Text("Two-Factor Code"),
                subtitle: const Text("Change your 6 pin code"),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {},
              ),
              // Devices
              const SizedBox(height: 20),
              const Text("Devices", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              // Current device
              ListTile(
                isThreeLine: true,
                leading: const Icon(Icons.phone_android, color: Colors.black54, size: 24),
                title: const Text("Current device"),
                subtitle: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Samsung Galaxy S20"),
                    Text("Last used: Now"),
                  ],
                ),
                onTap: () {},
              ),
              // Danger zone
              const SizedBox(height: 20),
              const Text("Danger zone", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              // Delete account
              ListTile(
                leading: const Icon(Icons.lock, color: Colors.red, size: 24),
                title: const Text("Delete account", style: TextStyle(color: Colors.red)),
                subtitle: const Text("Delete your account"),
                trailing: const Icon(Icons.arrow_forward_ios, color: Colors.red),
                onTap: () {},
              ),
              const Divider(),
            ],
          ),
        ),
      )
    );
  }
}
