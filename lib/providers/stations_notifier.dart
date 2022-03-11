import 'package:dartz/dartz.dart';
import 'package:easytrain/api/trenord.dart';
import 'package:easytrain/pages/select_station/select_station_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StationsNotifier extends StateNotifier<StationsState> {
  StationsNotifier() : super(StationsState.initial());

  void init(StationType type) async {
    print("STATION NOTIFIER INIT");
    state = StationsState("", none(), true, "", type);

    var either = await fetchStations("", type);
    state = either.fold(
      (l) => state.copyWith(
        isLoading: false,
        errorMessage: l,
      ),
      (r) => state.copyWith(
        stations: some(r),
        isLoading: false,
      ),
    );
  }

  void updateQuery(String newQuery) async {
    if (newQuery == state.query) return;
    state = state.copyWith(query: newQuery);
    updateStations();
  }

  void updateStations() async {
    state = state.copyWith(isLoading: true, errorMessage: "");
    var either = await fetchStations(state.query, state.type);
    state = either.fold(
      (l) => state.copyWith(
        errorMessage: l,
        isLoading: false,
      ),
      (r) => state.copyWith(
        stations: some(r),
        isLoading: false,
      ),
    );
  }

  void reset() {
    state = StationsState.initial();
  }
}

class StationsState {
  final String query;
  final Option<List<String>> stations;
  final StationType type;
  final bool isLoading;
  final String errorMessage;

  StationsState(
      this.query, this.stations, this.isLoading, this.errorMessage, this.type);

  factory StationsState.initial() =>
      StationsState("", none(), false, "", StationType.departure);

  StationsState copyWith({
    String? query,
    Option<List<String>>? stations,
    bool? isLoading,
    String? errorMessage,
    StationType? type,
  }) {
    return StationsState(
      query ?? this.query,
      stations ?? this.stations,
      isLoading ?? this.isLoading,
      errorMessage ?? this.errorMessage,
      type ?? this.type,
    );
  }
}
