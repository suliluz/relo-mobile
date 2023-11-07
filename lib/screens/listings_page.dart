import 'package:flutter/material.dart';
import 'package:relo/screens/create_listing.dart';
import 'package:relo/widgets/package_card_editor.dart';
import 'package:relo/business_logic/utilities/credentials_manager.dart';
import 'package:http/http.dart' as http;

import '../business_logic/enums/season_item.dart';

class ListingsPage extends StatefulWidget {
  const ListingsPage({super.key});

  @override
  State<ListingsPage> createState() => _ListingsPageState();
}

class _ListingsPageState extends State<ListingsPage> {

  late List<Widget> _listings;

  bool _isLoading = false;
  bool _isError = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Listings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Right side button to add a new listing with a plus icon and a text label
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateListing()));
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add Listing'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  Column(
                    children: [
                      // First media image
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _load() async {
    try {
      final refreshToken = await CredentialsManager.refreshToken();

      if(refreshToken == null) {
        throw Exception('No refresh token found');
      }

      var response = await http.post(
        Uri.parse('https://relo.suliluz.name.my/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $refreshToken',
        },
      );


    } catch (e) {
      setState(() {
        _isError = true;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
