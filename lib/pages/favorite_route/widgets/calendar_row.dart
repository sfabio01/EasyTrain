import 'package:easytrain/colors.dart';
import 'package:easytrain/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarRow extends ConsumerWidget {
  const CalendarRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(calendarProvider);
    return TableCalendar(
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
        selectedDecoration:
            const BoxDecoration(color: darkBlue, shape: BoxShape.circle),
        todayDecoration:
            const BoxDecoration(color: primaryBlue, shape: BoxShape.circle),
      ),
    );
  }
}
