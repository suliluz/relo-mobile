// A main page with subpages
// 1. Home
// 2. Search
// 3. Wishlists
// 4. Purchased Packages
// 5. Profile and Settings

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart' as cupertino;
import 'package:relo/business_logic/blocs/navigation_cubit.dart';
import 'package:relo/business_logic/states/navigation_state.dart';
import 'package:relo/business_logic/utilities/credentials_manager.dart';
import 'package:relo/screens/call_to_sign_in.dart';
import 'package:relo/screens/home_page.dart';
import 'package:relo/screens/profile_page.dart';
import 'package:http/http.dart' as http;
import 'package:relo/screens/purchased_page.dart';
import 'package:relo/screens/wishlist_page.dart';
import '../business_logic/enums/navbar_item.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late bool _loggedIn = false;

  final List<Widget> _pages = <Widget>[
    const HomePage(),
    const WishlistPage(),
    const PurchasedPage(),
    const ProfilePage(),
  ];

  List<Widget> _items = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _checkLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <BlocProvider>[
        BlocProvider<NavigationCubit>(create: (BuildContext context) => NavigationCubit()),
      ],
      child: BlocConsumer<NavigationCubit, NavigationState>(
        builder: (context, state) {
          return Scaffold(
            // Bottom Navigation Bar
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Theme.of(context).primaryColor,
              unselectedItemColor: Colors.black87,
              elevation: 1,
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(cupertino.CupertinoIcons.home),
                    label: 'Home',
                ),
                BottomNavigationBarItem(
                    icon: Icon(cupertino.CupertinoIcons.heart),
                    label: 'Wishlists',
                ),
                BottomNavigationBarItem(
                    icon: Icon(cupertino.CupertinoIcons.airplane),
                    label: 'Purchased',
                ),
                BottomNavigationBarItem(
                    icon: Icon(cupertino.CupertinoIcons.person),
                    label: 'Profile',
                ),
              ],
              currentIndex: state.index,
              onTap: (index) {
                switch (index) {
                  case 0:
                    context
                        .read<NavigationCubit>()
                        .getNavBarItem(NavbarItem.home);
                    break;
                  case 1:
                    context
                        .read<NavigationCubit>()
                        .getNavBarItem(NavbarItem.wishlists);
                    break;
                  case 2:
                    context
                        .read<NavigationCubit>()
                        .getNavBarItem(NavbarItem.purchased);
                    break;
                  case 3:
                    context
                        .read<NavigationCubit>()
                        .getNavBarItem(NavbarItem.profile);
                    break;
                }
              },
            ),
            body: _pages[state.index],
          );
        },
        listener: (context, state) {
          switch (state.navbarItem) {
            case NavbarItem.home:
              // Navigator.pushNamed(context, '/home');
              break;
            case NavbarItem.wishlists:
              // Navigator.pushNamed(context, '/wishlists');
              break;
            case NavbarItem.purchased:
              // Navigator.pushNamed(context, '/purchased');
              break;
            case NavbarItem.profile:
              // Navigator.pushNamed(context, '/profile');
              break;
          }
        },
      ),
    );
  }
  
  _load(NavbarItem navbarItem) async {
    var refreshToken = await CredentialsManager.refreshToken();

    var response;

    if((navbarItem == NavbarItem.wishlists || navbarItem == NavbarItem.purchased) && refreshToken == null) {
      return null;
    }

    switch(navbarItem) {
      case NavbarItem.wishlists:
        response = await http.get(Uri.parse("https://relo.suliluz.name.my/travel/wishlists"), headers: {
          'Authorization': 'Bearer $refreshToken'
        });
        break;
      case NavbarItem.purchased:
        response = await http.get(Uri.parse("https://relo.suliluz.name.my/travel/purchased"), headers: {
          'Authorization': 'Bearer $refreshToken'
        });
      default:
        return;
    }
  }

  _checkLoggedIn() async {
    var refreshToken = await CredentialsManager.refreshToken();

    if(refreshToken != null) {
      _loggedIn = true;
    }
  }
}
