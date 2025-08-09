// lib/main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'src/providers/auth_provider.dart' as local_auth_provider;
import 'src/screens/splash_screen.dart';
import 'firebase_options.dart'; // Import file konfigurasi Firebase

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Inisialisasi Firebase dengan opsi yang dibuat oleh flutterfire
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => local_auth_provider.AuthProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Atur home ke SplashScreen sebagai entry point
      home: const SplashScreen(),
    );
  }
}
