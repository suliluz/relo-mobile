import 'package:equatable/equatable.dart';

import '../enums/season_item.dart';
import '../models/travel_package.dart';

abstract class HomepageState extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class HomepageInitial extends HomepageState {
  final SeasonItem seasonItem;

  HomepageInitial({required this.seasonItem});

  @override
  // TODO: implement props
  List<Object?> get props => [seasonItem];
}

class HomepageLoading extends HomepageState {
  HomepageLoading();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class HomepageLoaded extends HomepageState {
  final List<TravelPackage> packages;

  HomepageLoaded({required this.packages});

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class HomepageError extends HomepageState {
  final String message;

  HomepageError(this.message);

  @override
  // TODO: implement props
  List<Object?> get props => [];
}