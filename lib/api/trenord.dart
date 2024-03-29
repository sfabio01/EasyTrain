import 'package:dartz/dartz.dart';
import 'package:easytrain/models/solution.dart';
import 'package:easytrain/pages/select_station/select_station_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const String domain = 'www.trenord.it';

Future<Either<String, List<Solution>>> fetchSolutions(
  String departure,
  String destination,
  String date,
  String fromHour,
  String toHour,
  bool next,
) async {
  final uri = Uri.https(
    domain,
    next ? '/store-api/solutions/next/0' : '/store-api/solutions',
    {
      'departure': departure,
      'destination': destination,
      'date': date,
      'fromHour': fromHour,
      'toHour': toHour,
    },
  );
  try {
    final res = await http.get(
      uri,
      headers: {
        'user-agent':
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36 Edg/110.0.1587.56'
      },
    );
    final jsonData = json.decode(res.body);
    List<Solution> solutions = [];
    for (var sol in jsonData) {
      solutions.add(Solution(
        trainName:
            "${sol['journey_list'][0]['train']['train_category']} ${sol['journey_list'][0]['train']['train_id']}",
        direction: sol['journey_list'][0]['train']['direction'],
        departureTime: sol['dep_time'],
        arrivalTime: sol['arr_time'],
        duration: sol['duration'],
        delay: sol['delay'] ?? '',
        change: sol['change'],
        crowding: sol['journey_list'][0]['train']['average_crowding'] ?? -1,
      ));
    }
    return right(solutions);
  } catch (e) {
    return left(e.toString());
  }
}

Future<Either<String, List<String>>> fetchStations(
  String query,
  StationType type,
) async {
  final uri = Uri.https(
    domain,
    type == StationType.departure
        ? '/store-api/departures'
        : '/store-api/destinations',
    {
      'name': query,
    },
  );
  try {
    final res = await http.get(
      uri,
      headers: {
        'user-agent':
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36 Edg/110.0.1587.56'
      },
    );
    final jsonData = json.decode(res.body);
    print(jsonData);
    List<String> stations = [];
    for (var s in jsonData) {
      stations.add(s['name']);
    }
    return right(stations);
  } catch (e) {
    return left(e.toString());
  }
}
