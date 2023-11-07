import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:relo/screens/signup_page.dart';
import 'package:http/http.dart' as http;
import 'package:relo/business_logic/utilities/credentials_manager.dart';
import 'package:relo/business_logic/models/relo_response.dart';

import 'main_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late String _accountID;
  late String _password;

  late bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    // Check if user is already logged in
    _checkLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Login to Relo", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),),
              const SizedBox(height: 30),
              // Account ID circular textfield
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                child: TextFormField(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    labelText: 'Account ID',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your account ID';
                    }
                    return null;
                  },
                  onSaved: (String? value) {
                    _accountID = value!;
                  },
                ),
              ),
              const SizedBox(height: 20),
              // Password circular textfield
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                child: TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    labelText: 'Password',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                  onSaved: (String? value) {
                    _password = value!;
                  },
                ),
              ),
              const SizedBox(height: 30),
              // Login primary color elevated button, with same height as textfields
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading? null : () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      setState(() {
                        _isLoading = true;
                      });
                      _doLogin();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text('Login', style: TextStyle(fontSize: 18),),
                ),
              ),
              const SizedBox(height: 20),
              // Register secondary color text button
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Don\'t have an account?'),
                  const SizedBox(width: 5),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignupPage(),
                        ),
                      );
                    },
                    child: const Text('Register Now', style: TextStyle(color: Colors.grey)),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            ],
          ),
        ),
      )
    );
  }

  _doLogin() async {
    try {
      final response = await http.post(
        Uri.parse('https://relo.suliluz.name.my/user/login'),
        body: {
          'accountId': _accountID,
          'password': _password,
          'deviceId': await CredentialsManager.deviceID()
        },
      );

      if (response.statusCode == 200) {
        // Process response body
        ReloResponse reloResponse = ReloResponse.fromJson(jsonDecode(response.body));

        if(reloResponse.success) {
          // Handle successful login
          await CredentialsManager.setRefreshToken(reloResponse.message);

          // Login successful with snackbar, navigator pop
          if(mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Login successful!'),
                duration: Duration(seconds: 2),
              ),
            );

            Navigator.pop(context, true);
          }
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
        }
      }
    } catch (e) {
      // Handle network errors
      // Login unsuccessful with snackbar
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please try again later.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Check login by their refresh token
  _checkLogin() async {
    var refreshToken = await CredentialsManager.refreshToken();

    // Already logged in, navigate to main page
    if(refreshToken != null) {
      if(mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainPage()));
      }
    }
  }
}
