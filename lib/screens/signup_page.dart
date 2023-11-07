import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:relo/business_logic/models/relo_response.dart';
import '../widgets/multi_item_field.dart';
import 'login_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  late String _accountID;
  late String _password;
  late String _name;
  late String _email;
  late DateTime _dateOfBirth;
  late String _gender;
  late String _country;
  late String _state;
  late final List<String> _languagesSpoken = [];

  late bool _isLoading = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Sign up", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,),),
                const SizedBox(height: 30),
                // Account ID circular textfield
                Container(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
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
                  child: TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(),
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
                const SizedBox(height: 20),
                // Name textfield
                Container(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                      labelText: 'Name',
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                    onSaved: (String? value) {
                      _name = value!;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                // Email textfield
                Container(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        // With email regex validation
                        RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
          
                        if (!emailRegex.hasMatch(value!)) {
                          return 'Please enter a valid email';
                        }
                      }
                      return null;
                    },
                    onSaved: (String? value) {
                      _email = value!;
                    },
                  ),
                ),
                // Read only date picker textfield
                const SizedBox(height: 20),
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
                      initialDate: DateTime.now().subtract(const Duration(days: 18 * 365)),
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
                ),
                const SizedBox(height: 20),
                // Gender dropdown
                DropdownButtonFormField(
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
                  },
                  validator: (value) => value == null? "Please set your gender" : null,
                ),
                const SizedBox(height: 20),
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
                    _country = value.toString();
                  },
                  validator: (value) => value == null? "Please set your country" : null,
                ),
                const SizedBox(height: 20),
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
                    _state = value.toString();
                  },
                ),
                // Set languages spoken
                const SizedBox(height: 20),
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
                // Register button full width
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading? null : () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();

                        setState(() {
                          _isLoading = true;
                        });

                        _doSignup();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text('Register', style: TextStyle(fontSize: 18),),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _doSignup() async {
    // Do signup
    final Map<String, dynamic> data = {
      'account_id': _accountID,
      'password': _password,
      'email': _email,
      'name': _name,
      'date_of_birth': _dateOfBirth.toIso8601String(),
      'gender': _gender,
      'country': _country,
      'state': _state,
      'languages_spoken': _languagesSpoken,
    };

    try {
      var response = await http.post(
        Uri.parse('https://relo.suliluz.name.my/user/signup'),
        body: jsonEncode(data),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if(mounted) {
        if (response.statusCode == 200) {
          // Signup successful
          var reloResponse = ReloResponse.fromJson(jsonDecode(response.body));

          if(reloResponse.success) {
            // Snack bar
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Signup successful'),
              )
            );

            // Navigate to login page
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginPage(),
              ),
            );
          } else {
            // Show error message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(reloResponse.message),
              ),
            );
          }
        } else {
          // Signup failed
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Please try again later"),
            ),
          );
        }
      }
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred'),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
