import 'package:echo/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:echo/themes/echo_theme.dart';
import 'package:echo/screens/login_screen.dart';
import 'package:echo/screens/signup_screen.dart';
import 'package:echo/screens/main_screen.dart';
import 'package:echo/models/mini_player_manager.dart';
import 'firebase_options.dart';


/// Project Echo - Main entry point
/// Initializes Firebase and sets up app-wide providers and routes.


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );


  runApp(
    ChangeNotifierProvider(
      create: (_) => MiniPlayerManager(), // PROVIDER WRAP
      child: const EchoApp(),
    ),
  );
}

class EchoApp extends StatelessWidget {
  const EchoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Project Echo',
      theme: EchoTheme.darkTheme,
      home: const SplashScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/home': (context) => const MainScreen(),
      },
    );
  }
}
