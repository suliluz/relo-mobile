import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../widgets/horizontal_scrollable_selectors.dart';
import '../widgets/inner_label_text_field.dart';
import '../widgets/rectangle_radio_selector.dart';

class DetailedTravelSearch extends StatefulWidget {
  const DetailedTravelSearch({super.key});

  @override
  State<DetailedTravelSearch> createState() => _DetailedTravelSearchState();
}

class _DetailedTravelSearchState extends State<DetailedTravelSearch> {
  RangeValues _ageRange = const RangeValues(18, 100);
  RangeValues _priceRange = const RangeValues(1, 100);

  final TextEditingController _ageRangeMinController = TextEditingController();
  final TextEditingController _ageRangeMaxController = TextEditingController();

  final TextEditingController _priceRangeMinController = TextEditingController();
  final TextEditingController _priceRangeMaxController = TextEditingController();

  final TextEditingController _calendarRangeMinController = TextEditingController();
  final TextEditingController _calendarRangeMaxController = TextEditingController();

  DateTimeRange? _selectedDateRange;

  String season = "any";
  String gender = "male";
  String packageType = "all";
  String tourType = "all";

  String? country = null;
  String? state = null;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _priceRangeMinController.text = 1.toString();
    _priceRangeMaxController.text = 100.toString();

