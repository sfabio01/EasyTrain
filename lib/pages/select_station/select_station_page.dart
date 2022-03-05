import 'package:easytrain/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum StationType {
  departure,
  destination,
}

class SelectStationPage extends ConsumerWidget {
  final StationType stationType;

  const SelectStationPage(this.stationType, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              if (stationType == StationType.departure) {
                ref.read(routeProvider.notifier).changeDeparture("TREVIGLIO");
              }
              if (stationType == StationType.destination) {
                ref
                    .read(routeProvider.notifier)
                    .changeDestination("MILANO LAMBRATE");
              }
            },
            child: Text("SELEZIONA STAZIONE " + stationType.name)),
      ),
    );
  }
}
