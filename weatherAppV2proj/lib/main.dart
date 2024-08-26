import 'package:flutter/material.dart';
import 'package:weatherappv2proj/ex00/screens/weather_screen_ex00.dart';
import 'package:weatherappv2proj/ex01/screens/weather_screen_ex01.dart';
import 'package:weatherappv2proj/ex02/screens/weather_screen_ex02.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const WeatherScreenEx02(),
    );
  }
}
