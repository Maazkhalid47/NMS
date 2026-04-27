import 'package:flutter/material.dart';
import 'package:software_management/view/dashboard_screen.dart';
import 'package:software_management/view/logIn_screen.dart';
import 'package:software_management/view/profile_screen.dart';
import 'package:software_management/view/splash_screen.dart';
import 'package:software_management/view/task_details_screen.dart';
import 'package:software_management/view/task_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router( 
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Inter',
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const TaskDetailsScreen()
    );
  }
}

