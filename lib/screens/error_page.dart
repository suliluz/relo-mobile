import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * .75,
          height: MediaQuery.of(context).size.height * .5,
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.error, size: 64, color: Colors.red,),
              SizedBox(height: 16,),
              Text("Hmm...", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
              SizedBox(height: 16,),
              Text("That didn't work. Please try again later.", style: TextStyle(fontSize: 21),),
            ],
          ),
        ),
      ),
    );
  }
}
