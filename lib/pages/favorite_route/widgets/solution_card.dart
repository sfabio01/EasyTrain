import 'package:easytrain/api/start_mobility.dart';
import 'package:easytrain/colors.dart';
import 'package:easytrain/models/solution.dart';
import 'package:easytrain/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SolutionCard extends ConsumerWidget {
  final Solution solution;
  const SolutionCard(this.solution, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
        boxShadow: [
          BoxShadow(blurRadius: 4.0, offset: Offset(0, 2.0)),
        ],
        gradient: LinearGradient(
          colors: [
            primaryBlue,
            darkBlue,
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                solution.trainName,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              solution.crowding != -1
                  ? Icon(Icons.group,
                      color: solution.crowding < 50
                          ? Colors.green
                          : solution.crowding < 80
                              ? Colors.yellow
                              : Colors.red)
                  : Container(),
            ],
          ),
          Text(
            "DIRETTO A " + solution.direction,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 8.0),
          ConcatText(
              title: "PARTENZA", value: solution.departureTime.substring(0, 5)),
          ConcatText(
              title: "ARRIVO", value: solution.arrivalTime.substring(0, 5)),
          const SizedBox(height: 8.0),
          ConcatText(
              title: "DURATA",
              value: solution.duration.substring(0, 2) == "00"
                  ? "${solution.duration.substring(3, 5)} minuti"
                  : "${solution.duration[1]}h, ${solution.duration.substring(3, 5)} minuti"),
          if (solution.delay.isNotEmpty)
            ConcatText(title: "RITARDO", value: solution.delay),
          if (solution.change != "0")
            ConcatText(title: "CAMBI", value: solution.change),
          if (ref.read(routeProvider).destination.getOrElse(() => '') ==
                  'TREVIGLIO' &&
              getNextS016Di(solution.arrivalTime.substring(0, 5)) != null)
            ConcatText(
              title: "PROSSIMO BUS",
              value: getNextS016Di(solution.arrivalTime.substring(0, 5))!,
            ),
        ],
      ),
    );
  }
}

class ConcatText extends StatelessWidget {
  final String title;
  final String value;

  const ConcatText({Key? key, required this.title, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title + " ",
          style: Theme.of(context).textTheme.bodySmall,
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
