// lib/src/screens/auth_wrapper.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../models/user.dart';
import 'auth/auth_screen.dart';
import 'parent/parent_main_screen.dart';
import 'main_navigation_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // Listen to the AuthProvider to get the current user.
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    // While the provider is checking the initial auth state, show a loading screen.
    if (authProvider.isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // If there is no user, show the main authentication choice screen.
    if (user == null) {
      return const AuthScreen();
    } else {
      // If there is a user, direct them to the correct screen.
      if (user.type == UserType.parent) {
        return const ParentMainScreen();
      } else {
        // For a child user, show the main screen with bottom navigation.
        return MainNavigationScreen(user: user);
      }
    }
  }
}
