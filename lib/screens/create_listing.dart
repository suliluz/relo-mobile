import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart' as cupertino;
import 'package:http_parser/http_parser.dart';
import 'package:relo/screens/login_page.dart';
import 'package:relo/screens/modify_booking_dates.dart';
import 'package:relo/widgets/itinerary_detail_editable.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:relo/widgets/media_editable_item.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:mime/mime.dart';
import 'package:file_picker/file_picker.dart';
import 'package:relo/business_logic/models/relo_response.dart';
import 'package:relo/business_logic/utilities/credentials_manager.dart';
import '../business_logic/models/itinerary.dart';

class CreateListingBody {
  late String title = "";
  late String season = "";
  late String tourDescription = "";
  late String termsAndConditions = "";
  late int depositPercentage = 0;
  late List<Itinerary> itineraries = [];
  late List<File> media = [];
  late File? pdf = null;
  late bool isCustomizable = false;
  late String country = "";
  late String state = "";
  late String tourType = "";

  CreateListingBody();
}

class CreateListing extends StatefulWidget {
  const CreateListing({super.key});

  @override
  State<CreateListing> createState() => _CreateListingState();
}

class _CreateListingState extends State<CreateListing> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final CreateListingBody _createListingBody = CreateListingBody();

  late List<AssetEntity> _selectedMedia = [];
  late bool _isLoading = false;

  late List<MediaEditableItem> _mediaEditableItems = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    AssetPicker.registerObserve();
    // Enables logging with the photo_manager.
    PhotoManager.setLog(true);

    _createListingBody.itineraries.add(
        Itinerary(
          title: "",
          description: "",
          active: true
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Listing'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Upload media text
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Upload Media', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    // Button to upload media
                    ElevatedButton.icon(
                      onPressed: () {
                        _handleMediaPicker();
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Add'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      direction: Axis.horizontal,
                      children: _mediaEditableItems,
                  ),
                ),
                const SizedBox(height: 16),
                // Listing title in rounded corner text field
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    labelText: 'Listing Title',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a listing title';
                    }
                    return null;
                  },
                  onSaved: (String? value) {
                    _createListingBody.title = value!;
                  },
                ),
                const SizedBox(height: 16),
                // Country dropdown
                DropdownButtonFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    labelText: 'Country',
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'malaysia',
                      child: Text('Malaysia'),
                    ),
                    DropdownMenuItem(
                      value: 'singapore',
                      child: Text('Singapore'),
                    ),
                    DropdownMenuItem(
                      value: 'indonesia',
                      child: Text('Indonesia'),
                    ),
                  ],
                  onChanged: (value) {
                    _createListingBody.country = value.toString();
                  },
                  validator: (value) => value == null? "Please set your country" : null,
                ),
                const SizedBox(height: 16),
                // State dropdown
                DropdownButtonFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    labelText: 'State',
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'johor',
                      child: Text('Johor'),
                    ),
                    DropdownMenuItem(
                      value: 'selangor',
                      child: Text('Selangor'),
                    ),
                    DropdownMenuItem(
                      value: 'perak',
                      child: Text('Perak'),
                    ),
                  ],
                  onChanged: (value) {
                    _createListingBody.state = value.toString();
                  },
                ),
                const SizedBox(height: 16),
                // Dropdown with 4 options: Summer, Autumn, Winter, Spring, with icons
                DropdownButtonFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    labelText: 'Season',
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'spring',
                      child: Row(
                        children: [
                          Icon(cupertino.CupertinoIcons.tree, color: Colors.lightGreen),
                          SizedBox(width: 8),
                          Text('Spring'),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'summer',
                      child: Row(
                        children: [
                          Icon(cupertino.CupertinoIcons.sun_max_fill, color: Colors.orange),
                          SizedBox(width: 8),
                          Text('Summer'),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'autumn',
                      child: Row(
                        children: [
                          Icon(cupertino.CupertinoIcons.wind, color: Colors.brown),
                          SizedBox(width: 8),
                          Text('Autumn'),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'winter',
                      child: Row(
                        children: [
                          Icon(cupertino.CupertinoIcons.snow, color: Colors.blue),
                          SizedBox(width: 8),
                          Text('Winter'),
                        ],
                      ),
                    ),
                  ],
                  onChanged: (String? value) {
                    setState(() {
                      _createListingBody.season = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                // Tour description as textarea in rounded corner text field
                TextFormField(
                  minLines: 1,
                  maxLines: null,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    labelText: 'Tour Description',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a tour description';
                    }
                    return null;
                  },
                  onSaved: (String? value) {
                    _createListingBody.tourDescription = value!;
                  },
                ),
                const SizedBox(height: 16),
                // Tour type with selection of group and private
                DropdownButtonFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    labelText: 'Tour Type',
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'group',
                      child: Text('Group'),
                    ),
                    DropdownMenuItem(
                      value: 'private',
                      child: Text('Private'),
                    ),
                  ],
                  onChanged: (value) {
                    _createListingBody.tourType = value.toString();
                  },
                ),
                const SizedBox(height: 16),
                // Terms and conditions text field
                TextFormField(
                  minLines: 1,
                  maxLines: null,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    labelText: 'Terms and Conditions',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter terms and conditions';
                    }
                    return null;
                  },
                  onSaved: (String? value) {
                    _createListingBody.termsAndConditions = value!;
                  },
                ),
                const SizedBox(height: 16),
                // Deposit percentage amount max is 50, allow only numbers
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          labelText: 'Deposit Percentage',
                        ),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a deposit percentage';
                          }
                          return null;
                        },
                        onSaved: (String? value) {
                          _createListingBody.depositPercentage = int.parse(value!);
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Icon(Icons.percent, color: Colors.grey),
                  ]
                ),
                // Tickbox for customizable
                Row(
                  children: [
                    Checkbox(
                      value: _createListingBody.isCustomizable,
                      onChanged: (value) {
                        setState(() {
                          _createListingBody.isCustomizable = value!;
                        });
                      },
                    ),
                    const Text('Customizable'),
                  ],
                ),
                const SizedBox(height: 16),
                // Add PDF button
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () async {
                        FilePickerResult? result = await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['pdf'],
                        );

                        if(result != null) {
                          _createListingBody.pdf = File(result.files.single.path!);
                        }
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Add PDF'),
                    ),
                    const SizedBox(width: 16),
                    Visibility(visible: _createListingBody.pdf != null, child: const Text('1 PDF Selected')),
                  ]
                ),
                const SizedBox(height: 16),
                // Text: itinerary details
                const Text('Itinerary Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: _createListingBody.itineraries.map((itinerary) {
                    return ItineraryDetailEditable(
                      day: _createListingBody.itineraries.indexOf(itinerary) + 1,
                      title: itinerary.title,
                      description: itinerary.description,
                      onDelete: () {
                        setState(() {
                          _createListingBody.itineraries.removeWhere((element) => element == itinerary);
                        });
                      },
                      onEdit: (String title, String description) {
                        itinerary.title = title;
                        itinerary.description = description;
                      },
                    );
                  }).toList()
                ),
                const SizedBox(height: 16),
                // Button to add itinerary details
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _createListingBody.itineraries.add(Itinerary(title: "", description: ""));
                    });
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add Itinerary Details'),
                ),
                const SizedBox(height: 16),
                // Wide button to save listing
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();

                        _postListing();
                      }
                    },
                    child: const Text('Save listing and set up booking dates'),
                  ),
                ),
              ],
            ),
          ),
        )
      ),
    );
  }

  _handleMediaPicker() async {
    final List<AssetEntity>? result = await AssetPicker.pickAssets(
      context,
      pickerConfig: AssetPickerConfig(
        maxAssets: 20,
        selectedAssets: _selectedMedia,
      ),
    );

    List<File> media = [];

    if (result != null) {
      for (var asset in result) {
        var file = await asset.file;
        media.add(file!);
      }
    }

    _selectedMedia = result ?? [];
    await _rebuildMediaEditableList();
  }

  _rebuildMediaEditableList() async {
    List<File> media = [];
    _mediaEditableItems = [];

    for(var asset in _selectedMedia) {
      var file = await asset.file;
      media.add(file!);

      // Get file type
      final mimeType = lookupMimeType(file.path)!.split("/");

      if (mimeType[0] == "image") {
        _mediaEditableItems.add(MediaEditableItem(
            source: MediaSource.fileImage,
            url: file.path,
            onDelete: () {
              // Find and remove the item from the list
              _selectedMedia.removeWhere((element) => element.id == asset.id);
              setState(() {});
              _rebuildMediaEditableList();
            }
        ));
      } else {
        _mediaEditableItems.add(MediaEditableItem(
            source: MediaSource.fileVideo,
            url: file.path,
            onDelete: () {
              _selectedMedia.removeWhere((element) => element.id == asset.id);
              setState(() {});
              _rebuildMediaEditableList();
            }
        ));
      }
    }

    _createListingBody.media = media;

    setState(() {});
  }

  _postListing() async {
    try {
      setState(() {
        _isLoading = true;
      });

      // Get refresh token
      String? refreshToken = await CredentialsManager.refreshToken();

      // If no refresh token, push to login page
      if (refreshToken == null) {
        if(mounted) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
        }

        return;
      }

      var request = http.MultipartRequest('POST', Uri.parse('https://relo.suliluz.name.my/travel/create'));

      request.headers['Authorization'] = 'Bearer $refreshToken';

      request.fields.addAll({
        'name': _createListingBody.title,
        'season': _createListingBody.season,
        'tour_highlights': _createListingBody.tourDescription,
        'terms_and_conditions': _createListingBody.termsAndConditions,
        'payment_term_percent': _createListingBody.depositPercentage.toString(),
        'package_customizable': _createListingBody.isCustomizable.toString(),
        'country': _createListingBody.country,
        'state': _createListingBody.state,
        'tour_type': _createListingBody.tourType,
      });

      // Add into "days" array
      for (var itinerary in _createListingBody.itineraries) {
        request.fields.addAll({
          'days[${_createListingBody.itineraries.indexOf(itinerary)}][title]': itinerary.title,
          'days[${_createListingBody.itineraries.indexOf(itinerary)}][description]': itinerary.description,
        });
      }

      for (var media in _createListingBody.media) {
        request.files.add(await http.MultipartFile.fromPath('media', media.path, contentType: MediaType('image', 'jpeg')));
      }

      if (_createListingBody.pdf != null) {
        request.files.add(await http.MultipartFile.fromPath('pdf', _createListingBody.pdf!.path, contentType: MediaType('application', 'pdf')));
      }

      var response = await request.send();

      if (response.statusCode == 200) {
        // Get response
        var responseString = await response.stream.bytesToString();
        var reloResponse = ReloResponse.fromJson(jsonDecode(responseString));

        // If success, go to modify booking dates page
        if(mounted) {
          if (reloResponse.success) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const ModifyBookingDates(packageId: "0",)));
          } else {
            // If failed, show error message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(reloResponse.message),
              ),
            );
          }
        }
      } else {
        // If failed, show error message
        if(mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to create listing'),
            ),
          );
        }
      }

    } catch (e) {
      print(e);
      rethrow;
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
