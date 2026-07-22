import 'package:eshop_app/app/routes/app_pages.dart';
import 'package:eshop_app/presentation/screens/welcome_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomeScreen(),
   routes:  AppPages.routes,
    );
  }
}


