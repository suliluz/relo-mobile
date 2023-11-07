import "dart:convert";

import "package:flutter/material.dart";
import "package:http/http.dart" as http;

import "package:relo/screens/chatroom.dart";
import "package:relo/screens/login_page.dart";
import "package:relo/screens/payment.dart";
import "package:relo/screens/register_as_agent.dart";
import "package:relo/screens/security_settings.dart";
import "package:relo/screens/view_profile.dart";
import "package:relo/business_logic/utilities/credentials_manager.dart";
import "package:relo/business_logic/models/relo_response.dart";

import "account_settings.dart";
import "language.dart";
import "listings_page.dart";
import "notifications.dart";

class UserInformation {
  final String accountId;
  final String name;
  final String? profilePicture;
  final bool isAgent;

  UserInformation({
    required this.accountId,
    required this.name,
    this.profilePicture,
    required this.isAgent,
  });

  factory UserInformation.fromJson(Map<String, dynamic> json) {
    return UserInformation(
      accountId: json['account_id'],
      name: json['name'],
      profilePicture: json['avatar'],
      isAgent: json['is_agent'],
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late UserInformation _userInformation;
  late bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _userInformation = UserInformation(
      accountId: '',
      name: 'Guest',
      profilePicture: null,
      isAgent: false,
    );

    _getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.chat),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => _isLoggedIn()? const ChatroomPage() : const LoginPage()),);
            }
          ),
          IconButton(
            icon: const Icon(Icons.support_agent),
            onPressed: () {

            }
          ),
        ],
      ),
      body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _isLoading? const Center(child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                )) : ListTile(
                  onTap: () {
                    if(!_isLoggedIn()) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ViewProfile(),
                        ),
                      );
                    }
                  },
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: _userInformation.profilePicture != null
                        ? NetworkImage("https://relo.suliluz.name.my/user/avatar/${_userInformation.accountId}")
                        : null,
                    child: Text(
                      _userInformation.profilePicture != null
                          ? ''
                          : _userInformation.name[0].toUpperCase(),
                      style: TextStyle(fontSize: 32, color: Colors.grey[600]),
                    ),
                  ),
                  title: Text(_userInformation.name),
                  subtitle: Text(!_isLoggedIn() ? 'Tap to Login' : 'View Profile'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                ),
                const Divider(),
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text("Settings", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: <Widget>[
                    if(_isLoggedIn()) ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AccountSettings(),
                          ),
                        );
                      },
                      leading: const Icon(Icons.person),
                      title: const Text('Account'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                    ),
                    ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Notifications(),
                          ),
                        );
                      },
                      leading: const Icon(Icons.notifications),
                      title: const Text('Notifications'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                    ),
                    if(_isLoggedIn()) ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SecuritySettings(),
                          ),
                        );
                      },
                      leading: const Icon(Icons.lock_outlined),
                      title: const Text('Security'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                    ),
                    if(_isLoggedIn()) ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PaymentPage(),
                          )
                        );
                      },
                      leading: const Icon(Icons.payment),
                      title: const Text('Payment'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                    ),
                    ListTile(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const LanguagePage()));
                      },
                      leading: const Icon(Icons.language),
                      title: const Text('Language'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                    ),
                    const ListTile(
                      leading: Icon(Icons.help),
                      title: Text('Help'),
                      trailing: Icon(Icons.arrow_forward_ios),
                    ),
                    ListTile(
                      onTap: () {
                        if(_isLoggedIn()) {
                          _doLogout();
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                          );
                        }
                      },
                      leading: _isLoggedIn()? const Icon(Icons.logout) : const Icon(Icons.login),
                      title: Text(_isLoggedIn()? 'Logout' : 'Login'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                    ),
                  ],
                ),
                if(_isLoggedIn()) const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text("Agent", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                Column(
                  children: [
                    ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: <Widget>[
                        // Check listings
                        if(_userInformation.isAgent) ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ListingsPage(),
                              ),
                            );
                          },
                          leading: const Icon(Icons.shopping_bag_outlined),
                          title: const Text('Listings'),
                          trailing: const Icon(Icons.arrow_forward_ios),
                        ),
                        if(!_userInformation.isAgent && _isLoggedIn()) ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RegisterAsAgent(),
                              ),
                            );
                          },
                          leading: const Icon(Icons.business_center),
                          title: const Text('Register as Agent'),
                          trailing: const Icon(Icons.arrow_forward_ios),
                        ),
                      ],
                    ),
                  ],
                ),
                // App version
                const Divider(),
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text("App version: 1.0.0", style: TextStyle(fontSize: 12, color: Colors.grey)),
                ),
              ],
            ),
          )
      ),
    );
  }

  bool _isLoggedIn() => _userInformation.accountId.isNotEmpty;

  _doLogout() async {
    try {
      // Get refresh token
      var refreshToken = await CredentialsManager.refreshToken();

      // HTTP request to get user info
      var response = await http.post(
        Uri.parse('https://relo.suliluz.name.my/user/logout'),
        headers: {'Authorization': 'Bearer $refreshToken'},
        body: {'device_id': await CredentialsManager.deviceID()},
      );

      ReloResponse reloResponse = ReloResponse.fromJson(jsonDecode(response.body));

      if (reloResponse.success == true) {
       // Show success message
        if(mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Logout successful."),
            ),
          );
        }
      } else {
        // Show error message
        if(mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Cannot logout."),
            ),
          );
        }
      }
    } catch (e) {
      if(mounted) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Cannot logout."),
          ),
        );
      }
    } finally {
      // Delete refresh token
      await CredentialsManager.deleteRefreshToken();

      // Set state
      setState(() {
        _userInformation = UserInformation(
          accountId: '',
          name: 'Guest',
          profilePicture: null,
          isAgent: false,
        );
      });
    }
  }

  _getUserInfo() async {
    setState(() {
      _isLoading = true;
    });

    var refreshToken = await CredentialsManager.refreshToken();

    if(refreshToken == null) {
      // Is a guest

      setState(() {
        _isLoading = false;
      });

      return;
    }

    try {
      // HTTP request to get user info
      var response = await http.get(
        Uri.parse('https://relo.suliluz.name.my/user/profile'),
        headers: {'Authorization': 'Bearer $refreshToken'},
      );

      if (response.statusCode == 200) {
        ReloResponse reloResponse = ReloResponse.fromJson(jsonDecode(response.body));

        // Create TravelAgent object
        var user = UserInformation.fromJson(reloResponse.message);

        // Set state
        setState(() {
          _userInformation = user;
        });

      } else {
        if(mounted) {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Cannot load user information."),
            ),
          );
        }
      }
    } catch (e) {
      if(mounted) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Cannot load user information."),
          ),
        );
      }
    } finally {
      print(_isLoading);

      setState(() {
        _isLoading = false;
      });
    }
  }
}
