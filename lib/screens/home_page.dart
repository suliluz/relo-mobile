import 'dart:convert';
import 'package:relo/business_logic/models/relo_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart' as cupertino;
import 'package:relo/screens/detailed_travel_search.dart';
import 'package:relo/screens/error_page.dart';
import 'package:relo/screens/loading_page.dart';
import 'package:http/http.dart' as http;

import '../business_logic/enums/season_item.dart';
import '../widgets/package_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final scrollController = ScrollController();

  late SeasonItem season;
  late int currentPage;

  bool _isLoading = false;
  bool _isError = false;

  late List<Widget> items;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    items = [];

    scrollController.addListener(() {
      // Detect pull down to refresh
      if (scrollController.position.pixels ==
          scrollController.position.minScrollExtent) {
        _reset();
        _getResult();
      }

      // Detect end of scroll
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        currentPage++;

        _getResult();
      }
    });

    season = SeasonItem.all;
    currentPage = 1;

    _getResult();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(175),
          child: SafeArea(
            child: Column(
              children: <Widget>[
                // Call to action search button bar with rounded corners, where search icon is on the left and text is on the right
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return const DetailedTravelSearch();
                    }));
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Icon(Icons.search),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('What package are you looking for?'),
                            Text('Let\'s find it!'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TabBar(
                  isScrollable: true,
                  tabs: const [
                    Tab(
                      icon: Icon(cupertino.CupertinoIcons.globe),
                      text: 'All',
                    ),
                    Tab(
                      icon: Icon(cupertino.CupertinoIcons.tree),
                      text: 'Spring',
                    ),
                    Tab(
                      icon: Icon(cupertino.CupertinoIcons.sun_max_fill),
                      text: 'Summer',
                    ),
                    Tab(
                      icon: Icon(cupertino.CupertinoIcons.wind),
                      text: 'Autumn',
                    ),
                    Tab(
                      icon: Icon(cupertino.CupertinoIcons.snow),
                      text: 'Winter',
                    ),
                  ],
                  onTap: (value) {
                    switch (value) {
                      case 1:
                        season = SeasonItem.spring;
                        break;
                      case 2:
                        season = SeasonItem.summer;
                        break;
                      case 3:
                        season = SeasonItem.autumn;
                        break;
                      case 4:
                        season = SeasonItem.winter;
                        break;
                      default:
                        season = SeasonItem.all;
                        break;
                    }

                    _reset();
                    _getResult();
                  },
                ),
              ],
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: _load(),
        ),
      ),
    );
  }

  _getResult() async {
    setState(() {
      _isLoading = true;
    });

    try {
      Uri uri = Uri.parse("https://relo.suliluz.name.my/travel/home?season=${season.name}&page=$currentPage");

      // Make API call
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        var reloResponse = ReloResponse.fromJson(jsonDecode(response.body));

        if (reloResponse.success) {
          // Process response body
          List<Widget> newItems = [];

          for (var item in reloResponse.message) {
            newItems.add(PackageCard(
                packageId: item["short_code"],
                state: item["state"],
                country: item["country"],
                days: item["days"].length,
                price: item["price"],
                rating: item["rating"],
                images: item["media"],
                season: item["season"],
                isCustomizable: item["is_customizable"],
                agentId: item["agent_id"]));
          }

          setState(() {
            print(newItems);

            items.addAll(newItems);
          });
        } else {
          return;
        }
      } else {
        _isError = true;
        return;
      }
    } catch (e) {
      return;
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _load() {
    if (_isLoading) {
      return const LoadingPage();
    } else if (!_isError && items.isNotEmpty) {
      return ListView.builder(
        controller: scrollController,
        itemCount: items.length,
        itemBuilder: (context, index) {
          return items[index];
        },
      );
    } else {
      return const ErrorPage();
    }
  }

  _reset() {
    _isError = false;
    items = [];
    currentPage = 1;
  }
}
