import 'package:flutter/material.dart';
import 'package:weatherapp/weather_app.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: const WeatherhomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
