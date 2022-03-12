import 'package:easytrain/colors.dart';
import 'package:easytrain/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const MyAppBar({Key? key})
      : preferredSize =
            const Size.fromHeight(kToolbarHeight + kTextTabBarHeight),
        super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final route = ref.watch(routeProvider);
    return AppBar(
      backgroundColor: darkBlue,
      elevation: 6.0,
      title: const Text("EasyTrain"),
      actions: [
        IconButton(
          onPressed: () {
            ref.read(routeProvider.notifier).reverseDirection();
          },
          icon: const Icon(Icons.swap_horiz_rounded),
          tooltip: "INVERTI DIREZIONE",
        ),
        IconButton(
          onPressed: () {
            ref.read(routeProvider.notifier).reset();
          },
          icon: const Icon(Icons.edit_rounded),
          tooltip: "CAMBIA TRATTA",
        ),
        IconButton(
          onPressed: () {
            ref.read(calendarProvider.notifier).changeDay(DateTime.now());
          },
          icon: const Icon(Icons.today_outlined),
          tooltip: "ADESSO",
        ),
      ],
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24.0))),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(48.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    "${route.departure.getOrElse(() => "")} - ${route.destination.getOrElse(() => "")}",
                    style: Theme.of(context).textTheme.bodyLarge,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  final Size preferredSize;
}
