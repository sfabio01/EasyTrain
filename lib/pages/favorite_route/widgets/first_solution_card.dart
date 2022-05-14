import 'package:easytrain/api/start_mobility.dart';
import 'package:easytrain/colors.dart';
import 'package:easytrain/models/solution.dart';
import 'package:easytrain/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FirstSolutionCard extends ConsumerWidget {
  final Solution solution;
  const FirstSolutionCard(this.solution, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: const BoxDecoration(
        color: darkBlue,
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
        boxShadow: [
          BoxShadow(blurRadius: 4.0, offset: Offset(0, 2.0)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    solution.trainName,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    "DIRETTO A " + solution.direction,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    solution.departureTime.substring(0, 5),
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontSize: 40.0),
                  ),
                  // if (timeDifference(solution.departureTime.substring(0, 5))
                  //     .isNotEmpty)
                  //   Text(
                  //     timeDifference(solution.departureTime.substring(0, 5)),
                  //     style: Theme.of(context).textTheme.bodySmall,
                  //   )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

String timeDifference(String depTime) {
  final now = DateTime.now();
  final dep = DateTime(now.year, now.month, now.day,
      int.parse(depTime.substring(0, 2)), int.parse(depTime.substring(3, 5)));
  final diff = dep.difference(now);
  final hours = diff.inHours;
  final minutes = diff.inMinutes - hours * 60;
  if (hours < 0 || minutes < 0) {
    return "";
  }
  return "${hours > 0 ? hours.toString() + ' H ' : ''}$minutes MIN";
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
