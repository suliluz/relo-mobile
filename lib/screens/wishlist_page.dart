import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:relo/business_logic/models/package_information.dart';
import 'package:relo/business_logic/models/relo_response.dart';
import 'package:relo/business_logic/utilities/credentials_manager.dart';
import 'package:relo/screens/call_to_sign_in.dart';
import 'package:relo/screens/loading_page.dart';
import 'package:http/http.dart' as http;

import '../widgets/package_card.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  bool _isLoading = false;
  bool _isLoggedIn = false;

  List<PackageCard> _packages = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _loadWishlist();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        title: const Text("Wishlist"),
      ),
      body: wishlistBuilder(),
    );
  }

  _loadWishlist() async {
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
      http.Response response = await http.get(Uri.parse("https://relo.suliluz.name.my/travel/wishlists"), headers: {
        'Authorization': 'Bearer $refreshToken'
      });

      if(response.statusCode == 200) {
        var reloResponse = ReloResponse.fromJson(jsonDecode(response.body));

        if(reloResponse.success) {
          if(reloResponse.message.isEmpty) {
            return;
          }

          List<PackageInformation> packageInformation = reloResponse.message.map((e) => PackageInformation.fromJson(e)).toList();

          _packages = packageInformation.map((e) {
            return PackageCard(
              packageId: e.travelPackageId,
              state: e.state,
              country: e.country,
              days: e.daysCount,
              price: e.getLowestPriceBookingDate().price.round(),
              rating: e.ratingAverage,
              images: e.media.map((e) => e.referenceId).toList(),
              season: e.season,
              isCustomizable: e.customizable,
              agentId: e.agentId,
            );
          }).toList();
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

  Widget wishlistBuilder() {
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
              Icon(Icons.favorite_border, size: 100),
              SizedBox(height: 10),
              Text("Nothing here. You should add some!"),
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
