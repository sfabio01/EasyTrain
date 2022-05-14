// times are stored in cronological order as milliseconds since 00:00
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const s016Di = [
  45300000,
  48000000,
  49800000,
  51600000,
  59400000,
  65100000,
  68400000
];

String? getNextS016Di(String arrival) {
  var hm = arrival.split(':');
  var aMillis = timeToMillis(int.parse(hm[0]), int.parse(hm[1]));
  for (var t in s016Di) {
    if (aMillis < t) {
      return DateFormat.Hm()
          .format(DateTime.fromMillisecondsSinceEpoch(t)
              .subtract(const Duration(hours: 1)))
          .toString();
    }
  }
}

int timeToMillis(int h, int m) {
  return h * 3600000 + m * 60000;
}
