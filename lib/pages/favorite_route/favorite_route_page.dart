import 'package:easytrain/colors.dart';
import 'package:easytrain/providers/providers.dart';
import 'package:easytrain/widgets/concat_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

class FavoriteRoutePage extends ConsumerWidget {
  const FavoriteRoutePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final solutionsState = ref.watch(solutionsProvider);
    final selectedDate = ref.watch(calendarProvider);
    final route = ref.watch(routeProvider);
    return Scaffold(
      appBar: AppBar(
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
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
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
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: TableCalendar(
              focusedDay: selectedDate,
              selectedDayPredicate: (day) {
                return isSameDay(selectedDate, day);
              },
              firstDay: DateTime.now().subtract(const Duration(days: 7)),
              lastDay: DateTime.now().add(const Duration(days: 7)),
              calendarFormat: CalendarFormat.week,
              onFormatChanged: (_) {},
              onDaySelected: (selectedDay, focusedDay) {
                ref.read(calendarProvider.notifier).changeDay(selectedDay);
                ref.read(solutionsProvider.notifier).getSolutions();
              },
              headerVisible: false,
              daysOfWeekStyle: DaysOfWeekStyle(
                weekendStyle: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: calendarTextColor, fontSize: 14.0),
                weekdayStyle: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: calendarTextColor, fontSize: 14.0),
              ),
              calendarStyle: CalendarStyle(
                defaultTextStyle: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: calendarTextColor),
                weekendTextStyle: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: calendarTextColor),
                holidayTextStyle: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: calendarTextColor),
                outsideTextStyle: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: calendarTextColor),
                selectedDecoration: const BoxDecoration(
                    color: darkBlue, shape: BoxShape.circle),
                todayDecoration: const BoxDecoration(
                    color: primaryBlue, shape: BoxShape.circle),
              ),
            ),
          ),
          Expanded(
            child: solutionsState.isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: primaryBlue))
                : solutionsState.solutions.fold(
                    () => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (solutionsState.errorMessage.isNotEmpty)
                            Text(
                              solutionsState.errorMessage,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(color: errorColor),
                              textAlign: TextAlign.center,
                            ),
                          TextButton(
                            onPressed: () {
                              ref
                                  .read(solutionsProvider.notifier)
                                  .getSolutions();
                            },
                            child: Text(
                              "RICARICA",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(color: primaryBlue),
                            ),
                          ),
                        ],
                      ),
                    ),
                    (solutions) => ListView.builder(
                      itemCount: solutions.length,
                      itemBuilder: (context, index) => Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Container(
                              padding: const EdgeInsets.all(12.0),
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4.0)),
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 4.0, offset: Offset(0, 2.0)),
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
                                  Text(
                                    solutions[index].trainName,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  Text(
                                    "DIRETTO A " + solutions[index].direction,
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                  const SizedBox(height: 8.0),
                                  ConcatText(
                                      title: "PARTENZA",
                                      value: solutions[index]
                                          .departureTime
                                          .substring(0, 5)),
                                  ConcatText(
                                      title: "ARRIVO",
                                      value: solutions[index]
                                          .arrivalTime
                                          .substring(0, 5)),
                                  const SizedBox(height: 8.0),
                                  ConcatText(
                                      title: "DURATA",
                                      value: solutions[index]
                                                  .duration
                                                  .substring(0, 2) ==
                                              "00"
                                          ? "${solutions[index].duration.substring(3, 5)} minuti"
                                          : "${solutions[index].duration[1]}h, ${solutions[index].duration.substring(3, 5)} minuti"),
                                  if (solutions[index].delay.isNotEmpty)
                                    ConcatText(
                                        title: "RITARDO",
                                        value: solutions[index].delay),
                                ],
                              ),
                            ),
                          ),
                          if (index == solutions.length - 1 &&
                              !solutionsState.isLast)
                            TextButton(
                              onPressed: () {
                                ref
                                    .read(solutionsProvider.notifier)
                                    .getNextSolutions();
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.arrow_downward_rounded,
                                    color: primaryBlue,
                                    size: 16.0,
                                  ),
                                  Text(
                                    "TRENI SUCCESSIVI",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(color: primaryBlue),
                                  ),
                                  const Icon(
                                    Icons.arrow_downward_rounded,
                                    color: primaryBlue,
                                    size: 16.0,
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
