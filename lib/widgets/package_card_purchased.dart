import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart' as cupertino;
import 'package:relo/business_logic/enums/season_item.dart';
import 'package:relo/business_logic/models/media_upload.dart';
import 'package:relo/business_logic/models/package_subscription.dart';
import 'package:relo/business_logic/models/user_profile_data.dart';
import '../business_logic/enums/gender_item.dart';
import '../business_logic/models/package_information.dart';
import '../screens/view_package.dart';
import 'package:relo/business_logic/models/relo_response.dart';



class PackageCardPurchased extends StatefulWidget {
  final PackageSubscription packageSubscription;


  const PackageCardPurchased({
    super.key,
    required this.packageSubscription,
  });

  @override
  State<PackageCardPurchased> createState() => _PackageCardPurchasedState();
}

class _PackageCardPurchasedState extends State<PackageCardPurchased> {
  late int _imageIndex;
  late int _imageCount;
  late String _formattedPrice;

  late PackageInformation _packageInformation;
  late UserProfileData _agentInfo;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _packageInformation = widget.packageSubscription.packageInformation;

    _imageIndex = 0;
    _imageCount = _packageInformation.media.length;

    // Format price with commas
    _formattedPrice = widget.packageSubscription.getPurchasedBookingDate().price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');

    _agentInfo = UserProfileData(
        accountId: "",
        name: "John",
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
            children: [
              Expanded(
                flex: 3,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewPackage(packageId: _packageInformation.travelPackageId,),
                      ),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_packageInformation.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), softWrap: true,),
                      Text("${_packageInformation.state}, ${_packageInformation.country}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), softWrap: true,),
                      Text("${_packageInformation.daysCount} days"),
                      // Put booking date from to here
                      Text("From ${widget.packageSubscription.getPurchasedBookingDate().startingDate.toString().split(' ')[0]} to ${widget.packageSubscription.getPurchasedBookingDate().endingDate.toString().split(' ')[0]}"),
                      Text("\$$_formattedPrice"),
                      // Label on how many pax
                      Text("${widget.packageSubscription.quantity} pax", style: const TextStyle(color: Colors.grey),),
                      const Text("You have purchased this package", style: TextStyle(color: Colors.grey),),
                    ],
                  ),
                ),
              ),
              IconButton(onPressed: () {}, icon: const Icon(Icons.qr_code),),
            ],
          ),
        ),
        // Divider
        const Divider(),
        // Get transaction details button
        Container(
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () {},
                child: const Text("Get transaction details"),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget season() {
    IconData iconData = cupertino.CupertinoIcons.tree;
    String text = 'Spring';
    Color color = Colors.lightGreen.withOpacity(0.75);

    switch(_packageInformation.season) {
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
      var url = Uri.parse('https://relo.suliluz.name.my/user/profile/${_packageInformation.agentId}}');

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
    final List<Widget> items = _packageInformation.media.map((MediaUpload image) {
      return Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(
            image: NetworkImage("https://relo.suliluz.name.my/travel/media/${image.referenceId}",),
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
}