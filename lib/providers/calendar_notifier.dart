import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CalendarNotifier extends StateNotifier<DateTime> {
  CalendarNotifier() : super(DateTime.now());

  void changeDay(DateTime day) {
    state = DateTime(day.year, day.month, day.day, state.hour, state.minute);
  }

  void changeTime(TimeOfDay time) {
    state =
        DateTime(state.year, state.month, state.day, time.hour, time.minute);
  }

  void changeDateTime(DateTime dateTime) {
    state = dateTime;
  }
}
