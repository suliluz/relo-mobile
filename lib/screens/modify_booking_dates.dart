import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:relo/business_logic/models/travel_available_booking_dates.dart';
import 'package:relo/screens/error_page.dart';
import 'package:relo/screens/listings_page.dart';
import 'package:http/http.dart' as http;
import 'package:relo/screens/loading_page.dart';

import '../business_logic/models/package_information.dart';
import '../business_logic/models/relo_response.dart';
import '../business_logic/utilities/credentials_manager.dart';
import 'login_page.dart';

class ModifyBookingDates extends StatefulWidget {
  const ModifyBookingDates({
    super.key,
    required this.packageId,
  });
  
  final String packageId;

  @override
  State<ModifyBookingDates> createState() => _ModifyBookingDatesState();
}

class _ModifyBookingDatesState extends State<ModifyBookingDates> {
  late PackageInformation _packageInformation = PackageInformation.fake();
  late List<Widget> _bookingDates = [];
  
  bool _isLoading = false;
  bool _isError = false;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
    _load();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modify Booking Dates'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _build(),
      )
    );
  }

  _createBookingDateModal() {
    TravelBookingDates bookingDate = TravelBookingDates(
      bookingDateId: '',
      startingDate: DateTime.now(),
      endingDate: DateTime.now().add(const Duration(days: 3)),
      slotsTaken: 0,
      slotsTotal: 0,
      price: 0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    // TextEditingControllers for the text fields
    TextEditingController startDateController = TextEditingController();
    TextEditingController endDateController = TextEditingController();

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          height: MediaQuery.of(context).size.height * 0.65,
          width: double.infinity,
          child: Column(
            children: [
              ListTile(
                title: const Text("Add Booking Date", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                trailing: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Start date readonly text field, use a date picker
                    TextField(
                      controller: startDateController,
                      onTap: () async {
                        DateTime? dateTime = await _showDatePicker();

                        if (dateTime != null) {
                          bookingDate.startingDate = dateTime;

                          // Use travel package information to set days after start date
                          bookingDate.endingDate = dateTime.add(Duration(days: _packageInformation.daysCount));

                          setState(() {
                            // Format as January 1, 2021 for both start and end date
                            startDateController.text = bookingDate.startingDate.toString().split(' ')[0];
                            endDateController.text = bookingDate.startingDate.toString().split(' ')[0];
                          });
                        }
                      },
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: 'Start Date',
                        icon: Icon(Icons.date_range),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // End date readonly text field, use a date picker
                    TextField(
                      controller: endDateController,
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: 'End Date',
                        icon: Icon(Icons.date_range),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      onChanged: (value) {
                        bookingDate.slotsTotal = int.parse(value);
                      },
                      decoration: const InputDecoration(
                        labelText: 'Max Bookings',
                        icon: Icon(Icons.people),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      onChanged: (value) {
                        bookingDate.price = int.parse(value);
                      },
                      decoration: const InputDecoration(
                        labelText: 'Price',
                        icon: Icon(Icons.attach_money),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        // Add booking date to the list
                        var save = _addBookingDate(bookingDate);

                        if(save != null) {
                          _load();
                        }
                      },
                      child: const Text('Add Booking Date'),
                    )
                  ],
                ),
              )
            ],
          )
        );
      }
    );
  }

  _editBookingDateModal(TravelBookingDates bookingDate) {
   // TextEditingControllers for the text fields
    TextEditingController startDateController = TextEditingController();
    TextEditingController endDateController = TextEditingController();
    TextEditingController maxBookingsController = TextEditingController();
    TextEditingController priceController = TextEditingController();

    // Set the text field values
    startDateController.text = bookingDate.startingDate.toString().split(' ')[0];
    endDateController.text = bookingDate.endingDate.toString().split(' ')[0];
    maxBookingsController.text = bookingDate.slotsTotal.toString();
    priceController.text = bookingDate.price.toString();


    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return Container(
              padding: const EdgeInsets.all(16),
              height: MediaQuery.of(context).size.height * 0.65,
              width: double.infinity,
              child: Column(
                children: [
                  ListTile(
                    title: const Text("Edit Booking Date", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    trailing: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Start date readonly text field, use a date picker
                        TextField(
                          controller: startDateController,
                          onTap: () async {
                            DateTime? dateTime = await _showDatePicker(
                              startDate: bookingDate.startingDate,
                            );

                            if (dateTime != null) {
                              bookingDate.startingDate = dateTime;

                              // Use travel package information to set days after start date
                              bookingDate.endingDate = dateTime.add(Duration(days: _packageInformation.daysCount));

                              setState(() {
                                // Format as January 1, 2021 for both start and end date
                                startDateController.text = bookingDate.startingDate.toString().split(' ')[0];
                                endDateController.text = bookingDate.endingDate.toString().split(' ')[0];
                              });
                            }
                          },
                          readOnly: true,
                          decoration: const InputDecoration(
                            labelText: 'Start Date',
                            icon: Icon(Icons.date_range),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // End date readonly text field, use a date picker
                        TextField(
                          controller: endDateController,
                          readOnly: true,
                          decoration: const InputDecoration(
                            labelText: 'End Date',
                            icon: Icon(Icons.date_range),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: maxBookingsController,
                          onChanged: (value) {
                            bookingDate.slotsTotal = int.parse(value);
                          },
                          decoration: const InputDecoration(
                            labelText: 'Max Bookings',
                            icon: Icon(Icons.people),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: priceController,
                          onChanged: (value) {
                            bookingDate.price = int.parse(value);
                          },
                          decoration: const InputDecoration(
                            labelText: 'Price',
                            icon: Icon(Icons.attach_money),
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            // Edit booking date to the list
                            var save = _editBookingDate(bookingDate);

                            if(save != null) {
                              _load();
                            }
                          },
                          child: const Text('Edit Booking Date'),
                        )
                      ],
                    ),
                  )
                ],
              )
          );
        }
    );
  }

  Future<DateTime?> _showDatePicker({DateTime? startDate}) async {
    var picker = await showDatePicker(
      context: context,
      initialDate: startDate ?? DateTime.now(),
      firstDate: startDate?? DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    // Get the date selected
    return picker;
  }
  
  _load() async {
    try {
      setState(() {
        _isLoading = true;
      });
      
      await _getPackageInfo();
      
      _isError = false;
    } catch (e) {
      _isError = true;
      rethrow;
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  Widget _build() {
    if(_isLoading) {
      return const LoadingPage();
    } else if (!_isLoading && _isError) {
      return const ErrorPage();
    } else {
      return Column(
        children: [
          Text(_packageInformation.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold,),),
          const SizedBox(height: 16),
          // Add booking dates button with icon to the right
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              onPressed: () {
                _createBookingDateModal();
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Booking Date'),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: _bookingDates,
            ),
          ),
          // Wide button to save the booking dates
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ListingsPage()));
              },
              child: const Text('Done'),
            ),
          )
        ],
      );
    }
  }

  _getPackageInfo() async {
    try {
      var url = Uri.parse('https://relo.suliluz.name.my/travel/package/${widget.packageId}');

      print(url.toString());

      final response = await http.get(url);

      if(response.statusCode == 200) {
        var reloResponse = ReloResponse.fromJson(jsonDecode(response.body));

        if(reloResponse.success) {
          _packageInformation = PackageInformation.fromJson(reloResponse.message);
          
          // Build booking dates
          _bookingDates = _packageInformation.bookingDates.asMap().entries.map((entry) {
            int index = entry.key;
            TravelBookingDates bookingDate = entry.value;

            return Card(
                child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          title: Text("${bookingDate.startingDate} - ${bookingDate.endingDate}"),
                          // 20000 comma format
                          subtitle: Text("\$${bookingDate.price}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                          // booking count over max booking count with icon
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.person, color: Theme.of(context).primaryColor, size: 24),
                              const SizedBox(width: 4),
                              Text('${bookingDate.slotsTaken}/${bookingDate.slotsTotal}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              // Edit booking dates button
                              ElevatedButton.icon(
                                onPressed: () {
                                  _editBookingDateModal(_packageInformation.bookingDates[index]);
                                },
                                icon: const Icon(Icons.edit),
                                label: const Text('Edit'),
                              ),
                              // Customers list button
                              ElevatedButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.people),
                                label: const Text('Customers'),
                              ),
                              ElevatedButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.delete, color: Colors.red),
                                label: const Text('Delete', style: TextStyle(color: Colors.red)),
                              ),

                            ],
                          ),
                        ),
                      ],
                    )
                )
            );
          }).toList();
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
  
  _addBookingDate(TravelBookingDates travelBookingDate) async {
    try {
      // Get refresh token, push to login if null
      String? refreshToken = await CredentialsManager.refreshToken();

      if(refreshToken == null) {
        if(mounted) Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
        return;
      }

      var url = Uri.parse('https://relo.suliluz.name.my/travel/package/add-booking-date');

      final response = await http.post(url, body: {
        'short_code': widget.packageId,
        'start_date': travelBookingDate.startingDate.toIso8601String(),
        'end_date': travelBookingDate.endingDate.toIso8601String(),
        'max_booking_count': travelBookingDate.slotsTotal.toString(),
        'price': travelBookingDate.price.toString(),
      }, headers: {'Authorization': 'Bearer $refreshToken', 'Content-Type': 'application/json'});

      if(response.statusCode == 200) {
        var reloResponse = ReloResponse.fromJson(jsonDecode(response.body));

        if(reloResponse.success) {
          // Add booking date to the list
          if(mounted) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Booking date added successfully')));
            Navigator.pop(context, true);
          }
        } else {
          if(mounted) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(reloResponse.message)));
          }
        }
      } else {
        if (kDebugMode) {
          print('Request failed with status: ${response.statusCode}.');
        }

        if(mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('An error occurred')));
        }
      }

      return true;
    } catch (e) {
      print(e);

      rethrow;
    }
  }

  _editBookingDate(TravelBookingDates travelBookingDate) async {
    try {
      // Get refresh token, push to login if null
      String? refreshToken = await CredentialsManager.refreshToken();

      if(refreshToken == null) {
        if(mounted) Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
        return;
      }

      var url = Uri.parse('https://relo.suliluz.name.my/travel/package/update-booking-date');

      final response = await http.post(url, body: {
        'short_code': widget.packageId,
        'booking_date_id': travelBookingDate.bookingDateId,
        'start_date': travelBookingDate.startingDate.toIso8601String(),
        'end_date': travelBookingDate.endingDate.toIso8601String(),
        'max_booking_count': travelBookingDate.slotsTotal.toString(),
        'price': travelBookingDate.price.toString(),
      }, headers: {'Authorization': 'Bearer $refreshToken', 'Content-Type': 'application/json'});

      if(response.statusCode == 200) {
        var reloResponse = ReloResponse.fromJson(jsonDecode(response.body));

        if(reloResponse.success) {
          // Add booking date to the list
          if(mounted) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Booking date added successfully')));
            Navigator.pop(context, true);
          }
        } else {
          if(mounted) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(reloResponse.message)));
          }
        }
      } else {
        if (kDebugMode) {
          print('Request failed with status: ${response.statusCode}.');
        }

        if(mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('An error occurred')));
        }
      }

      return true;
    } catch (e) {
      print(e);

      rethrow;
    }
  }
}
