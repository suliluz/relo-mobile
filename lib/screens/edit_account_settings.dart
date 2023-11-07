import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import '../business_logic/enums/gender_item.dart';
import '../business_logic/utilities/credentials_manager.dart';
import '../widgets/multi_item_field.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:relo/business_logic/models/relo_response.dart';

class AccountSettingsItems {
  late String name;
  late String gender;
  late DateTime birthday;
  late String country;
  late String state;
  late List<String> languagesSpoken;
  late String about;
  late File? profilePicture;

  AccountSettingsItems();
}

class EditAccountSettings extends StatefulWidget {
  const EditAccountSettings({
    super.key,
    required this.name,
    required this.gender,
    required this.birthday,
    required this.country,
    required this.state,
    required this.languagesSpoken,
    required this.about,
    required this.accountId,
  });

  final String accountId;
  final String name;
  final GenderItem gender;
  final DateTime birthday;
  final String country;
  final String state;
  final List<String> languagesSpoken;
  final String about;

  @override
  State<EditAccountSettings> createState() => _EditAccountSettingsState();
}

class _EditAccountSettingsState extends State<EditAccountSettings> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();

  // Countries list
  final List<String> _countries = [
    'malaysia',
    'singapore',
    'indonesia',
  ];

  // States list
  final List<String> _states = [
    'johor',
    'selangor',
    'perak',
    'sarawak',
  ];

  final AccountSettingsItems _accountSettingsItems = AccountSettingsItems();
  late String _gender;
  late DateTime _dateOfBirth;
  late String _country;
  late String _state;
  late List<String> _languagesSpoken;

  late bool _profilePictureChanged;
  late String _profilePicture;

  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _accountSettingsItems.name = widget.name;
    _accountSettingsItems.gender = widget.gender.name;
    _accountSettingsItems.birthday = widget.birthday;
    _accountSettingsItems.country = widget.country;
    _accountSettingsItems.state = widget.state;
    _accountSettingsItems.languagesSpoken = widget.languagesSpoken;
    _accountSettingsItems.about = widget.about;

    _gender = widget.gender.name;
    _dateOfBirth = widget.birthday;
    _country = widget.country;
    _state = widget.state;
    _dateController.text = widget.birthday.toString().split(' ')[0];
    _languagesSpoken = widget.languagesSpoken;

    _profilePictureChanged = false;
    _profilePicture =
    "https://relo.suliluz.name.my/user/avatar/${widget.accountId}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Account Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Profile picture
                SizedBox(
                  height: 160,
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 80,
                        backgroundColor: Colors.grey[300],
                        backgroundImage: _setAvatar(),
                        child: Text(
                          _profilePictureChanged
                              ? ''
                              : widget.name[0].toUpperCase(),
                          style: TextStyle(fontSize: 32,
                              color: Colors.grey[600]),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: FloatingActionButton(
                          onPressed: () async {
                            // Open image picker
                            final pickedFile = await ImagePicker().pickImage(
                                source: ImageSource.gallery);

                            // If image is selected, update the profile picture
                            if (pickedFile != null) {
                              setState(() {
                                _profilePictureChanged = true;
                                _accountSettingsItems.profilePicture =
                                    File(pickedFile.path);
                              });
                            }
                          },
                          child: const Icon(Icons.camera_alt),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  initialValue: widget.name,
                  decoration: const InputDecoration(
                    labelText: "Name",
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your name.";
                    }
                    return null;
                  },
                  onSaved: (String? value) {
                    _accountSettingsItems.name = value!;
                  },
                ),
                const SizedBox(height: 20),
                // Gender dropdown
                DropdownButtonFormField(
                  value: _gender,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    labelText: 'Gender',
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'male',
                      child: Row(
                        children: [
                          Icon(Icons.male, color: Colors.blue),
                          SizedBox(width: 8),
                          Text('Male'),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'female',
                      child: Row(
                        children: [
                          Icon(Icons.female, color: Colors.pink),
                          SizedBox(width: 8),
                          Text('Female'),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'other',
                      child: Row(
                        children: [
                          Icon(Icons.transgender, color: Colors.purple),
                          SizedBox(width: 8),
                          Text('Other'),
                        ],
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    _gender = value.toString();
                    _accountSettingsItems.gender = value.toString();
                  },
                  validator: (value) =>
                  value == null
                      ? "Please set your gender"
                      : null,
                ),
                const SizedBox(height: 20),
                // Birthday
                TextFormField(
                  controller: _dateController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.calendar_today),
                    border: OutlineInputBorder(),
                    labelText: 'Date of birth',
                  ),
                  onTap: () async {
                    // Open datepicker that starts from 18 years ago
                    var date = await showDatePicker(
                      context: context,
                      initialDate: widget.birthday,
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );

                    // If date is selected, update the textfield
                    if (date != null) {
                      setState(() {
                        _dateOfBirth = date;
                        _dateController.text = _dateOfBirth.toString().split(' ')[0];
                      });
                    }
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your date of birth';
                    }
                    return null;
                  },
                  onSaved: (String? value) {
                    _accountSettingsItems.birthday = DateTime.parse(value!);
                  },
                ),
                const SizedBox(height: 20),
                // Country dropdown
                DropdownButtonFormField(
                  value: _country,
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
                    _country = value.toString();
                    _accountSettingsItems.country = value.toString();
                  },
                  validator: (value) =>
                  value == null
                      ? "Please set your country"
                      : null,
                ),
                const SizedBox(height: 20),
                // State dropdown
                DropdownButtonFormField(
                  value: _state,
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
                    DropdownMenuItem(
                      value: 'sarawak',
                      child: Text('Sarawak'),
                    ),
                  ],
                  onChanged: (value) {
                    _state = value.toString();
                    _accountSettingsItems.state = value.toString();
                  },
                ),
                const SizedBox(height: 20),
                // Languages spoken
                MultiItemField(
                  label: 'Languages spoken',
                  hintText: 'Enter language',
                  onAdded: (value) {
                    setState(() {
                      _languagesSpoken.add(value);
                    });
                  },
                  onDeleted: (value) {
                    setState(() {
                      _languagesSpoken.remove(value);
                    });
                  },
                  items: _languagesSpoken,
                ),
                const SizedBox(height: 20),
                // About
                TextFormField(
                  maxLines: null,
                  initialValue: widget.about,
                  decoration: const InputDecoration(
                    labelText: "About",
                  ),
                  onSaved: (String? value) {
                    _accountSettingsItems.about = value ?? '';
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _isLoading? null : () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      _save();
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _setAvatar() {
    if (_profilePictureChanged) {
      return FileImage(_accountSettingsItems.profilePicture!);
    } else {
      return NetworkImage(_profilePicture);
    }
  }

  _save() async {
    try {
      setState(() {
        _isLoading = true;
      });

      // Get the token
      var refreshToken = await CredentialsManager.refreshToken();

      if (refreshToken == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Please login first"),
              )
          );
        }

        return;
      }

      // HTTP request
      var uri = Uri.parse("https://relo.suliluz.name.my/user/update-profile/");

      // Multipart request
      var request = http.MultipartRequest('POST', uri);

      request.headers['authorization'] = 'Bearer $refreshToken';

      // Add fields
      request.fields['name'] = _accountSettingsItems.name;
      request.fields['gender'] = _accountSettingsItems.gender;
      request.fields['date_of_birth'] = _accountSettingsItems.birthday.toIso8601String();
      request.fields['country'] = _accountSettingsItems.country;
      request.fields['state'] = _accountSettingsItems.state;
      request.fields['languages_spoken'] = _accountSettingsItems.languagesSpoken.join(',');
      request.fields['about_me'] = _accountSettingsItems.about;

      print(request.fields);

      if(_profilePictureChanged) {
        request.files.add(await http.MultipartFile.fromPath('avatar', _accountSettingsItems.profilePicture!.path, contentType: MediaType('image', 'jpeg')));
      }

      var response = await request.send();

      if (response.statusCode == 200) {
        // Process response body
        ReloResponse reloResponse = ReloResponse.fromJson(jsonDecode(response.stream.toString()));

        if (mounted) {
          if (reloResponse.success) {
            // SnackBar
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Account settings saved"),
                duration: Duration(seconds: 2),
              ),
            );
          } else {
            // SnackBar
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Cannot save account settings. Please try again later."),
                duration: Duration(seconds: 2),
              ),
            );
          }
        }
      } else {
        // SnackBar
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Cannot save account settings. Please try again later."),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      rethrow;
    } finally {
      setState(() {
        _isLoading = false;
      });

      Navigator.pop(context, true);
    }
  }
}
