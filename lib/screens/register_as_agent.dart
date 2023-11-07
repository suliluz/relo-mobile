import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:relo/business_logic/models/relo_response.dart';
import 'package:relo/business_logic/utilities/credentials_manager.dart';
import 'package:http_parser/http_parser.dart';

class RegisterAsAgentItem {
  late String bank;
  late String bankNumber;
  late File? passport;
  late File? drivingLicense;

  RegisterAsAgentItem({
    required this.bank,
    required this.bankNumber,
    this.passport,
    this.drivingLicense,
  });
}

class RegisterAsAgent extends StatefulWidget {
  const RegisterAsAgent({super.key});

  @override
  State<RegisterAsAgent> createState() => _RegisterAsAgentState();
}

class _RegisterAsAgentState extends State<RegisterAsAgent> {
  late String bank;
  late String bankNumber;

  late RegisterAsAgentItem item = RegisterAsAgentItem(
    bank: "",
    bankNumber: "",
  );

  late bool _isLoading = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register as Agent"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Container(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.account_balance),
                        border: OutlineInputBorder(),
                        labelText: 'Bank Name',
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your bank name';
                        }
                        return null;
                      },
                      onSaved: (String? value) {
                        item.bank = value!;
                      },
                    ),
                  ),
                  SizedBox(height: 20,),
                  Container(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.numbers),
                        border: OutlineInputBorder(),
                        labelText: 'Bank Number',
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your bank number';
                        }
                        return null;
                      },
                      onSaved: (String? value) {
                        item.bankNumber = value!;
                      },
                    ),
                  ),
                  SizedBox(height: 20,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Passport", style: TextStyle(fontWeight: FontWeight.bold),),
                      SizedBox(height: 10,),
                      GestureDetector(
                        onTap: () async {
                          File? image = await getImage(ImageSource.camera);
                          setState(() {
                            item.passport = image;
                          });
                        },
                        child: Container(
                          height: 250,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10)
                          ),
                          child: item.passport == null ? Center(child: Text("No file selected"),) : Image.file(item.passport!),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Driving License", style: TextStyle(fontWeight: FontWeight.bold),),
                      SizedBox(height: 10,),
                      GestureDetector(
                        onTap: () async {
                          File? image = await getImage(ImageSource.camera);
                          setState(() {
                            item.drivingLicense = image;
                          });
                        },
                        child: Container(
                          height: 250,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: item.drivingLicense == null ? Center(child: Text("No file selected"),) : Image.file(item.drivingLicense!),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20,),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading? null : () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();

                          _doSubmit();
                        }
                      },
                      child: const Text('Submit'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ),
    );
  }

  Future<File?> getImage(ImageSource source) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile != null) {
        return File(pickedFile.path);
      }

      return null;
    } catch (e) {
      rethrow;
    }
  }

  _doSubmit() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Get the token
      var refreshToken = await CredentialsManager.refreshToken();

      if(refreshToken == null) {
        if(mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Please login first"),
              )
          );
        }

        return;
      }

      var url = Uri.parse('https://relo.suliluz.name.my/user/agent/verify');

      var request = http.MultipartRequest('POST', url, );

      request.headers['authorization'] = 'Bearer $refreshToken';

      request.fields['bank'] = item.bank;
      request.fields['bank_number'] = item.bankNumber;
      request.files.add(await http.MultipartFile.fromPath('passport', item.passport!.path, contentType: MediaType('image', 'jpeg')));
      request.files.add(await http.MultipartFile.fromPath('driving_license', item.drivingLicense!.path, contentType: MediaType('image', 'jpeg')));

      var response = await request.send();

      print(response.statusCode);

      if(response.statusCode == 200) {
        var reloResponse = ReloResponse.fromJson(jsonDecode(response.stream.toString()));

        print(reloResponse.message);

        if(mounted) {
          if(reloResponse.success) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(reloResponse.message),
                )
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(reloResponse.message),
                )
            );
          }
        }
      } else {
        if(mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Something went wrong"),
              )
          );
        }
      }
    } catch (e) {
      rethrow;
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
