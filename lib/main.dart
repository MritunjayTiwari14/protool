import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:protool/screens/auth_screen.dart';
import 'package:protool/screens/tasks_screen.dart';
import 'package:protool/theme.dart';
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
      title: 'Task Manager',
      theme: darkTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // If connection state is waiting, show a loading spinner
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          // If we have a user, show the tasks screen
          if (snapshot.hasData) {
            return TasksScreen();
          }
          // Otherwise, show the auth screen
          return const AuthScreen();
        },
      ),
    );
  }
}
