import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(AcademicoApp());
}

class AcademicoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Acadêmico',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
