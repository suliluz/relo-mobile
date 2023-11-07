import 'package:equatable/equatable.dart';
import 'package:relo/business_logic/enums/navbar_item.dart';

class NavigationState extends Equatable {
  final int index;
  final NavbarItem navbarItem;
  
  const NavigationState({required this.index, required this.navbarItem});

  @override
  List<Object?> get props => [index, navbarItem];
}