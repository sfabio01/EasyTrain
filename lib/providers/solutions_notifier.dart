import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:easytrain/api/trenord.dart';
import 'package:easytrain/models/solution.dart';

class SolutionsNotifier extends StateNotifier<SolutionsState> {
  final DateTime date;
  SolutionsNotifier(this.date) : super(SolutionsState.initial());

  void getSolutions() async {
    state = SolutionsState.initial().copyWith(isLoading: true);
    final String dateString = DateFormat("yyyyMMdd").format(date);
    final String fromHour = DateFormat("HH:mm").format(date);
    final res = await fetchSolutions(
        "TREVIGLIO", "MILANO LAMBRATE", dateString, fromHour, "23:59", false);
    state = SolutionsState(
      solutions: some(res),
      isLast: res.isEmpty,
      lastDepTime: res.isNotEmpty ? res.last.departureTime : "00:00",
      isLoading: false,
    );
  }

  void getNextSolutions() async {
    final String dateString = DateFormat("yyyyMMdd").format(date);

    final res = await fetchSolutions("TREVIGLIO", "MILANO LAMBRATE", dateString,
        state.lastDepTime, "23:59", true);
    res.removeAt(0);

    if (res.isEmpty) {
      state = state.copyWith(isLast: true, isLoading: false);
    } else {
      state = SolutionsState(
        solutions: some(state.solutions.fold(() => res, (a) => [...a, ...res])),
        isLast: res.isEmpty,
        lastDepTime: res.last.departureTime,
        isLoading: false,
      );
    }
  }
}

class SolutionsState {
  final Option<List<Solution>> solutions;
  final bool isLast;
  final String lastDepTime;
  final bool isLoading;

  SolutionsState({
    required this.solutions,
    required this.isLast,
    required this.lastDepTime,
    required this.isLoading,
  });

  factory SolutionsState.initial() => SolutionsState(
      solutions: const None(),
      isLast: false,
      lastDepTime: "00:00",
      isLoading: false);

  SolutionsState copyWith({
    Option<List<Solution>>? solutions,
    bool? isLast,
    String? lastDepTime,
    bool? isLoading,
  }) {
    return SolutionsState(
      solutions: solutions ?? this.solutions,
      isLast: isLast ?? this.isLast,
      lastDepTime: lastDepTime ?? this.lastDepTime,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  String toString() =>
      'SolutionsState(solutions: $solutions, isLast: $isLast, lastDepTime: $lastDepTime, isLoading: $isLoading)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SolutionsState &&
        other.solutions == solutions &&
        other.isLast == isLast &&
        other.lastDepTime == lastDepTime &&
        other.isLoading == isLoading;
  }

  @override
  int get hashCode =>
      solutions.hashCode ^
      isLast.hashCode ^
      lastDepTime.hashCode ^
      isLoading.hashCode;
}
