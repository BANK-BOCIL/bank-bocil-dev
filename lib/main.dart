// lib/main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

import 'src/providers/auth_provider.dart';
import 'src/providers/app_provider.dart';
import 'src/screens/auth_wrapper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()..initialize()),
        ChangeNotifierProxyProvider<AuthProvider, AppProvider>(
          create: (_) => AppProvider(),
          update: (_, auth, app) {
            final a = app ?? AppProvider();
            final u = auth.currentUser;
            if (u == null) a.clearDataOnLogout(); else a.listenToData(u);
            return a;
          },
        ),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AuthWrapper(),
      ),
    ),
  );

}
