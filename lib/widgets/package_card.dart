import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart' as cupertino;
import 'package:relo/business_logic/enums/season_item.dart';
import 'package:relo/business_logic/models/user_profile_data.dart';
import '../business_logic/enums/gender_item.dart';
import '../business_logic/utilities/credentials_manager.dart';
import '../screens/login_page.dart';
import '../screens/view_package.dart';
import 'package:relo/business_logic/models/relo_response.dart';



class PackageCard extends StatefulWidget {
  final String packageId;
  final String state;
  final String country;
  final int days;
  final int price;
  final double rating;
  final List<String> images;
  final SeasonItem season;
  final bool isCustomizable;
  final String agentId;

  const PackageCard({
    super.key,
    required this.packageId,
    required this.state,
    required this.country,
    required this.days,
    required this.price,
    required this.rating,
    required this.images,
    required this.season,
    required this.isCustomizable,
    required this.agentId,
  });

  @override
  State<PackageCard> createState() => _PackageCardState();
}

class _PackageCardState extends State<PackageCard> {
  late int _imageIndex;
  late int _imageCount;
  late String _formattedPrice;

  late UserProfileData _agentInfo;

  late bool _isFavourite;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _imageIndex = 0;
    _imageCount = widget.images.length;

    // Format price with commas
    _formattedPrice = widget.price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
    _isFavourite = false;

    _agentInfo = UserProfileData(
        accountId: "",
        name: "",
        state: "",
        country: "",
        gender: GenderItem.other,
        birthDate: DateTime.now(),
        uniqueCustomers: 0,
        profilePicture: "",
        joinedDate: DateTime.now(),
        aboutMe: "",
        ratingAverage: 0.0,
        reviewsCount: 0,
        isAgent: true,
        languagesSpoken: []
    );

