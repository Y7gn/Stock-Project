import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_3/Screens/HomePage.dart';
import 'package:dio/dio.dart';
import 'package:flutter_application_3/Screens/StepperPage.dart';
import 'package:flutter_application_3/Screens/StockListPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (context) => const HomePage(),
        '/StepperPage': (context) => const StepperPage(),
        '/stockListPage': (context) => const StockListPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
