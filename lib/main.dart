import 'package:flutter/material.dart';
import 'package:protool/screens/auth_screen.dart';

void main() {
  runApp(const ProToolApp());
}

class ProToolApp extends StatelessWidget {
  const ProToolApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AuthScreen(),
    );
  }
}
