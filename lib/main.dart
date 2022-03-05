import 'package:easytrain/pages/splash/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easytrain/colors.dart';

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
      home: const SplashPage(),
    );
  }
}
