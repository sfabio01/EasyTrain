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
        centerTitle: true,
        backgroundColor: darkBlue,
        elevation: 0.0,
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
              ref.read(calendarProvider.notifier).changeDay(DateTime.now());
            },
            icon: const Icon(Icons.today_outlined),
            tooltip: "ADESSO",
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            decoration: const BoxDecoration(
              color: darkBlue,
              borderRadius:
                  BorderRadius.vertical(bottom: Radius.circular(28.0)),
              boxShadow: [
                BoxShadow(blurRadius: 4.0),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${route.departure.getOrElse(() => "")} - ${route.destination.getOrElse(() => "")}",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
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
                    .copyWith(color: calendarTextColor),
                weekdayStyle: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: calendarTextColor),
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
                          Card(
                            color: primaryBlue,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
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
                                          : "${solutions[index].duration[1]} ore, ${solutions[index].duration.substring(3, 5)} minuti"),
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
                            GestureDetector(
                              onTap: () {
                                ref
                                    .read(solutionsProvider.notifier)
                                    .getNextSolutions();
                              },
                              child: Card(
                                color: lightBlue,
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.arrow_downward_rounded,
                                        color: textColor,
                                        size: 16.0,
                                      ),
                                      Text(
                                        "TRENI SUCCESSIVI",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      ),
                                      const Icon(
                                        Icons.arrow_downward_rounded,
                                        color: textColor,
                                        size: 16.0,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
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
