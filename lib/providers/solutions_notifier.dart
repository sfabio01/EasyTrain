import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:easytrain/api/trenord.dart';
import 'package:easytrain/models/solution.dart';
import 'package:easytrain/providers/route_notifier.dart';

class SolutionsNotifier extends StateNotifier<SolutionsState> {
  final DateTime date;
  final RouteState routeState;

  SolutionsNotifier(this.date, this.routeState)
      : super(SolutionsState.initial());

  void getSolutions() async {
    if (routeState.departure.isSome() && routeState.destination.isSome()) {
      state = SolutionsState.initial().copyWith(isLoading: true);
      final String dateString = DateFormat("yyyyMMdd").format(date);
      final String fromHour = DateFormat("HH:mm").format(date);
      final res = await fetchSolutions(
        routeState.departure.getOrElse(() => ""),
        routeState.destination.getOrElse(() => ""),
        dateString,
        fromHour,
        "23:59",
        false,
      );
      state = res.fold(
        (err) => SolutionsState.initial()
            .copyWith(errorMessage: err, isLoading: false),
        (r) => SolutionsState(
          solutions: some(r),
          isLast: r.isEmpty,
          lastDepTime: r.isNotEmpty ? r.last.departureTime : "00:00",
          isLoading: false,
          errorMessage: "",
        ),
      );
    }
  }

  void getNextSolutions() async {
    if (routeState.departure.isSome() && routeState.destination.isSome()) {
      final String dateString = DateFormat("yyyyMMdd").format(date);

      final res = await fetchSolutions(
          routeState.departure.getOrElse(() => ""),
          routeState.destination.getOrElse(() => ""),
          dateString,
          state.lastDepTime,
          "23:59",
          true);

      state = res.fold(
        (l) => state.copyWith(errorMessage: l),
        (r) {
          if (r.isNotEmpty) {
            r.removeAt(0);
          }
          if (r.isEmpty) {
            return state.copyWith(isLast: true);
          } else {
            return SolutionsState.initial().copyWith(
              solutions:
                  some(state.solutions.fold(() => r, (a) => [...a, ...r])),
              isLast: r.isEmpty,
              lastDepTime: r.last.departureTime,
            );
          }
        },
      );
    }
  }
}

class SolutionsState {
  final Option<List<Solution>> solutions;
  final bool isLast;
  final String lastDepTime;
  final bool isLoading;
  final String errorMessage;

  SolutionsState({
    required this.solutions,
    required this.isLast,
    required this.lastDepTime,
    required this.isLoading,
    required this.errorMessage,
  });

  factory SolutionsState.initial() => SolutionsState(
        solutions: none(),
        isLast: false,
        lastDepTime: "00:00",
        isLoading: false,
        errorMessage: "",
      );

  SolutionsState copyWith({
    Option<List<Solution>>? solutions,
    bool? isLast,
    String? lastDepTime,
    bool? isLoading,
    String? errorMessage,
  }) {
    return SolutionsState(
      solutions: solutions ?? this.solutions,
      isLast: isLast ?? this.isLast,
      lastDepTime: lastDepTime ?? this.lastDepTime,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  String toString() {
    return 'SolutionsState(solutions: $solutions, isLast: $isLast, lastDepTime: $lastDepTime, isLoading: $isLoading, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SolutionsState &&
        other.solutions == solutions &&
        other.isLast == isLast &&
        other.lastDepTime == lastDepTime &&
        other.isLoading == isLoading &&
        other.errorMessage == errorMessage;
  }

  @override
  int get hashCode {
    return solutions.hashCode ^
        isLast.hashCode ^
        lastDepTime.hashCode ^
        isLoading.hashCode ^
        errorMessage.hashCode;
  }
}
