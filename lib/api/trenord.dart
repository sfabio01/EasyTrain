import 'package:dartz/dartz.dart';
import 'package:easytrain/models/solution.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const String domain = 'www.trenord.it';
const String path = '/store-api/solutions';
const String pathNext = '/store-api/solutions/next/0';

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
    next ? pathNext : path,
    {
      'departure': departure,
      'destination': destination,
      'date': date,
      'fromHour': fromHour,
      'toHour': toHour,
    },
  );
  try {
    final res = await http.get(uri);
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
      ));
    }
    return right(solutions);
  } catch (e) {
    return left(e.toString());
  }
}
