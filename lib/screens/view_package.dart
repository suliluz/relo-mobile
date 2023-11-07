import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'web_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:relo/business_logic/enums/verification_status.dart';
import 'package:relo/business_logic/models/media_upload.dart';
import 'package:relo/business_logic/models/travel_available_booking_dates.dart';
import 'package:relo/business_logic/models/user_profile_data.dart';
import 'package:relo/constants.dart';
import 'package:relo/screens/error_page.dart';
import 'package:relo/screens/view_package_media.dart';
import 'package:relo/screens/view_profile.dart';

import '../business_logic/models/itinerary.dart';
import '../business_logic/models/package_information.dart';
import '../business_logic/models/relo_response.dart';
import '../business_logic/utilities/credentials_manager.dart';
import 'loading_page.dart';
import 'login_page.dart';

class ViewPackage extends StatefulWidget {
  const ViewPackage({super.key, required this.packageId});

  final String packageId;

  @override
  State<ViewPackage> createState() => _ViewPackageState();
}

class _ViewPackageState extends State<ViewPackage> {
  final ScrollController _scrollController = ScrollController();

  late PackageInformation? _packageInformation;
  late UserProfileData _travelAgent;

  late int _imageIndex;
  late int _imageCount;

  bool _isBottomOfPage = false;
  bool _isLoading = false;
  bool _isFavourite = false;
  bool _isError = false;

