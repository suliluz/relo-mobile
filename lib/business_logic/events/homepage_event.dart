import 'package:equatable/equatable.dart';
import 'package:relo/business_logic/enums/season_item.dart';

abstract class HomepageEvent extends Equatable {
  const HomepageEvent();

  @override
  List<Object> get props => [];
}

class HomepageRefresh extends HomepageEvent {
  final SeasonItem seasonItem;

  const HomepageRefresh({required this.seasonItem});

  @override
  List<Object> get props => [seasonItem];
}

class HomepageLoad extends HomepageEvent {
  final SeasonItem seasonItem;

  const HomepageLoad({required this.seasonItem});

  @override
  List<Object> get props => [seasonItem];
}

class HomepageLoadMore extends HomepageEvent {
  final SeasonItem seasonItem;
  final int page;

  const HomepageLoadMore({required this.seasonItem, required this.page});

  @override
  List<Object> get props => [seasonItem, page];
}