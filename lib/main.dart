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
        fontFamily: "SourceSansPro",
        primaryColor: primaryBlue,
        primaryColorDark: darkBlue,
        primaryColorLight: lightBlue,
        errorColor: errorColor,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w700, color: textColor),
          bodyMedium: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w600, color: textColor),
          bodySmall: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w300, color: textColor),
        ),
      ),
      home: const SplashPage(),
    );
  }
}
