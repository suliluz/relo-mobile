import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:relo/business_logic/enums/gender_item.dart';
import 'package:relo/business_logic/models/relo_response.dart';
import 'package:relo/screens/error_page.dart';

import '../business_logic/models/user_profile_data.dart';
import '../business_logic/utilities/credentials_manager.dart';
import 'loading_page.dart';

class ViewProfile extends StatefulWidget {
  const ViewProfile({
    super.key,
    this.accountId,
  });

  final String? accountId;

  @override
  State<ViewProfile> createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  late UserProfileData userProfileData;

  bool _isLoading = false;
  bool _isError = false;

  @override
  void initState() {
    super.initState();

    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: _body(),
      ),
    );
  }

  Widget _buildSuccess() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 300,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                // Background Image
                Container(
                  // Gradient of 591da9, 051960
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF591da9),
                        Color(0xFF051960),
                      ],
                    ),
                  ),
                  height: 300,
                ),
                // Profile Image
                Positioned(
                  top: 25,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey[300],
                        backgroundImage: userProfileData.profilePicture != null
                            ? NetworkImage(userProfileData.profilePicture!)
                            : null,
                        child: Text(
                          userProfileData.profilePicture != null
                              ? ''
                              : userProfileData.name[0].toUpperCase(),
                          style: TextStyle(fontSize: 32, color: Colors.grey[600]),
                        ),
                      ),
                    ),
                  ),
                ),
                // Name
                Positioned(
                  top: 125,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(8),
                    child: Center(child: Text(userProfileData.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white))),
                  ),
                ),
                // Location
                Positioned(
                  top: 150,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(8),
                    child: Center(child: Text('${userProfileData.state}, ${userProfileData.country}', style: const TextStyle(fontSize: 16, color: Colors.white))),
                  ),
                ),
                // Grid of 3
                Positioned(
                  top: 200,
                  left: 0,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Gender
                        Column(
                          children: [
                            Icon(getGenderIcon(userProfileData.gender), color: Colors.white, size: 28),
                            Text(getGenderString(userProfileData.gender), style: const TextStyle(color: Colors.white, fontSize: 16)),
                          ],
                        ),
                        Column(
                          children: [
                            Text((DateTime.now().difference(userProfileData.birthDate).inDays ~/ 365).toString(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                            const Text('Age', style: TextStyle(fontSize: 16, color: Colors.white)),
                          ],
                        ),
                        // Number formatted unique customers
                        if(userProfileData.isAgent) Column(
                          children: [
                            Text(NumberFormat.compact().format(userProfileData.uniqueCustomers), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                            const Text('Unique customers', style: TextStyle(fontSize: 16, color: Colors.white)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Message button with icon and background of primary color
          GestureDetector(
            onTap: () {
              // TODO: Implement message
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.message, color: Colors.white),
                    SizedBox(width: 8),
                    Text('Message', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ),
          ),
          // Browse packages
          if(userProfileData.isAgent) GestureDetector(
            onTap: () {
              // TODO: Implement browse packages
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shopping_bag, color: Colors.white),
                    SizedBox(width: 8),
                    Text('Browse packages', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ),
          ),
          // Joined date
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text("Joined Date", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(userProfileData.joinedDate.toString().split(' ')[0], style: const TextStyle(fontSize: 16)),
          ),
          // About
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text("About", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(userProfileData.aboutMe, softWrap: true,),
          ),
          // Review
          if(userProfileData.isAgent) Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Text("Review", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.star, color: Theme.of(context).primaryColor,),
                    const SizedBox(width: 6,),
                    Text("${userProfileData.ratingAverage} average from ${userProfileData.reviewsCount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (match) => '${match[1]},')} reviews"),
                  ],
                )
              ),
              GestureDetector(
                onTap: () {
                  // TODO: Implement reviews
                },
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.rate_review, color: Colors.white),
                        SizedBox(width: 8),
                        Text('Reviews', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Divider(),
          // Report
          GestureDetector(
            onTap: () {
              // TODO: Implement report
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.report_problem_outlined, color: Colors.white),
                    const SizedBox(width: 8),
                    Text('Report ${userProfileData.isAgent? "agent" : "user"}', style: const TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData getGenderIcon(GenderItem genderItem) {
    switch (genderItem) {
      case GenderItem.male:
        return Icons.male;
      case GenderItem.female:
        return Icons.female;
      case GenderItem.other:
        return Icons.transgender;
      default:
        return Icons.help_outline;
    }
  }

  String getGenderString(GenderItem genderItem) {
    switch (genderItem) {
      case GenderItem.male:
        return 'Male';
      case GenderItem.female:
        return 'Female';
      case GenderItem.other:
        return 'Transgender';
      default:
        return 'Unknown';
    }
  }

  Widget _body() {
    if(_isLoading) {
      return const LoadingPage();
    } else if (!_isLoading && !_isError) {
      return _buildSuccess();
    } else {
      return const ErrorPage();
    }
  }

  _loadProfile() async {
    try {
      Uri url;

      if(widget.accountId == null) {
        // Get current user's profile
        url = Uri.parse('https://relo.suliluz.name.my/user/profile');
      } else {
        // Get other user's profile
        url = Uri.parse('https://relo.suliluz.name.my/user/profile/${widget.accountId}');
      }

      // Check if logged in
      var refreshToken = await CredentialsManager.refreshToken();

      // Run HTTP request here
      http.Response response;

      if(refreshToken == null) {
        response = await http.get(url);
      } else {
        response = await http.get(url, headers: {
          'Authorization': 'Bearer ${await CredentialsManager.refreshToken()}',
        });
      }

      if (response.statusCode == 200) {
        var reloResponse = ReloResponse.fromJson(jsonDecode(response.body));

        if(reloResponse.success) {
          print(reloResponse.message);

          // Handle successful response
            userProfileData = UserProfileData.fromJson(reloResponse.message);
        } else {
          // Handle unsuccessful response
          throw Exception('Unsuccessful response');
        }
      } else {
        // Handle unsuccessful response
        throw Exception('Unsuccessful response');
      }
    } catch (e) {
      rethrow;
    }
  }

  _load() async {
    try {
      setState(() {
        _isLoading = true;
      });

      await _loadProfile();

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isError = true;
      });

      rethrow;
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}

