import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easytrain/colors.dart';
import 'package:easytrain/providers/calendar_notifier.dart';
import 'package:easytrain/providers/solutions_notifier.dart';
import 'package:easytrain/widgets/concat_text.dart';
import 'package:table_calendar/table_calendar.dart';

final calendarProvider = StateNotifierProvider<CalendarNotifier, DateTime>(
    (ref) => CalendarNotifier());

final solutionsProvider =
    StateNotifierProvider<SolutionsNotifier, SolutionsState>(((ref) =>
        SolutionsNotifier(ref.watch(calendarProvider))..getSolutions()));

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EasyTrain',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: primaryBlue,
        primaryColorDark: darkBlue,
        primaryColorLight: lightBlue,
        errorColor: errorColor,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w700, color: textColor),
          bodyMedium: TextStyle(
              fontSize: 14, fontWeight: FontWeight.w700, color: textColor),
          bodySmall: TextStyle(
              fontSize: 12, fontWeight: FontWeight.w400, color: textColor),
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final solutionsState = ref.watch(solutionsProvider);
    final selectedDate = ref.watch(calendarProvider);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: darkBlue,
        title: Text(
          "TREVIGLIO - MILANO LAMBRATE",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        actions: [
          IconButton(
            onPressed: () {
              ref.read(calendarProvider.notifier).changeDay(DateTime.now());
            },
            icon: const Icon(Icons.today_outlined),
            tooltip: "OGGI",
          )
        ],
      ),
      body: Column(
        children: [
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
                    () => Container(),
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
