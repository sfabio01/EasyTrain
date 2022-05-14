import 'dart:convert';

class Solution {
  final String trainName;
  final String direction;
  final String departureTime;
  final String arrivalTime;
  final String duration;
  final String delay;
  final String change;
  final int crowding;

  Solution({
    required this.trainName,
    required this.direction,
    required this.departureTime,
    required this.arrivalTime,
    required this.duration,
    required this.delay,
    required this.change,
    required this.crowding,
  });

  Solution copyWith({
    String? trainName,
    String? direction,
    String? departureTime,
    String? arrivalTime,
    String? duration,
    String? delay,
    String? change,
    int? crowding,
  }) {
    return Solution(
      trainName: trainName ?? this.trainName,
      direction: direction ?? this.direction,
      departureTime: departureTime ?? this.departureTime,
      arrivalTime: arrivalTime ?? this.arrivalTime,
      duration: duration ?? this.duration,
      delay: delay ?? this.delay,
      change: change ?? this.change,
      crowding: crowding ?? this.crowding,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'trainName': trainName,
      'direction': direction,
      'departureTime': departureTime,
      'arrivalTime': arrivalTime,
      'duration': duration,
      'delay': delay,
      'change': change,
      'crowding': crowding,
    };
  }

  factory Solution.fromMap(Map<String, dynamic> map) {
    return Solution(
      trainName: map['trainName'] ?? '',
      direction: map['direction'] ?? '',
      departureTime: map['departureTime'] ?? '',
      arrivalTime: map['arrivalTime'] ?? '',
      duration: map['duration'] ?? '',
      delay: map['delay'] ?? '',
      change: map['change'] ?? '',
      crowding: map['crowding'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Solution.fromJson(String source) =>
      Solution.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Solution(trainName: $trainName, direction: $direction, departureTime: $departureTime, arrivalTime: $arrivalTime, duration: $duration, delay: $delay)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Solution &&
        other.trainName == trainName &&
        other.direction == direction &&
        other.departureTime == departureTime &&
        other.arrivalTime == arrivalTime &&
        other.duration == duration &&
        other.delay == delay &&
        other.change == change &&
        other.crowding == crowding;
  }

  @override
  int get hashCode {
    return trainName.hashCode ^
        direction.hashCode ^
        departureTime.hashCode ^
        arrivalTime.hashCode ^
        duration.hashCode ^
        delay.hashCode ^
        change.hashCode ^
        crowding.hashCode;
  }
}
