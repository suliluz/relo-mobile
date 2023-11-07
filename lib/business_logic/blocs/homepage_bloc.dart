import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:relo/business_logic/models/travel_package.dart';
import 'package:relo/business_logic/states/homepage_state.dart';

import '../enums/season_item.dart';
import '../events/homepage_event.dart';
import '../models/relo_response.dart';
import '../providers/travel_service.dart';

class HomepageBloc extends Bloc<HomepageEvent, HomepageState> {
  HomepageBloc() : super(HomepageInitial(seasonItem: SeasonItem.all)) {
    on<HomepageLoad>(_loadHomepage);
    on<HomepageRefresh>(_refreshHomepage);
    on<HomepageLoadMore>(_loadMoreHomepage);
  }

  _loadHomepage(HomepageLoad event, Emitter<HomepageState> emit) async {
    emit(HomepageLoading());

    try {
      ReloResponse? response = await TravelService.getPackages(season: event.seasonItem);

      if(response!.success) {
        emit(HomepageLoaded(packages: response.message.map<TravelPackage>((e) => TravelPackage.fromJson(e)).toList()));
      } else {
        emit(HomepageError(response.message));
      }
    } catch (e) {
      emit(HomepageError(e.toString()));
    }
  }

  _refreshHomepage(HomepageRefresh event, Emitter<HomepageState> emit) async {
    emit(HomepageLoading());

    try {
      ReloResponse? response = await TravelService.getPackages(season: event.seasonItem);

      if(response!.success) {
        emit(HomepageLoaded(packages: response.message.map<TravelPackage>((e) => TravelPackage.fromJson(e)).toList()));
      } else {
        emit(HomepageError(response.message));
      }
    } catch (e) {
      emit(HomepageError(e.toString()));
    }
  }

  _loadMoreHomepage(HomepageLoadMore event, Emitter<HomepageState> emit) async {
    emit(HomepageLoading());

    try {
      ReloResponse? response = await TravelService.getPackages(season: event.seasonItem, page: event.page);

      if(response!.success) {
        emit(HomepageLoaded(packages: response.message.map<TravelPackage>((e) => TravelPackage.fromJson(e)).toList()));
      } else {
        emit(HomepageError(response.message));
      }
    } catch (e) {
      emit(HomepageError(e.toString()));
    }
  }
}