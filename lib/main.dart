import 'package:flutter/material.dart';
import 'package:relo/business_logic/utilities/credentials_manager.dart';
import 'package:relo/screens/main_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    CredentialsManager.initialize();

    return MaterialApp(
      title: 'Relo App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainPage(),
    );
  }
}
