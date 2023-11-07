import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:relo/business_logic/states/navigation_state.dart';

import '../enums/navbar_item.dart';

class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(const NavigationState(navbarItem: NavbarItem.home, index: 0));

  void getNavBarItem(NavbarItem navbarItem) {
    switch(navbarItem) {
      case NavbarItem.home:
        emit(const NavigationState(navbarItem: NavbarItem.home, index: 0));
        break;
      case NavbarItem.wishlists:
        emit(const NavigationState(navbarItem: NavbarItem.wishlists, index: 1));
        break;
      case NavbarItem.purchased:
        emit(const NavigationState(navbarItem: NavbarItem.purchased, index: 2));
        break;
      case NavbarItem.profile:
        emit(const NavigationState(navbarItem: NavbarItem.profile, index: 3));
        break;
      default:
        emit(const NavigationState(navbarItem: NavbarItem.home, index: 0));
        break;
    }
  }
}