    _getAgentInfo();
    _getIsFavourite();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
            children: [
              // Image container with rounded corners on top
              Container(
                height: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: imageCarousel(),
              ),
              // Favourite button
              Positioned(
                top: 16,
                left: 16,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.75),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.favorite_border, color: Colors.red),
                ),
              ),
              // Chip container
              Positioned(
                bottom: 16,
                right: 16,
                child: season(),
              ),
              // Image number container
              Positioned(
                top: 16,
                right: 16,
                child: Container(
                  constraints: const BoxConstraints(minWidth: 50),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(child: Text('${_imageIndex + 1}/$_imageCount', style: const TextStyle(color: Colors.white))),
                ),
              ),
              Positioned(bottom: 20, left: 20, child: agentCard()),
            ]
        ),
        // Location, days, and price container
        Container(
          padding: const EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewPackage(packageId: widget.packageId,),
                      ),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${widget.state}, ${widget.country}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), softWrap: true,),
                      Text("${widget.days} days"),
                      Text("Starting from \$$_formattedPrice"),
                      // Label for if package is customizable
                      if (widget.isCustomizable) const Text('Customizable'),
                    ],
                  ),
                ),
              ),
              // Rating average
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(Icons.star, color: Theme.of(context).primaryColor),
                    const SizedBox(width: 4),
                    Text(widget.rating.toStringAsFixed(2)),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8)
      ],
    );
  }

  Widget season() {
    IconData iconData = cupertino.CupertinoIcons.tree;
    String text = 'Spring';
    Color color = Colors.lightGreen.withOpacity(0.75);

    switch(widget.season) {
      case SeasonItem.summer:
        iconData = cupertino.CupertinoIcons.sun_max_fill;
        text = 'Summer';
        color = Colors.orange.withOpacity(0.75);
        break;
      case SeasonItem.autumn:
        iconData = cupertino.CupertinoIcons.wind;
        text = 'Autumn';
        color = Colors.brown.withOpacity(0.75);
        break;
      case SeasonItem.winter:
        iconData = cupertino.CupertinoIcons.snow;
        text = 'Winter';
        color = Colors.blue.withOpacity(0.75);
        break;
      default:
        iconData = cupertino.CupertinoIcons.tree;
        text = 'Spring';
        color = Colors.lightGreen.withOpacity(0.75);
        break;
    }

    return Container(
      width: 100,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(iconData, color: Colors.white, size: 20),
          Text(text, style: const TextStyle(color: Colors.white),),
        ],
      ),
    );
  }

  _getAgentInfo() async {
    // TODO: Get agent info from agentId
    try {
      var url = Uri.parse('https://relo.suliluz.name.my/user/profile/${widget.agentId}}');

      var response = await http.get(url);

      if (response.statusCode == 200) {
        var reloResponse = ReloResponse.fromJson(jsonDecode(response.body));

        if(reloResponse.success) {
          var data = reloResponse.message;
          var agentProfileData = UserProfileData.fromJson(data);

          setState(() {
            _agentInfo = agentProfileData;
          });
        } else {
          print(reloResponse.message);
        }
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      rethrow;
    }
  }

  _getIsFavourite() async {
    // Get refresh token
    var refreshToken = await CredentialsManager.refreshToken();

    if(refreshToken == null) {
      _isFavourite = false;
      return;
    }

    try {
      var url = Uri.parse('https://relo.suliluz.name.my/travel/wishlist/${widget.packageId}}');

      var response = await http.get(url, headers: {
        'Authorization': 'Bearer $refreshToken',
      });

      if (response.statusCode == 200) {
        var reloResponse = ReloResponse.fromJson(jsonDecode(response.body));

        if(reloResponse.success) {
          setState(() {
            _isFavourite = reloResponse.message;
          });
        } else {
          print(reloResponse.message);
        }
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      rethrow;
    }
  }

  Widget agentCard() {
    // If loaded is false, return a loading indicator
    if (_agentInfo.accountId.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: Colors.grey[300],
              backgroundImage: _agentInfo.profilePicture != null
                  ? NetworkImage(_agentInfo.profilePicture!)
                  : null,
              child: Text(
                _agentInfo.profilePicture != null
                    ? ''
                    : _agentInfo.name[0].toUpperCase(),
                style: TextStyle(fontSize: 32, color: Colors.grey[600]),
              ),
            ),
            const SizedBox(width: 8),
            // Text(_agentInfo['name']),
          ],
        ),
      );
    }
  }

  Widget imageCarousel() {
    final List<Widget> items = widget.images.map((String image) {
      return Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(
            image: NetworkImage("https://relo.suliluz.name.my/travel/media/$image",),
            fit: BoxFit.cover,
          ),
        ),
      );
    }).toList();

    return CarouselSlider(
      items: items,
      options: CarouselOptions(
        height: 250,
        viewportFraction: 1,
        enableInfiniteScroll: true,
        onPageChanged: (index, reason) {
          setState(() {
            _imageIndex = index;
          });
        },
      ),
    );
  }

  Widget favouriteButton() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _toggleFavourite();
        });
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.75),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(_isFavourite? Icons.favorite : Icons.favorite_border, color: Colors.red),
      ),
    );
  }

  _toggleFavourite() async {
    // Get refresh token
    var refreshToken = await CredentialsManager.refreshToken();

    if(refreshToken == null) {
      if(mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ),
        );
      }
    }

    try {
      var url = Uri.parse('https://relo.suliluz.name.my/travel/wishlist/');

      var response = await http.post(url, headers: {
        'Authorization': 'Bearer $refreshToken',
      }, body: {
        'travel_package_short_code': widget.packageId,
      });

      if (response.statusCode == 200) {
        var reloResponse = ReloResponse.fromJson(jsonDecode(response.body));

        if(reloResponse.success) {
          if(mounted) {
            // SnackBar showing message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(reloResponse.message),
                duration: const Duration(seconds: 2),
              ),
            );
          }
        } else {
          if(mounted) {
            // SnackBar showing message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(reloResponse.message),
                duration: const Duration(seconds: 2),
              ),
            );
          }
        }
      } else {
        if (kDebugMode) {
          print('Request failed with status: ${response.statusCode}.');
        }
      }
    } catch (e) {
      rethrow;
    } finally {
      if(mounted) {
        _getIsFavourite();
      }
    }
  }
}