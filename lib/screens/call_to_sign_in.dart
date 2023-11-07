import 'package:flutter/material.dart';
import 'package:relo/screens/login_page.dart';

class CallToSignIn extends StatefulWidget {
  const CallToSignIn({super.key});

  @override
  State<CallToSignIn> createState() => _CallToSignInState();
}

class _CallToSignInState extends State<CallToSignIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Looking to travel somewhere in the future?", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
            const SizedBox(height: 10,),
            ElevatedButton(onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const LoginPage();
              }));
            }, child: const Text("Login"),),
          ],
        ),
      ),
    );
  }
}
