import 'package:flutter/material.dart';
import 'package:mobile_lms/presentation/login/login_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hotel Linen Management',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // useMaterial3: true
      ),
      home: const LoginPage(),
    );
  }
}
