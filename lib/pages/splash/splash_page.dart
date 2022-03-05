import 'package:easytrain/pages/favorite_route/favorite_route_page.dart';
import 'package:easytrain/pages/select_station/select_station_page.dart';
import 'package:easytrain/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashPage extends ConsumerWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final route = ref.watch(routeProvider);
    if (route.departure.isNone()) {
      return const SelectStationPage(StationType.departure);
    }
    if (route.destination.isNone()) {
      return const SelectStationPage(StationType.destination);
    }
    return const FavoriteRoutePage();
  }
}
