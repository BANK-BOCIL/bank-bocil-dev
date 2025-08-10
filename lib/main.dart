// lib/main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'src/providers/app_provider.dart';
import 'src/providers/auth_provider.dart';
import 'src/core/constants.dart';
import 'src/screens/auth_wrapper.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final settingsController = SettingsController(SettingsService());
  await settingsController.loadSettings();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()..initialize()),
        ChangeNotifierProvider(create: (_) => AppProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const AuthWrapper(), // <- root
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.settingsController,
  });

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthProvider()..initialize(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, AppProvider>(
          create: (context) => AppProvider(),
          // This logic now handles both login and logout correctly
          update: (context, authProvider, appProvider) {
            if (appProvider == null) throw Exception("AppProvider is null");

            // Check if the user state has changed
            if (appProvider.currentUser?.id != authProvider.currentUser?.id) {
              if (authProvider.currentUser == null) {
                // User has logged out, so clear all app data and listeners.
                appProvider.clearDataOnLogout();
              } else {
                // User has logged in or changed, so start listening to their data.
                appProvider.listenToData(authProvider.currentUser!);
              }
            }
            return appProvider;
          },
        ),
      ],
      child: ListenableBuilder(
        listenable: settingsController,
        builder: (BuildContext context, Widget? child) {
          return MaterialApp(
            restorationScopeId: 'app',
            theme: _buildLightTheme(),
            darkTheme: _buildDarkTheme(),
            themeMode: settingsController.themeMode,
            // Use AuthWrapper as the home screen for robust navigation
            home: const AuthWrapper(),
          );
        },
      ),
    );
  }

  ThemeData _buildLightTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.grey800,
      ),
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.dark,
      ),
    );
  }
}
