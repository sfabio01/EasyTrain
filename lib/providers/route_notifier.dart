import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RouteNotifier extends StateNotifier<RouteState> {
  RouteNotifier() : super(RouteState.initial());

  void init() async {
    var prefs = await SharedPreferences.getInstance();
    final dep = prefs.getString("departure");
    final Option<String> departure = dep != null ? some(dep) : none();
    final des = prefs.getString("destination");
    final Option<String> destination = des != null ? some(des) : none();
    state = RouteState(departure, destination);
  }

  void changeDeparture(String newDeparture) {
    state = state.copyWith(departure: some(newDeparture));
    updatePreferences("departure", newDeparture);
  }

  void changeDestination(String newDestination) {
    state = state.copyWith(destination: some(newDestination));
    updatePreferences("destination", newDestination);
  }

  void updatePreferences(String key, String value) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  void reverseDirection() {
    state = RouteState(state.destination, state.departure);
    updatePreferences("departure", state.departure.getOrElse(() => ""));
    updatePreferences("destination", state.destination.getOrElse(() => ""));
  }
}

class RouteState {
  final Option<String> departure;
  final Option<String> destination;

  RouteState(this.departure, this.destination);

  factory RouteState.initial() => RouteState(none(), none());

  RouteState copyWith({
    Option<String>? departure,
    Option<String>? destination,
  }) {
    return RouteState(
      departure ?? this.departure,
      destination ?? this.destination,
    );
  }
}
