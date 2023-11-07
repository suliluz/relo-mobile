import "dart:convert";

import "package:flutter/material.dart";
import "package:http/http.dart" as http;
import "package:relo/business_logic/enums/gender_item.dart";
import "package:relo/business_logic/models/user_profile_data.dart";
import "package:relo/business_logic/utilities/credentials_manager.dart";

import "../business_logic/models/relo_response.dart";
import "edit_account_settings.dart";

class AccountSettings extends StatefulWidget {
  const AccountSettings({super.key});

  @override
  State<AccountSettings> createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
  late UserProfileData _userProfileData;
  late bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _userProfileData = UserProfileData(
        accountId: "",
        name: "Example",
        state: "",
        country: "",
        gender: GenderItem.other,
        birthDate: DateTime.now(),
        aboutMe: "",
        joinedDate: DateTime.now(),
        isAgent: false,
        languagesSpoken: []
    );

    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Account"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              // Profile picture
              SizedBox(
                child: CircleAvatar(
                  radius: 80,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: _userProfileData.profilePicture != null
                      ? NetworkImage("https://relo.suliluz.name.my/user/avatar/${_userProfileData.accountId}")
                      : null,
                  child: Text(
                    _userProfileData.profilePicture != null
                        ? ''
                        : _userProfileData.name[0].toUpperCase(),
                    style: TextStyle(fontSize: 32, color: Colors.grey[600]),
                  ),
                )
              ),
              const SizedBox(height: 20),
              ListTile(
                isThreeLine: true,
                leading: const Icon(Icons.person, color: Colors.black54, size: 24),
                title: const Text("Name", style: TextStyle(color: Colors.black54, fontSize: 14)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _isLoading? const CircularProgressIndicator() : Text(_userProfileData.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const Text("This is how your name will be displayed in the app."),
                  ],
                ),
              ),
              // Gender
              ListTile(
                isThreeLine: true,
                leading: const Icon(Icons.wc, color: Colors.black54, size: 24),
                title: const Text("Gender", style: TextStyle(color: Colors.black54, fontSize: 14)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _isLoading? const CircularProgressIndicator() : Text(_genderType(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const Text("Your gender will be displayed in the app.")
                  ],
                ),
              ),
              // birthday
              ListTile(
                isThreeLine: true,
                leading: const Icon(Icons.cake, color: Colors.black54, size: 24),
                title: const Text("Birthday", style: TextStyle(color: Colors.black54, fontSize: 14)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _isLoading? const CircularProgressIndicator() : Text(_userProfileData.birthDate.toString().split(' ')[0], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const Text("Through your birthday, your age will be displayed in the app.")
                  ],
                ),
              ),
              // Location
              ListTile(
                isThreeLine: true,
                leading: const Icon(Icons.location_on, color: Colors.black54, size: 24),
                title: const Text("Location", style: TextStyle(color: Colors.black54, fontSize: 14)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _isLoading? const CircularProgressIndicator() : Text("${_userProfileData.state}, ${_userProfileData.country}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const Text("Your location will be displayed in the app.")
                  ],
                ),
              ),
              // Languages spoken
              ListTile(
                isThreeLine: true,
                leading: const Icon(Icons.language, color: Colors.black54, size: 24),
                title: const Text("Languages spoken", style: TextStyle(color: Colors.black54, fontSize: 14)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _isLoading? const CircularProgressIndicator() : Text(_userProfileData.languagesSpoken.join(", "), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const Text("Your languages spoken will help agents serve you better.")
                  ],
                ),
              ),
              // About
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: GestureDetector(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const ListTile(
                        contentPadding: EdgeInsets.all(0),
                        minVerticalPadding: 0,
                        leading: Icon(Icons.info, color: Colors.black54, size: 24),
                        title: Text("About", style: TextStyle(color: Colors.black54, fontSize: 14)),
                      ),
                      _isLoading? const CircularProgressIndicator() : Text(_userProfileData.aboutMe, style: const TextStyle(color: Colors.black54, fontSize: 14)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              // Save button, which is only enabled when the user has edited something
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    var info = Navigator.push(context, MaterialPageRoute(
                        builder: (context) => EditAccountSettings(
                          accountId: _userProfileData.accountId,
                          name: _userProfileData.name,
                          gender: _userProfileData.gender,
                          birthday: _userProfileData.birthDate,
                          country: _userProfileData.country,
                          state: _userProfileData.state,
                          languagesSpoken: _userProfileData.languagesSpoken,
                          about: _userProfileData.aboutMe,
                      ),
                    ));

                    if(info != null) _load();
                  },
                  child: const Text("Edit information"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _load() async {
    setState(() {
      _isLoading = true;
    });

    // Get access token from credentials manager
    String? refreshToken = await CredentialsManager.refreshToken();

    if(refreshToken == null) {
      if(mounted) {
        Navigator.pop(context);

        // SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Cannot load settings. Please try again later."),
            duration: Duration(seconds: 2),
          ),
        );
      }

      return;
    }

    // Get user data
    try {
      // HTTP request
      var request = await http.get(
        Uri.parse("https://relo.suliluz.name.my/user/profile"),
        headers: {'Authorization': 'Bearer $refreshToken'}
      );

      // Check if request returns 200 OK
      if(request.statusCode == 200) {
        // Process response body
        ReloResponse reloResponse = ReloResponse.fromJson(jsonDecode(request.body));

        if(reloResponse.success) {
          _userProfileData = UserProfileData.fromJson(reloResponse.message);
        } else {
          // Handle unsuccessful login
          // Login unsuccessful with snackbar
          if(mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(reloResponse.message),
                duration: const Duration(seconds: 2),
              ),
            );
          }
        }
      } else {
        // Handle other status codes
        // Login unsuccessful with snackbar
        if(mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please try again later.'),
              duration: Duration(seconds: 2),
            ),
          );

          Navigator.pop(context);
        }
      }
    } catch (e) {
      if(mounted) {
        Navigator.pop(context);

        // SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Cannot load settings. Please try again later."),
            duration: Duration(seconds: 2),
          ),
        );
      }

      return;
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _genderType() {
    switch(_userProfileData.gender) {
      case GenderItem.female:
        return "Female";
      case GenderItem.male:
        return "Male";
      case GenderItem.other:
        return "Rather not say";
    }
  }
}
