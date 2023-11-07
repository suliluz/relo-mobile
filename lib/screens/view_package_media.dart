import 'package:flutter/material.dart';

class ViewPackageMedia extends StatefulWidget {
  const ViewPackageMedia({super.key});

  @override
  State<ViewPackageMedia> createState() => _ViewPackageMediaState();
}

class _ViewPackageMediaState extends State<ViewPackageMedia> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.file_upload_outlined)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.favorite_border)),
        ],
      ),
      body: const Center(
        child: Text("Media"),
      ),
    );
  }
}
