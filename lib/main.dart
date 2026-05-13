import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:protool/screens/auth_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
