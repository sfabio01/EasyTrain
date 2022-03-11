import 'package:easytrain/providers/route_notifier.dart';
import 'package:easytrain/providers/stations_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'calendar_notifier.dart';
import 'solutions_notifier.dart';

final routeProvider = StateNotifierProvider<RouteNotifier, RouteState>(
    (ref) => RouteNotifier()..init());

final calendarProvider = StateNotifierProvider<CalendarNotifier, DateTime>(
    (ref) => CalendarNotifier());

final solutionsProvider =
    StateNotifierProvider<SolutionsNotifier, SolutionsState>(((ref) =>
        SolutionsNotifier(ref.watch(calendarProvider), ref.watch(routeProvider))
          ..getSolutions()));

final stationsProvider = StateNotifierProvider<StationsNotifier, StationsState>(
    (ref) => StationsNotifier());