    _ageRangeMinController.text = 18.toString();
    _ageRangeMaxController.text = 100.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Detailed Travel Search"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Price Range", style: TextStyle(fontWeight: FontWeight.bold),),
              SizedBox(height: 10,),
              Text("The average nightly price is \$93", style: TextStyle(color: Colors.black54),),
              SizedBox(height: 10,),
              RangeSlider(
                values: _priceRange,
                max: 100,
                divisions: 100,
                labels: RangeLabels(
                  _priceRange.start.round().toString(),
                  _priceRange.end.round().toString(),
                ),
                onChanged: (RangeValues values) {
                  setState(() {
                    _priceRange = values;
                    _priceRangeMinController.text = _priceRange.start.round().toString();
                    _priceRangeMaxController.text = _priceRange.end.round().toString();
                  });
                },
              ),
              SizedBox(height: 10,),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: InnerLabelTextField(
                      label: "Minimum",
                      textEditingController: _priceRangeMinController,
                      onSubmitted: (value) {
                        setState(() {
                          if(int.parse(value) > 1 && int.parse(value) < 100) {
                            _priceRange = RangeValues(double.parse(value), _priceRange.end);
                          } else {
                            _priceRange = RangeValues(1, _priceRange.end);
                            _priceRangeMinController.text = _priceRange.start.round().toString();
                          }
                        });
                      },
                    ),
                  ),
                  Expanded(child: Center(child: Text("—"))),
                  Expanded(
                    flex: 2,
                    child: InnerLabelTextField(
                      label: "Maximum",
                      textEditingController: _priceRangeMaxController,
                      onSubmitted: (value) {
                        setState(() {
                          if(int.parse(value) > 1 && int.parse(value) < 100) {
                            _priceRange = RangeValues(_priceRange.start, double.parse(value));
                          } else {
                            _priceRange = RangeValues(_priceRange.start, 100);
                            _priceRangeMaxController.text = _priceRange.end.round().toString();
                          }
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10,),
              Divider(thickness: 1,),
              SizedBox(height: 10,),
              Text("Gender", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
              SizedBox(height: 10,),
              RectangleRadioSelector(
                  items: [
                    RectangleRadioSelectorItem(icon: const Icon(Icons.male, color: Colors.blue,), label: "Male", value: "male"),
                    RectangleRadioSelectorItem(icon: const Icon(Icons.female, color: Colors.pink,), label: "Female", value: "female"),
                  ],
                  onSelected: (value) {},
                  value: gender,
                  selectedColor: Colors.black
              ),
              SizedBox(height: 10,),
              Divider(thickness: 1,),
              SizedBox(height: 10,),
              Text("Age Range", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
              SizedBox(height: 10,),
              RangeSlider(
                values: _ageRange,
                max: 100,
                min: 18,
                divisions: 100,
                labels: RangeLabels(
                  _ageRange.start.round().toString(),
                  _ageRange.end.round().toString(),
                ),
                onChanged: (RangeValues values) {
                  setState(() {
                    _ageRange = values;
                    _ageRangeMinController.text = _ageRange.start.round().toString();
                    _ageRangeMaxController.text = _ageRange.end.round().toString();
                  });
                },
              ),
              SizedBox(height: 10,),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: InnerLabelTextField(
                      label: "Minimum",
                      textEditingController: _ageRangeMinController,
                      onSubmitted: (value) {
                        setState(() {
                          if(int.parse(value) > 18 && int.parse(value) < 100) {
                            _ageRange = RangeValues(double.parse(value), _ageRange.end);
                          } else {
                            _ageRange = RangeValues(18, _ageRange.end);
                            _ageRangeMinController.text = _ageRange.start.round().toString();
                          }
                        });
                      },
                    ),
                  ),
                  Expanded(child: Center(child: Text("—"))),
                  Expanded(
                    flex: 2,
                    child: InnerLabelTextField(
                      label: "Maximum",
                      textEditingController: _ageRangeMaxController,
                      onSubmitted: (value) {
                        setState(() {
                          if(int.parse(value) > 18 && int.parse(value) < 100) {
                            _ageRange = RangeValues(_ageRange.start, double.parse(value));
                          } else {
                            _ageRange = RangeValues(_ageRange.start, 100);
                            _ageRangeMaxController.text = _ageRange.end.round().toString();
                          }
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10,),
              Divider(thickness: 1,),
              SizedBox(height: 10,),
              Text("Dates", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
              SizedBox(height: 10,),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: GestureDetector(
                      onTap: () async {
                        DateTimeRange? result = await showDateRangePicker(
                          context: context,
                          firstDate: DateTime.now(), // the earliest allowable
                          lastDate: DateTime(2024, 12, 31), // the latest allowable
                          currentDate: DateTime.now(),
                          saveText: 'Set',
                        );

                        if (result != null) {
                          setState(() {
                            _selectedDateRange = result;

                            // Rebuild the UI
                            _calendarRangeMinController.text = DateFormat.yMMMd().format(result.start);
                            _calendarRangeMaxController.text = DateFormat.yMMMd().format(result.end);
                          });
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black54),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Start Date", style: TextStyle(fontSize: 12, color: Colors.black54),),
                            IgnorePointer(
                              child: TextField(
                                readOnly: true,
                                keyboardType: TextInputType.number,
                                controller: _calendarRangeMinController,
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    border: InputBorder.none
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(child: Center(child: Text("—"))),
                  Expanded(
                    flex: 2,
                    child: GestureDetector(
                      onTap: () async {
                        DateTimeRange? result = await showDateRangePicker(
                          context: context,
                          firstDate: DateTime.now(), // the earliest allowable
                          lastDate: DateTime(2024, 12, 31), // the latest allowable
                          currentDate: DateTime.now(),
                          saveText: 'Set',
                        );

                        if (result != null) {
                          setState(() {
                            _selectedDateRange = result;

                            // Rebuild the UI
                            _calendarRangeMinController.text = DateFormat.yMMMd().format(result.start);
                            _calendarRangeMaxController.text = DateFormat.yMMMd().format(result.end);
                          });
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black54),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("End Date", style: TextStyle(fontSize: 12, color: Colors.black54),),
                            IgnorePointer(
                              child: TextField(
                                readOnly: true,
                                keyboardType: TextInputType.number,
                                controller: _calendarRangeMaxController,
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    border: InputBorder.none
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10,),
              Divider(thickness: 1,),
              SizedBox(height: 10,),
              Text("Seasons", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
              SizedBox(height: 20,),
              RectangleRadioSelector(
                  items: [
                    RectangleRadioSelectorItem(icon: const Icon(Icons.public), label: "Any", value: "any"),
                    RectangleRadioSelectorItem(icon: const Icon(Icons.local_florist), label: "Spring", value: "spring"),
                    RectangleRadioSelectorItem(icon: const Icon(Icons.sunny), label: "Summer", value: "summer"),
                    RectangleRadioSelectorItem(icon: const Icon(Icons.eco), label: "Autumn", value: "autumn"),
                    RectangleRadioSelectorItem(icon: const Icon(Icons.ac_unit), label: "Winter", value: "winter"),
                  ],
                  onSelected: (value) {},
                  value: season,
                  selectedColor: Colors.black
              ),
              SizedBox(height: 10,),
              Divider(thickness: 1,),
              SizedBox(height: 10,),
              InnerLabelTextField(
                label: "Number of travel days",
              ),
              SizedBox(height: 10,),
              Divider(thickness: 1,),
              SizedBox(height: 10,),
              Text("Package Type", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
              SizedBox(height: 10,),
              HorizontalScrollableSelectors(
                  items: [
                    HorizontalScrollableSelectorsItem(label: "All", value: "all"),
                    HorizontalScrollableSelectorsItem(label: "Customizable", value: "customizable"),
                    HorizontalScrollableSelectorsItem(label: "Fixed", value: "fixed"),
                  ],
                  value: tourType,
                  onChanged: (value) {},
                  activeColor: Theme.of(context).primaryColor
              ),
              SizedBox(height: 10,),
              Divider(thickness: 1,),
              SizedBox(height: 10,),
              InnerLabelTextField(
                label: "Number of people in the trip",
              ),
              SizedBox(height: 10,),
              Divider(thickness: 1,),
              SizedBox(height: 10,),
              Text("Private or Group Tour", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
              SizedBox(height: 10,),
              HorizontalScrollableSelectors(
                  items: [
                    HorizontalScrollableSelectorsItem(label: "All", value: "all"),
                    HorizontalScrollableSelectorsItem(label: "Private", value: "private"),
                    HorizontalScrollableSelectorsItem(label: "Group", value: "group"),
                  ],
                  value: packageType,
                  onChanged: (value) {},
                  activeColor: Theme.of(context).primaryColor
              ),
              SizedBox(height: 10,),
              Divider(thickness: 1,),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: DropdownButton<String>(
                      hint: Text("Country"),
                      value: country,
                      isExpanded: true,
                      icon: const Icon(Icons.arrow_downward),
                      elevation: 16,
                      style: const TextStyle(color: Colors.deepPurple),
                      underline: Container(
                        height: 2,
                        color: Colors.deepPurpleAccent,
                      ),
                      onChanged: (String? value) {
                        // This is called when the user selects an item.
                        setState(() {
                          country = value!;
                        });
                      },
                      items: ["Malaysia", "Thailand", "Vietnam"].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(width: 10,),
                  Expanded(
                    child: DropdownButton<String>(
                      hint: Text("State"),
                      value: state,
                      isExpanded: true,
                      icon: const Icon(Icons.arrow_downward),
                      elevation: 16,
                      style: const TextStyle(color: Colors.deepPurple),
                      underline: Container(
                        height: 2,
                        color: Colors.deepPurpleAccent,
                      ),
                      onChanged: (String? value) {
                        // This is called when the user selects an item.
                        setState(() {
                          state = value!;
                        });
                      },
                      items: ["Sarawak", "Bangkok", "Vietnam City"].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  )
                ],
              )
            ],
          ),
        )
      ),
    );
  }
}
