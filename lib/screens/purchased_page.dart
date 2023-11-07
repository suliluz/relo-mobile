import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:relo/business_logic/models/package_subscription.dart';
import 'package:relo/business_logic/models/transactions.dart';
import 'package:relo/widgets/package_card_purchased.dart';
import '../business_logic/models/package_information.dart';
import '../widgets/package_card.dart';
import '../business_logic/models/relo_response.dart';
import '../business_logic/utilities/credentials_manager.dart';
import 'call_to_sign_in.dart';
import 'loading_page.dart';

class PurchasedPage extends StatefulWidget {
  const PurchasedPage({super.key});

  @override
  State<PurchasedPage> createState() => _PurchasedPageState();
}

class _PurchasedPageState extends State<PurchasedPage> {
  bool _isLoading = false;
  bool _isLoggedIn = false;

  List<Widget> _packages = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _loadPurchased();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Purchased"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: purchaseBuilder(),
      ),
    );
  }

  _loadPurchased() async {
    setState(() {
      _isLoading = true;
    });

    try {
      var refreshToken = await CredentialsManager.refreshToken();

      if(refreshToken == null) {
        _isLoggedIn = false;
        return;
      }

      _isLoggedIn = true;

      // HTTP get wishlist
      http.Response response = await http.get(Uri.parse("https://relo.suliluz.name.my/travel/purchased"), headers: {
        'Authorization': 'Bearer $refreshToken'
      });

      if(response.statusCode == 200) {
        var reloResponse = ReloResponse.fromJson(jsonDecode(response.body));

        if(reloResponse.success) {
          if(reloResponse.message.isEmpty) {
            return;
          }

          List<PackageSubscription> packageSubscriptions = reloResponse.message.map((e) => PackageSubscription.fromJson(e)).toList();
          _packages = packageSubscriptions.map((e) => PackageCardPurchased(packageSubscription: e)).toList();
        } else {
          print(reloResponse.message);
        }
      }

    } catch (e) {
      rethrow;
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget purchaseBuilder() {
    // If is not logged in and loading is false
    if (!_isLoggedIn && !_isLoading) {
      return const CallToSignIn();
    } else if(_isLoading) {
      return const LoadingPage();
    } else {
      if(_packages.isEmpty) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shopping_bag_outlined, size: 100),
              SizedBox(height: 10),
              Text("Nothing here. You should buy some!"),
            ],
          ),
        );
      } else {
        return ListView(
          children: _packages,
        );
      }
    }
  }
}