  @override
  void initState() {
    super.initState();

    // Add listener to scroll controller
    _scrollController.addListener(_handleBottomPageListener);

    _imageIndex = 0;
    _imageCount = 0;

    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Bottom sheet with book button
      bottomSheet: _isBottomOfPage? null : Container(
        height: 95,
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Price
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("From", style: TextStyle(fontSize: 14)),
                // Convert _pricing to currency format with commas
                Text('\$${_packageInformation?.getLowestPriceBookingDate().price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
              ],
            ),
            // Book button
            ElevatedButton(
              onPressed: () {
                _showBookings();
              },
              child: const Text("Book"),
            ),
          ],
        ),
      ),
      body: _builder(),
    );
  }

  _load() async {
    try {
      setState(() {
        _isLoading = true;
      });

      await _getPackageInfo();
      await _getAgentInfo();

    } catch (e) {
      if (kDebugMode) {
        print(e);
      }

      setState(() {
        _isError = true;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget packageView() {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              // Full width carousel
              GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ViewPackageMedia()));
                  },
                  child: imageCarousel()
              ),
              // Back circular button
              Positioned(
                top: 50,
                left: 16,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
              // Favourite button
              Positioned(
                top: 50,
                right: 16,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(
                    icon: Icon(_isFavourite? Icons.favorite : Icons.favorite_border, color: Colors.red),
                    onPressed: () {
                      _toggleFavourite();
                    },
                  ),
                ),
              ),
              // Share button
              Positioned(
                top: 50,
                right: 70,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(
                    icon: const Icon(Icons.file_upload_outlined),
                    onPressed: () {
                      //TODO: Share package
                    },
                  ),
                ),
              ),
              // Image number container
              Positioned(
                bottom: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text('${_imageIndex + 1}/$_imageCount', style: const TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(_packageInformation!.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                // Location
                ListTile(
                  contentPadding: const EdgeInsets.all(0),
                  dense: true,
                  leading: Icon(Icons.location_on, color: Theme.of(context).primaryColor),
                  title: Text("${_packageInformation?.state}, ${_packageInformation?.country}", style: const TextStyle(fontSize: 16),),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Rating
                        Column(
                          children: [
                            Icon(Icons.star, color: Theme.of(context).primaryColor, size: 28),
                            const SizedBox(height: 4,),
                            Text(_packageInformation!.ratingAverage.toStringAsFixed(2), style: const TextStyle(fontSize: 16)),
                            Text("${_packageInformation?.ratingCount} reviews", style: const TextStyle(fontSize: 14)),
                          ],
                        ),
                        // Days
                        Column(
                          children: [
                            Icon(Icons.calendar_today, color: Theme.of(context).primaryColor),
                            const SizedBox(height: 4,),
                            Text('${_packageInformation?.daysCount} days', style: const TextStyle(fontSize: 16)),
                            const Text("package", style: TextStyle(fontSize: 14)),
                          ],
                        ),
                        // Customizable
                        Column(
                          children: [
                            Icon(_packageInformation!.customizable? Icons.check_circle : Icons.lock, color: Theme.of(context).primaryColor),
                            const SizedBox(height: 4,),
                            Text(_packageInformation!.customizable? 'Customizable' : 'Fixed', style: const TextStyle(fontSize: 16)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16,),
                // Print itinerary button with icon
                GestureDetector(
                  onTap: () {
                    // TODO: Print itinerary
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.print, color: Theme.of(context).primaryColor,),
                      const SizedBox(width: 8),
                      const Text("Print itinerary", style: TextStyle(decoration: TextDecoration.underline),),
                    ],
                  ),
                ),
                const SizedBox(height: 16,),
                agentCard(),
                const Divider(),
                const SizedBox(height: 16,),
                // Tour description
                const Text("Tour description", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8,),
                Text(_packageInformation!.tourHighlights, style: const TextStyle(fontSize: 14),),
                const SizedBox(height: 16,),
                const Divider(),
                const SizedBox(height: 16,),
                // Itinerary details
                // A list of expandable tiles
                const Text("Itinerary details", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16,),
                ExpansionPanelList(
                  expansionCallback: (int index, bool isExpanded) {
                    setState(() {
                      _packageInformation?.itineraries[index].active = !isExpanded;
                    });
                  },
                  // Get itineraries and index of each itinerary
                  children: _packageInformation!.itineraries.asMap().entries.map((entry) {
                    final int index = entry.key;
                    Itinerary itinerary = entry.value;

                    return ExpansionPanel(
                      headerBuilder: (BuildContext context, bool isExpanded) {
                        return ListTile(
                          // Day is index + 1, bolded and with title which isn't bolded, use RichText
                          title: RichText(
                            text: TextSpan(
                              style: const TextStyle(color: Colors.black),
                              children: [
                                TextSpan(text: 'Day ${index + 1}: ', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                TextSpan(text: itinerary.title, style: const TextStyle(fontSize: 14)),
                              ],
                            ),
                          ),
                        );
                      },
                      body: ListTile(
                        title: Text(itinerary.description, style: const TextStyle(fontSize: 14)),
                      ),
                      isExpanded: index == 0? true : itinerary.active,
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16,),
                const Divider(),
                const SizedBox(height: 16,),
                // Terms and conditions
                const Text("Terms and conditions", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16,),
                Text(_packageInformation!.termsAndConditions, style: const TextStyle(fontSize: 14),),
                const SizedBox(height: 16,),
                const Divider(),
                // Put bottom sheet equivalent ListTile here
                Card(
                  child: ListTile(
                    title: const Text("From", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    subtitle: Text('\$${_packageInformation?.getLowestPriceBookingDate().price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},') }', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    trailing: ElevatedButton(
                      onPressed: () {
                        _showBookings();
                      },
                      child: const Text("Book"),
                    ),
                  ),
                ),
                const SizedBox(height: 16,),
                // Report button with icon
                GestureDetector(
                  onTap: () {
                    // TODO: Report listing
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.flag, color: Theme.of(context).primaryColor,),
                      const SizedBox(width: 8),
                      const Text("Report this listing", style: TextStyle(decoration: TextDecoration.underline),),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget agentCard() {
    return Card(
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: _travelAgent.profilePicture != null
                      ? NetworkImage(_travelAgent.profilePicture!)
                      : null,
                  child: Text(
                    _travelAgent.profilePicture != null
                        ? ''
                        : _travelAgent.name[0].toUpperCase(),
                    style: TextStyle(fontSize: 32, color: Colors.grey[600]),
                  ),
                ),
                const SizedBox(width: 8),
                Text(_travelAgent.name),
              ],
            ),
            const SizedBox(height: 8),
            Text(_travelAgent.aboutMe),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.star, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                Text('${_travelAgent.ratingAverage?? ""} (${_travelAgent.reviewsCount?? "No reviews yet"})'),
              ],
            ),
            const SizedBox(height: 8),
            // Verified status
            Row(
              children: [
                Icon(_getVerificationStatus(_travelAgent.verificationStatus!)['icon'], color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                Text(_getVerificationStatus(_travelAgent.verificationStatus!)['text']),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.calendar_today, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                // Convert joined date to month name and year
                Text('Joined ${kMonth[_travelAgent.joinedDate.month - 1]} ${_travelAgent.joinedDate.year}'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.language, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                Text(_travelAgent.languagesSpoken.join(', ')),
              ],
            ),
            Row(
              children: [
                // View profile button
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewProfile(accountId: _travelAgent.accountId,),
                      ),
                    );
                  },
                  child: const Text('View profile'),
                ),
                const SizedBox(width: 8),
                // Message button
                ElevatedButton(
                  onPressed: () {
                    // TODO: Message agent
                  },
                  child: const Text('Message'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget imageCarousel() {
    final List<Widget> items = _packageInformation!.media.map((MediaUpload image) {
      return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(image.referenceId),
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

  _showBookings() {
    // Controller for text field
    TextEditingController _quantityController = TextEditingController();

    // Show bookings
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Title
              ListTile(
                title: const Text("Bookings", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                trailing: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              // Quantity
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Text("Quantity: ", style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 8),
                  Expanded(child: TextField(
                    controller: _quantityController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  )),
                ],
              ),
              Expanded(
                flex: 7,
                child: ListView(
                  children: _packageInformation!.bookingDates.map((bookingDate) {
                    return ListTile(
                      // Start date to end date
                      title: Text("${bookingDate.startingDate.toString().split(' ')[0]} - ${bookingDate.endingDate.toString().split(' ')[0]}", style: const TextStyle(fontSize: 14),),
                      // Pricing with formatting
                      subtitle: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("\$${bookingDate.price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},') }", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(width: 8),
                          const Icon(Icons.circle, size: 4, color: Colors.grey),
                          const SizedBox(width: 8),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.person, color: Theme.of(context).primaryColor, size: 20),
                              const SizedBox(width: 4),
                              Text("${bookingDate.slotsTaken}/${bookingDate.slotsTotal}"),
                            ],
                          ),
                        ],
                      ),
                      // Booking slots over total slots, and book now button
                      trailing: TextButton(
                        onPressed: (){
                          _bookNow(bookingDate.bookingDateId, int.parse(_quantityController.text));
                        },
                        child: const Text("Book now"),
                      ),
                    );
                  }).toList(),
                ),
              ),
              Flexible(
                child: Text("A deposit of ${_packageInformation?.depositPercentage}% will be first charged for all bookings, the rest will be charged 2 weeks before the start date.", style: const TextStyle(fontSize: 14)),
              )
            ],
          ),
        );
      });
  }

  _getPackageInfo() async {
    try {
      var url = Uri.parse('https://relo.suliluz.name.my/travel/package/${widget.packageId}');

      final response = await http.get(url);

      if(response.statusCode == 200) {
        var reloResponse = ReloResponse.fromJson(jsonDecode(response.body));

        if(reloResponse.success) {
          _packageInformation = PackageInformation.fromJson(reloResponse.message);
          _imageCount = _packageInformation!.media.length;
        } else {
          if (kDebugMode) {
            print(reloResponse.message);
          }
        }
      } else {
        if (kDebugMode) {
          print('Request failed with status: ${response.statusCode}.');
        }
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
          _isFavourite = reloResponse.message;
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

  _getAgentInfo() async {
    // Get agent info from API
    var url = Uri.parse('https://relo.suliluz.name.my/user/profile/${_packageInformation!.agentId}');

    try {
      final response = await http.get(url);

      if(response.statusCode == 200) {
        var reloResponse = ReloResponse.fromJson(jsonDecode(response.body));

        if(reloResponse.success) {
          _travelAgent = UserProfileData.fromJson(reloResponse.message);
        } else {
          if (kDebugMode) {
            print(reloResponse.message);
          }
        }
      } else {
        if (kDebugMode) {
          print('Request failed with status: ${response.statusCode}.');
        }
      }
    } catch (e) {
      rethrow;
    }
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

  Map<String, dynamic> _getVerificationStatus(VerificationStatus verificationStatus) {
    switch(verificationStatus) {
      case VerificationStatus.verified:
        return {
          'icon': Icons.verified,
          'text': 'Verified agent',
        };
      case VerificationStatus.partial:
        return {
          'icon': Icons.hourglass_bottom,
          'text': 'Partially verified agent',
        };
      case VerificationStatus.pending:
        return {
          'icon': Icons.library_add_check_rounded,
          'text': 'Pending verification',
        };
      default:
        return {
          'icon': Icons.gpp_bad_outlined,
          'text': 'Unverified agent',
        };
    }
  }

  Widget _builder() {
    if (_isLoading) {
      return const LoadingPage();
    } else if (!_isError && _packageInformation != null) {
      return packageView();
    } else {
      return const ErrorPage();
    }
  }

  _handleBottomPageListener() {
    // If 95 almost to bottom, put almost to bottom into console
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent - 95) {
      setState(() {
        _isBottomOfPage = true;
      });
    } else {
      setState(() {
        _isBottomOfPage = false;
      });
    }
  }

  _bookNow(String bookingDateId, int quantity) async {
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
      var url = Uri.parse('https://relo.suliluz.name.my/travel/purchase');

      var response = await http.post(url, headers: {
        'Authorization': 'Bearer $refreshToken',
        'Content-Type': 'application/x-www-form-urlencoded',
      }, body: {
        'package_short_code': widget.packageId,
        'booking_date_id': bookingDateId,
        'quantity': quantity.toString(),
      });

      if (response.statusCode == 200) {
        var reloResponse = ReloResponse.fromJson(jsonDecode(response.body));

        if(reloResponse.success) {
          if(mounted) {
            // Should open WebView
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return WebViewPage(
                  url: reloResponse.message,
                  title: "Purchase booking",
                  backAction: () {}
              );
            }));
          }
        } else {
          if(mounted) {
            // SnackBar showing message

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
